import 'package:benzinske_postaje/components/linear_chart.dart';
import 'package:benzinske_postaje/model/cijenik.dart';
import 'package:benzinske_postaje/model/gorivo.dart';
import 'package:benzinske_postaje/model/postaja.dart';
import 'package:benzinske_postaje/model/usluga.dart';
import 'package:benzinske_postaje/model/web_cijenik.dart';
import 'package:benzinske_postaje/screens/info/controller/chart_controller.dart';
import 'package:benzinske_postaje/screens/info/controller/ichart_controller.dart';
import 'package:benzinske_postaje/screens/info/view/ibenzinska_info.dart';
import 'package:benzinske_postaje/util/hex_color.dart';
import 'package:benzinske_postaje/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BenzinskaInfo extends StatefulWidget {

  Postaja postaja;
  List<Gorivo> goriva;
  bool isMapSelected;

  BenzinskaInfo({Key? key, required this.postaja, required this.goriva, required this.isMapSelected}): super(key: key);

  State<StatefulWidget> createState() => _BenzinskaInfoScreenState();

}

class _BenzinskaInfoScreenState extends State<BenzinskaInfo> implements IBenzinskaInfo{

  List<WebCijenik> cijenik = [];
  List<WebCijenik> filtriraniCijenik = [];
  List<bool> isSelected = [true, false, false, false];
  bool disposed = false;
  @override
  void initState() {
    super.initState();
    fetchGraph();
  }

  void fetchGraph() {
   IChartController chartController = ChartController(this);
   chartController.getCijenik(widget.postaja.id!);
  }

  @override
  Widget build(BuildContext context) {
    if(!widget.isMapSelected) {
      return Scaffold(
          appBar: AppBar(
              automaticallyImplyLeading: true,
              iconTheme: Theme.of(context).iconTheme,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(widget.postaja.naziv!, style: Theme.of(context).primaryTextTheme.headline6),
              systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle!.copyWith(
                  statusBarColor: Theme.of(context).scaffoldBackgroundColor
              )
          ),
          body: buildInfoContainer(context)
      );
    } else {
      return Scaffold(
        body: buildInfoContainer(context),
      );
    }
  }

  Future<void> openMap(double latitude, double longitude) async {
    var googleUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    await launch(googleUrl.toString());
  }

