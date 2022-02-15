import 'package:benzinske_postaje/model/gorivo.dart';
import 'package:benzinske_postaje/model/web_cijenik.dart';
import 'package:benzinske_postaje/util/hex_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LinearChartWidget extends StatelessWidget {


  List<WebCijenik>? webCijenik;
  List<Gorivo>? goriva;

  LinearChartWidget(List<WebCijenik>? webCijenik, List<Gorivo> goriva) {
    this.webCijenik = webCijenik;
    this.goriva = goriva;
  }

  List<WebCijenik>? euroDizel = [];
  List<WebCijenik>? euroDizelPremium = [];
  List<WebCijenik>? benzin95 = [];
  List<WebCijenik>? benzinPremium95 = [];
  List<WebCijenik>? benzin100 = [];
  List<WebCijenik>? benzinPremium100 = [];
  List<WebCijenik>? lpg = [];
  List<WebCijenik>? plaviDizel = [];

  void makeSpots() {

    webCijenik!.forEach((cijenik) {
      goriva!.forEach((gorivo) {
        if(gorivo.id == cijenik.gorivoId) {
          cijenik.naziv = gorivo.naziv;
          cijenik.vrstaGorivaId = gorivo.vrstaGorivaId;
        }
      });

      if(cijenik.vrstaGorivaId! == 1) {
        benzinPremium95!.add(cijenik);
      } else if(cijenik.vrstaGorivaId! == 2) {
        benzin95!.add(cijenik);
      } else if(cijenik.vrstaGorivaId! == 5) {
        benzinPremium100!.add(cijenik);
      } else if(cijenik.vrstaGorivaId! == 6) {
        benzin100!.add(cijenik);
      } else if(cijenik.vrstaGorivaId! == 7) {
        euroDizelPremium!.add(cijenik);
      } else if(cijenik.vrstaGorivaId! == 8) {
        euroDizel!.add(cijenik);
      } else if(cijenik.vrstaGorivaId! == 9) {
        lpg!.add(cijenik);
      }

    });

  }

  @override
  Widget build(BuildContext context) {
    makeSpots();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 8, right: 10),
      child: Container(
        height: 250,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                  spots: benzin95!.map((e) => FlSpot(
                      DateTime.parse(e.datPoc!).millisecondsSinceEpoch.toDouble(), e.cijena!
                  )).toList(),
                  colors: [
                    HexColor.fromHex("8dd374")
                  ]
              ),
              LineChartBarData(
                  spots: benzinPremium95!.map((e) => FlSpot(
                      DateTime.parse(e.datPoc!).millisecondsSinceEpoch.toDouble(), e.cijena!
                  )).toList(),
                  colors: [
                    HexColor.fromHex("8dd374")
                  ]
              ),
              LineChartBarData(
                spots: benzinPremium100!.map((e) => FlSpot(
                    DateTime.parse(e.datPoc!).millisecondsSinceEpoch.toDouble(), e.cijena!
                )).toList(),
                colors: [
                  HexColor.fromHex('67a84f')
                ],

              ),
              LineChartBarData(
                  spots: benzin100!.map((e) => FlSpot(
                      DateTime.parse(e.datPoc!).millisecondsSinceEpoch.toDouble(), e.cijena!
                  )).toList(),
                  colors: [
                    HexColor.fromHex('67a84f')
                  ]
              ),
              LineChartBarData(
                  spots: euroDizelPremium!.map((e) => FlSpot(
                      DateTime.parse(e.datPoc!).millisecondsSinceEpoch.toDouble(), e.cijena!
                  )).toList(),
                  colors: [
                    HexColor.fromHex("5c5c5c")
                  ]
              ),
              LineChartBarData(
                spots: euroDizel!.map((e) => FlSpot(
                    DateTime.parse(e.datPoc!).millisecondsSinceEpoch.toDouble(), e.cijena!
                )).toList(),
                colors: [
                  HexColor.fromHex("0544D3")
                ],

              ),
              LineChartBarData(
                  spots: lpg!.map((e) => FlSpot(
                      DateTime.parse(e.datPoc!).millisecondsSinceEpoch.toDouble(), e.cijena!
                  )).toList(),
                  colors: [
                    HexColor.fromHex("fac02d")
                  ]
              )
            ],
            titlesData: FlTitlesData(
                show: true,
                leftTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 35,
                  // interval: 1
                ),
                topTitles: SideTitles(
                    showTitles: false
                ),
                rightTitles: SideTitles(
                    showTitles: false
                ),
                bottomTitles: SideTitles(
                  showTitles:  true,
                  reservedSize: 60,
                  rotateAngle: -45,
                  getTextStyles: (context, value){
                    return TextStyle(
                        fontSize: 10
                    );
                  },
                  getTitles: (value) {
                    final DateTime date =
                    DateTime.fromMillisecondsSinceEpoch(value.toInt());
                    final parts = date.toIso8601String().split("T");

                    var dateFormat = DateFormat('yyyy-MM-dd');
                    var input = dateFormat.parse(parts.first);

                    var output = DateFormat('dd/MM/yyyy');
                    var outputFormat = output.format(input);

                    return outputFormat;
                  },

                  // margin: 12,
                  // interval: 2
                )
            ),
            lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Theme.of(context).cardColor,
                    fitInsideHorizontally: true,
                    maxContentWidth: 180,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {

                        String? date;
                        String? naziv;

                        if(touchedSpot.barIndex == 0) {
                          date = benzin95![touchedSpot.spotIndex].datPoc;
                          naziv = benzin95![touchedSpot.spotIndex].naziv;
                        } else if(touchedSpot.barIndex == 1) {
                          date = benzinPremium95![touchedSpot.spotIndex].datPoc;
                          naziv = benzinPremium95![touchedSpot.spotIndex].naziv;
                        } else if(touchedSpot.barIndex == 2) {
                          date = benzinPremium100![touchedSpot.spotIndex].datPoc;
                          naziv = benzinPremium100![touchedSpot.spotIndex].naziv;
                        } else if(touchedSpot.barIndex == 3) {
                          date = benzin100![touchedSpot.spotIndex].datPoc;
                          naziv = benzin100![touchedSpot.spotIndex].naziv;
                        } else if(touchedSpot.barIndex == 4) {
                          date = euroDizelPremium![touchedSpot.spotIndex].datPoc;
                          naziv = euroDizelPremium![touchedSpot.spotIndex].naziv;
                        } else if(touchedSpot.barIndex == 5) {
                          date = euroDizel![touchedSpot.spotIndex].datPoc;
                          naziv = euroDizel![touchedSpot.spotIndex].naziv;
                        } else if(touchedSpot.barIndex == 6) {
                          date = lpg![touchedSpot.spotIndex].datPoc;
                          naziv = lpg![touchedSpot.spotIndex].naziv;
                        }
                        var dateFormat = DateFormat('yyyy-MM-dd');
                        var input = dateFormat.parse(date!);

                        var output = DateFormat('dd/MM/yyyy');
                        var outputFormat = output.format(input);

                        final textStyle = TextStyle(
                          color: touchedSpot.bar.colors[0],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return LineTooltipItem('$outputFormat \n $naziv \n ${touchedSpot.y.toStringAsFixed(2)} kn', textStyle);
                      }).toList();
                    }
                ),
                handleBuiltInTouches: true
            ),
          ),
        ),
      ),
    );
    throw UnimplementedError();
  }

}