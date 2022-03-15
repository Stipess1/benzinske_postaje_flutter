import 'dart:io';

import 'package:benzinske_postaje/model/usluga.dart';
import 'package:benzinske_postaje/model/cijenik.dart';
import 'package:benzinske_postaje/model/gorivo.dart';
import 'package:benzinske_postaje/model/postaja.dart';
import 'package:benzinske_postaje/model/radno_vrijeme.dart';
import 'package:benzinske_postaje/screens/home/controller/igas_stations_controller.dart';
import 'package:benzinske_postaje/screens/home/view/IHome.dart';
import 'package:benzinske_postaje/util/api.dart';
import 'package:benzinske_postaje/util/util.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class GasStationsController implements IGasStationsController{

  late IHome iHome;

  GasStationsController(IHome iHome) {
    this.iHome = iHome;
  }

  double jsonToDouble(dynamic value) {
    return value.toDouble();
  }

  dynamic myEncode(dynamic item) {
    if(item is DateTime) {
      return item.toIso8601String();
    }
    return item;
  }

  @override
  Future<void> fetchGasStations() async {

    List<Postaja> list = [];

    final f = DateFormat("yyyy-MM-dd");
    var to = DateTime.now();
    var format = f.format(to);
    var today = DateTime.parse(format);
    final box = GetStorage();
    // box.erase();
    var time = box.read('time');
    var fuel = box.read('fuel');
    print("fuel je $fuel");
    if(fuel == null)
      fuel = 8;
    var diffDays = 1;
    if(time != null) {
      time = time.substring(1);
      time = DateTime.parse(time.substring(0, time.length - 1));

      diffDays = Util.daysBetween(time, today);
    }
    // diffDays = 2;
    if(diffDays >= 1 || time == null) {
      box.write('time', jsonEncode(today, toEncodable: myEncode));
      print("API FETCH");
      var url = Uri.parse("https://benzinske-postaje.herokuapp.com");
      var response;
      try {
        response = await http.get(url, headers: {
          HttpHeaders.authorizationHeader: Api.key,
        });
      }catch(e) {
        iHome.onFailureFetch("Greska kod servera");
        return;
      }

      if(response.statusCode == 200) {

        final body = json.decode(utf8.decode(response.bodyBytes));

        var postaje = body['postajas'];

        List<Map<String, dynamic>> toJson = [];
        List<Map<String, dynamic>> toJsonGorivo = [];

        for(var i = 0; i < postaje.length; i++) {
          var postaja = new Postaja();
          var web = postaje[i];

          postaja.adresa = web['adresa'].replaceAll('/\u00A0/', " ");
          postaja.id = web['id'];
          if(web['lat'] != "15° 31.2440' E" && web['lat'] != "")
            postaja.lat = double.parse(web['lat']);

          if(web['long'] != "" && web['long'] != "45° 39.4112' N")
            postaja.lon = double.parse(web['long']);

          postaja.naziv = web['naziv'].replaceAll("/\u00A0/", " ");
          postaja.mjesto = web['mjesto'].replaceAll("/\u00A0/", " ");
          postaja.obveznikId = web['obveznik_id'];

          for(var j = 0; j < web['cjenici'].length; j++) {
            var cijenik = new Cijenik();

            cijenik.id = web['cjenici'][j]['id'];
            cijenik.gorivoId = web['cjenici'][j]['gorivo_id'];
            cijenik.cijena = jsonToDouble(web['cjenici'][j]['cijena']);
            getNaziv(cijenik, body['gorivos']);
            postaja.cijenici.add(cijenik);
          }

          for(var j = 0; j < postaja.cijenici.length; j++) {
            if(postaja.cijenici[j].vrstaGorivoId == fuel) {
              postaja.gorivo = postaja.cijenici[j].cijena!.toStringAsFixed(2);
              break;
            }
          }
          // Ako ne postoji dizel na benzinskoj
          if(postaja.gorivo!.isEmpty) {
            postaja.gorivo = "---";
          }

          for(var j = 0; j < web['opcije'].length; j++) {
            postaja.opcije.add(new Usluga(web['opcije'][j]['opcija_id']));
          }

          var radnoVrijeme = new RadnoVrijeme();
          for(var j = 0; j < web['radnaVremena'].length; j++) {
            var vrijeme = web['radnaVremena'][j];

            if(vrijeme['vrsta_dana_id'] == 1) {
              radnoVrijeme.ponPet = parseTime(vrijeme['pocetak'] + '-' + vrijeme['kraj'], postaja, RadnoVrijeme());
            } else if(vrijeme['vrsta_dana_id'] == 2) {
              radnoVrijeme.sub = parseTime(vrijeme['pocetak'] + '-' + vrijeme['kraj'], postaja, RadnoVrijeme());
            } else if(vrijeme['vrsta_dana_id'] == 3) {
              radnoVrijeme.ned = parseTime(vrijeme['pocetak'] + '-' + vrijeme['kraj'], postaja, RadnoVrijeme());
            } else if(vrijeme['vrsta_dana_id'] == 4) {
              radnoVrijeme.praznik = parseTime(vrijeme['pocetak'] + '-' + vrijeme['kraj'], postaja, RadnoVrijeme());
            }
          }

          postaja.radnaVremena = radnoVrijeme;
          postaja.trenutnoRadnoVrijeme = this.parseTime("", postaja, radnoVrijeme);

          for(var j = 0; j < body['obvezniks'].length; j++) {
            if(body['obvezniks'][j]['id'] == postaja.obveznikId) {
              postaja.obveznik = body['obvezniks'][j]['naziv'];
              if( body['obvezniks'][j]['logo'] != null) {
                postaja.img = "https://webservis.mzoe-gor.hr/img/" + body['obvezniks'][j]['logo'];
              } else {
                postaja.img = "assets/images/icon2.png";
              }
            }
          }

          if(postaja.obveznik!.contains("Konzum")) {
            postaja.img = "https://www.konzum.hr/assets/1i0/frontend/facebook/facebook_meta_image-5b88c5da1a557eaf6501d1fb63f883285f9346300d9b2e0a196dc32047a9542a.png";
          } else if(postaja.obveznik!.contains("AGS")) {
            postaja.img = "assets/images/ags.png";
          } else if(postaja.obveznik!.contains("Coral")) {
            postaja.img = "assets/images/shell.png";
          } else if(postaja.obveznik!.contains("INA")) {
            postaja.img = "assets/images/ina.png";
          } else if(postaja.obveznik!.contains("Crodux")) {
            postaja.img = "assets/images/crodux.png";
          }

          list.add(postaja);
          toJson.add(postaja.toJson());
        }

        /*
      vrstaGoriva
      id = 1 - eurosuper 95 sa aditivima
      id = 2 - eurosuper 95 bez aditiva
      id = 5 - eurosuper 100 sa aditivima
      id = 6 - eurosuper 100 bez aditiva
      id = 7 - eurodizel sa aditivima
      id = 8 - eurodizel bez aditiva
      id = 9 - UNP (autoplin)
      id = 10 - plinsko ulje LU EL (lož ulje)
      id = 11 - plinsko ulje obojano plavom bojom (plavi dizel)
      id = 12 - bioetanol
      id = 13 - biodizel
      id - 14 - bioplin
      id - 15 - biometanol
      id - 16 - biodimetileter
      id - 17 - Bio-ETBE
      id - 18 - Bio-MTBE
      id - 19 - Biovodik
      id - 20 - Smjesa UNP za boce sadržaja 7.5kg
      id - 21 - Smjesa UNP za boce sadržaja 10kg
      id - 22 - Smjesa UNP za boce sadržaja 35kg
      */

        List<Gorivo> goriva = [];
        for(int i = 0; i < body['gorivos'].length; i++) {
          var gorivo = Gorivo();
          var web = body['gorivos'][i];

          gorivo.id = web['id'];
          if (web['naziv'] != null) {
            gorivo.naziv = web['naziv'].replaceAll("/\u00A0/", " ");
          }
          gorivo.obveznikId = web['obveznik_id'];
          gorivo.vrstaGorivaId = web['vrsta_goriva_id'];

          goriva.add(gorivo);
          toJsonGorivo.add(gorivo.toJson());
        }


        print(toJson.length);
        print(list.length);
        box.write("postaje", toJson);
        box.write("goriva", toJsonGorivo);
        iHome.onSuccessFetch(list, goriva, true);
      } else {
        iHome.onFailureFetch("Greska kod servera");
      }
    } else {

      var postaje = box.read('postaje');
      var goriva = box.read('goriva');

      List<Postaja> list = [];
      List<Gorivo> gorivoList = [];
      for(int i = 0; i < postaje.length; i++) {
         list.add(Postaja.fromJson(postaje[i]));
         list[i].trenutnoRadnoVrijeme = parseTime("", list[i], list[i].radnaVremena!);
      }

      for(int i = 0; i < goriva.length; i++) {
        gorivoList.add(Gorivo.fromJson(goriva[i]));
      }

      iHome.onSuccessFetch(list, gorivoList, false);

    }

  }

  void getNaziv(Cijenik cijenik, dynamic data) {
      for(var i = 0; i < data.length; i++) {
        if(cijenik.gorivoId == data[i]['id']) {
          cijenik.naziv = data[i]['naziv'];
          cijenik.vrstaGorivoId = data[i]['vrsta_goriva_id'];
          break;
        }
      }
  }

  String parseTime(String benga, Postaja postaja, RadnoVrijeme radnoVrijeme) {

    var vrijeme = benga;
    var date = new DateTime.now();
    if(radnoVrijeme.ponPet!.isNotEmpty) {
      if(date.weekday >= 1 && date.weekday <= 5) {
        return radnoVrijeme.ponPet!;
      } else if(date.weekday == 7) {
        return radnoVrijeme.ned!;
      } else if(date.weekday == 6) {
        return radnoVrijeme.sub!;
      }
    }

    if(vrijeme.isEmpty) return "";

    var splitTime = vrijeme.split("-");

    if(splitTime[0].length == 8) {
      splitTime[0] = splitTime[0].substring(0, splitTime[0].length - 3);
    }

    splitTime[1] = splitTime[1].substring(0, splitTime[1].length - 3);

    var time = splitTime[0] + "-" + splitTime[1];

    var pocetnoVrijeme = splitTime[0].substring(0, splitTime[0].length - 3); // 6
    var zavrsnoVrijeme = splitTime[1].substring(0, splitTime[1].length - 3); // 20

    if(date.hour < int.parse(zavrsnoVrijeme) && date.hour > int.parse(pocetnoVrijeme)) {
      postaja.otvoreno = true;
    } else {
      if(zavrsnoVrijeme == "24" && pocetnoVrijeme == "00") {
        postaja.otvoreno = true;
      } else {
        postaja.otvoreno = false;
      }
    }

    return time;
  }

}