  Widget buildInfoContainer(BuildContext context) {
    return Container(
        child: SafeArea(
          child: Column(
            children: [
              if(widget.isMapSelected)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, left: 35),
                      child: Text(widget.postaja.naziv!,
                          style: Theme.of(context).primaryTextTheme.headline6,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15, top: 15),
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Theme.of(context).backgroundColor,
                      child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          icon: Icon(Ionicons.close_outline, size: 20)
                      ),
                    ),
                  )
                ],
              ),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: [Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          buildImage(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(AppLocalizations.of(context)!.workingHours + widget.postaja.trenutnoRadnoVrijeme!, textAlign: TextAlign.center,),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: buildStatus(),
                          ),
                          Text(widget.postaja.obveznik!, textAlign: TextAlign.center,),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.postaja.naziv!, textAlign: TextAlign.center),
                          ),
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.place_outlined),
                                ),
                                Text(widget.postaja.adresa!)
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(Icons.near_me_outlined),
                                ),
                                Text(widget.postaja.udaljenost.toString() + " km")
                              ],
                            ),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              openMap(widget.postaja.lon!, widget.postaja.lat!);
                            },
                            child: Text(AppLocalizations.of(context)!.takeMe),
                          ),
                          Divider(
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(AppLocalizations.of(context)!.gasPrices, style: TextStyle(
                                    fontSize: 22
                                ), textAlign: TextAlign.start,),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildFuelPrices(context),
                            Divider(
                              height: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(AppLocalizations.of(context)!.services, style: TextStyle(
                                      fontSize: 22
                                  ), textAlign: TextAlign.start,),
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: buildOptions(context),
                            ),
                            Divider(
                              height: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(AppLocalizations.of(context)!.priceChart, style: TextStyle(
                                      fontSize: 22
                                  ), textAlign: TextAlign.start,),
                                )
                              ],
                            ),
                            ToggleButtons(
                              isSelected: isSelected,
                              borderRadius: BorderRadius.circular(15),
                              color: Theme.of(context).textTheme.bodyText1!.color,
                              selectedColor: Theme.of(context).textTheme.bodyText2!.color,
                              children: [
                                Text(AppLocalizations.of(context)!.threeMon),
                                Text(AppLocalizations.of(context)!.sixMon),
                                Text(AppLocalizations.of(context)!.oneYear),
                                Text(AppLocalizations.of(context)!.all)
                              ],
                              onPressed: (int index) {
                                // isSelected[index] = !isSelected[index];

                                if(index == 0) {
                                  filterCijenik(90);
                                } else if(index == 1) {
                                  filterCijenik(180);
                                } else if(index == 2) {
                                  filterCijenik(354);
                                } else {
                                  filterCijenik(-1);
                                }
                                setState(() {
                                  for (int i = 0; i < isSelected.length; i++) {
                                    isSelected[i] = i == index;
                                  }
                                });
                              },
                            ),
                            if(filtriraniCijenik.length > 0)
                              LinearChartWidget(filtriraniCijenik, widget.goriva)
                          ],
                        ),
                      ),

                    ],
                  ),
                ),

            ],
          ),
        )
    );
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

  Widget buildFuelPrices(BuildContext context) {

    var prices = <Widget>[];

    for(int i = 0; i < widget.postaja.cijenici.length; i++) {
      var gorivo = widget.postaja.cijenici[i];

      prices.add(Column(
        children: [
          buildContainer(gorivo),
          Text(gorivo.naziv!, textAlign: TextAlign.center, style: TextStyle(
            fontWeight: FontWeight.w400
          ),),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: RichText(text: TextSpan(
              text: gorivo.cijena!.toStringAsFixed(2),
              style: TextStyle(
                fontFamily: "VarelaRound",
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyText2!.color,
                fontSize: 17
              ),
              children: [
                TextSpan(text: " kn/L", style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal
                ))
              ]
            )),
          )
        ],
      ));
    }

    return StaggeredGridView.countBuilder(
      itemCount: widget.postaja.cijenici.length,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),

      shrinkWrap: true,
      itemBuilder: (context, index) {
        return prices[index];
      }, 
      crossAxisCount: 3,
      crossAxisSpacing: 10,
      mainAxisSpacing: 15,
      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
      
    );
  }

  Widget buildContainer(Cijenik cijenik) {

    if(cijenik.vrstaGorivoId == 8 || cijenik.vrstaGorivoId == 7) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: HexColor.fromHex("2C313C")
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("B", style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ), textAlign: TextAlign.center,),
            ],
          ),
        ),
      );
      // Benzin
    } else if(cijenik.vrstaGorivoId == 1 ||
        cijenik.vrstaGorivoId == 2 ||
        cijenik.vrstaGorivoId == 5 ||
        cijenik.vrstaGorivoId == 6  ) {

      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              color: HexColor.fromHex("8DD374")
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("E", style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ), textAlign: TextAlign.center,),
            ],
          ),
        ),
      );
    } else if(cijenik.vrstaGorivoId == 9) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: RotationTransition(
          turns: AlwaysStoppedAnimation(45/360),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: HexColor.fromHex("fac02d")
            ),
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(-45/360),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("H", style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ), textAlign: TextAlign.center,),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: HexColor.fromHex("701D46")
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(" ", style: TextStyle(
                  fontSize: 14
              ), textAlign: TextAlign.center,),
            ],
          ),
        ),
      );
    }
  }

  Widget buildStatus() {

    String status = widget.postaja.otvoreno! ? AppLocalizations.of(context)!.open : AppLocalizations.of(context)!.closed;
    Color text = widget.postaja.otvoreno! ? Color(0xFF29C467) : HexColor.fromHex("c42929");
    Color border = widget.postaja.otvoreno! ? Color(0x2F2dd36f) : Color(0x2Fd32d35);

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, right: 10, bottom: 5, left: 10),
        child: Text(status,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              color: text,
              fontWeight: FontWeight.w600
          ),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: border
      ),
    );
  }

  Widget buildOptions(BuildContext context) {
    List<Usluga> list = widget.postaja.opcije;

    var chips = <Widget> [];

    if(list.length == 0) {
      return Padding(
        padding: const EdgeInsets.only(left: 15.0, bottom: 5.0),
        child: Text(AppLocalizations.of(context)!.noServices),
      );
    }

    list.forEach((usluga) {
      chips.add(Chip(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: Theme.of(context).backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white12, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        avatar: CircleAvatar(
          backgroundColor: Colors.white30,
          child: Padding(
            padding: EdgeInsets.all(2),
            child: SvgPicture.asset(usluga.img!),
          ),
        ),
        label: Text(usluga.usluga!, style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color
          ),
        ),
      ));
    });

    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: chips,
    );
  }

  Widget buildImage() {
    if(widget.postaja.img!.contains("http")) {
      return Hero(
        tag: widget.postaja.id!,
        child: Image.network(
            widget.postaja.img!,
            width: 150,
            fit: BoxFit.contain),
      );
    } else {
      return Hero(
        tag: widget.postaja.id!,
        child: Image.asset(
            widget.postaja.img!,
            width: 150,
            fit: BoxFit.contain),
      );
    }
  }

  void filterCijenik(int days) {

    this.filtriraniCijenik.clear();
    this.cijenik.forEach((cijena) {
      if(days != -1) {
        int dayDiff = Util.daysBetween(DateTime.parse(cijena.datPoc!), DateTime.now());
        if(dayDiff <= days) {
          this.filtriraniCijenik.add(cijena);
        }
      } else {
        this.filtriraniCijenik.add(cijena);
      }
    });
  }

  @override
  void onSuccessGraphFetch(List<WebCijenik> webCijenik) {

    if(!disposed) {
      this.cijenik = webCijenik;
      filterCijenik(90);
      setState(() {});
    }
  }
  @override
  void dispose() {
    super.dispose();
    disposed = true;
  }
}