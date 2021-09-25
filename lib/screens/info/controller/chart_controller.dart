import 'dart:convert';

import 'package:benzinske_postaje/model/web_cijenik.dart';
import 'package:benzinske_postaje/screens/info/controller/ichart_controller.dart';
import 'package:benzinske_postaje/screens/info/view/ibenzinska_info.dart';
import 'package:http/http.dart' as http;

class ChartController implements IChartController {

  IBenzinskaInfo? iBenzinskaInfo;

  ChartController(IBenzinskaInfo iBenzinskaInfo) {
    this.iBenzinskaInfo = iBenzinskaInfo;
  }

  @override
  Future<void> getCijenik(int id) async {

    var url = Uri.parse("https://webservis.mzoe-gor.hr/api/cjenici-postaja/"+id.toString());
    var response;
    try {
      response = await http.get(url);
    }catch(e) {

      return;
    }
    if(response.statusCode == 200) {

      final body = json.decode(utf8.decode(response.bodyBytes));

      List<WebCijenik> list = [];

      for(int i = 0; i < body.length; i++) {
        var cijenik = WebCijenik();

        if(!body[i]['dat_poc'].contains("1970")) {
          cijenik.datPoc = body[i]['dat_poc'];
          cijenik.gorivoId = body[i]['gorivo_id'];
          cijenik.cijena = body[i]['cijena'];
          list.add(cijenik);
        }
      }
      iBenzinskaInfo!.onSuccessGraphFetch(list);
    }
  }

}