import 'package:json_annotation/json_annotation.dart';

part 'usluga.g.dart';

@JsonSerializable(explicitToJson: true)
class Usluga {
  String? usluga;
  int? opcijaId;
  String? img;

  Usluga(int opcijaId) {
    this.opcijaId = opcijaId;

    switch(opcijaId) {
      case 1:
        this.usluga = "Zamjena motornoga ulja";
        this.img = "assets/images/ulje.svg";
        break;
      case 2:
        this.usluga = "Autopraonica";
        this.img = "assets/images/autopraonica.svg";
        break;
      case 3:
        this.usluga = "Opskrba plovila";
        this.img = "assets/images/brod.svg";
        break;
      case 4:
        this.usluga = "Hot spot/ Wifi";
        this.img = "assets/images/wifi.svg";
        break;
      case 5:
        this.usluga = "Bankomat";
        this.img = "assets/images/bankomat.svg";
        break;
      case 6:
        this.usluga = "WC";
        this.img = "assets/images/wc.svg";
        break;
      case 7:
        this.usluga = "Mjenjačnica";
        this.img = "assets/images/mjenjacnica.svg";
        break;
      case 8:
        this.usluga = "Trgovina";
        this.img = "assets/images/trgovina.svg";
        break;
      case 9:
        this.usluga = "Restoran";
        this.img = "assets/images/restoran.svg";
        break;
      case 10:
        this.usluga = "Caffe bar";
        this.img = "assets/images/coffee-bar.svg";
        break;
      case 11:
        this.usluga = "Pekarski proizvodi";
        this.img = "assets/images/pekara.svg";
        break;
      case 12:
        this.usluga = "WC za invalide";
        this.img = "assets/images/invalid.svg";
        break;
      case 13:
        this.usluga = "Previjalište za bebe";
        this.img = "assets/images/bebe.svg";
        break;
      case 14:
        this.usluga = "Tuš";
        this.img = "assets/images/tus.svg";
        break;
      case 15:
        this.usluga = "Dječje igralište/Igraonica";
        this.img = "assets/images/igraliste.svg";
        break;
      case 16:
        this.usluga = "Hotel/Motel";
        this.img = "assets/images/motel.svg";
        break;
      case 17:
        this.usluga = "Parking za autobuse";
        this.img = "assets/images/parking.svg";
        break;
      case 18:
        this.usluga = "Mjesto za kućne ljubmice";
        this.img = "assets/images/psi.svg";
        break;
      case 19:
        this.usluga = "Otvoreno 24 sata";
        this.img = "assets/images/24sat.svg";
        break;
      default:
        this.usluga = "";
        this.img = "";
    }
  }

  factory Usluga.fromJson(Map<String, dynamic> json) => _$UslugaFromJson(json);

  Map<String, dynamic> toJson() => _$UslugaToJson(this);

}