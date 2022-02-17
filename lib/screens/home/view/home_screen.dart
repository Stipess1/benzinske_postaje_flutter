
import 'package:benzinske_postaje/components/benzinska_item.dart';
import 'package:benzinske_postaje/components/inav.dart';
import 'package:benzinske_postaje/model/gorivo.dart';
import 'package:benzinske_postaje/model/postaja.dart';
import 'package:benzinske_postaje/screens/home/controller/igas_stations_controller.dart';
import 'package:benzinske_postaje/screens/home/controller/gas_stations_controller.dart';
import 'package:benzinske_postaje/util/util.dart';
import 'package:flash/flash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'IHome.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

  late INav inav;
  HomeScreen(INav nav) {
    inav = nav;
  }
  late _HomeScreenState state;
  int fuelType = 8;
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeScreen> implements IHome  {
  late Position position;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  late List<Gorivo> goriva;
  List<Postaja> svePostaje = [];
  List<Postaja> filtriranePostaje = [];
  int listaSize = 0;
  late Widget _mainWidget;
  late BuildContext homeContext;



  Future<void> fetchGasStations() async {
    position = await Geolocator.getCurrentPosition();
    IGasStationsController gasStationsController =
        new GasStationsController(this);
    gasStationsController.fetchGasStations();
  }

  void permissionNotGranted() {
    setState(() {
      _mainWidget = Center(
        key: Key("1"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 256,
              width: 256,
              child: SvgPicture.asset('assets/images/denied.svg'),
            )
            ,
            Padding(padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(AppLocalizations.of(context)!.permissionDenied),
                  OutlinedButton(
                    onPressed: () {
                      widget.inav.requestPermission();
                    },
                    child: Text(AppLocalizations.of(context)!.permissionGive),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  void setLoading() {
    setState(() {
      _mainWidget = Center(
        key: Key("1"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator()
          ],
        ),
      );
    });
  }

  void gpsNotEnabled() {
    setState(() {
      _mainWidget = Center(
        key: Key("1"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 256,
              width: 256,
              child: SvgPicture.asset('assets/images/gps.svg'),
            )
            ,
            Padding(padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  Text(AppLocalizations.of(context)!.gpsNotEnabled, textAlign: TextAlign.center,),
                  OutlinedButton(
                    onPressed: () {
                      widget.inav.requestPermission();
                      setState(() {
                        _mainWidget = Center(
                          key: Key("1"),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircularProgressIndicator()
                            ],
                          ),
                        );
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.gpsRetry),
                  )
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    widget.state = this;
    _mainWidget = Center(
      key: Key("1"),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator()
        ],
      ),
    );
  }

  Widget buildListWidget() {
    if(filtriranePostaje.length > 0) {
      return ListView(
        key: Key("2"),
        children: <Widget> [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              AppLocalizations.of(context)!.gasNearByCount+" (" +
                  listaSize.toString() +
                  ")",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: "VarelaRound",
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          ListView.builder(
              key: listKey,
              physics: ScrollPhysics(),
              itemCount: filtriranePostaje.length,
              padding: const EdgeInsets.only(bottom: 15),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return BenzinskaItem(postaja: filtriranePostaje[index], goriva: this.goriva);
              }),
        ],
      );
    } else {
      return Center(
        key: Key("1"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 256,
              width: 256,
              child: SvgPicture.asset('assets/images/empty.svg'),
            )
            ,
            Padding(padding: EdgeInsets.all(15),
            child: Text(AppLocalizations.of(context)!.gasStationExist),)
          ],
        ),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
   super.build(context);
   this.homeContext = context;

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle!.copyWith(
            statusBarColor: Theme.of(context).scaffoldBackgroundColor
        ),

        child: SafeArea(
          bottom: false,
          child: Container(
            child: AnimatedSwitcher(
              transitionBuilder: (child, animation) {
                return FadeTransition(child: child, opacity: animation);
              },
              duration: Duration(milliseconds: 1500),
              child: _mainWidget,
            )
          ),
        ),
      ),
    );
  }

  Future<void> checkForInfoAlert() async {
    final prefs = await SharedPreferences.getInstance();

    bool? repeat = prefs.getBool('info');
    if(repeat == null)
      repeat = false;
    if(!repeat) {
      buildInfoAlertDialog();
      await prefs.setBool('info', true);
    }
  }

  void buildInfoAlertDialog() {
    showDialog(context: context, builder: (_) {
      return AlertDialog(
        backgroundColor: Theme.of(context).backgroundColor,
        contentTextStyle: Theme.of(context).textTheme.bodyText1,
        titleTextStyle: Theme.of(context).textTheme.headline5,
        title: Text(AppLocalizations.of(context)!.gasPrices),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.cover,
              child: SvgPicture.asset('assets/images/info.svg'),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Text(AppLocalizations.of(context)!.gasPricesDescription)
            )
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Ok"))
        ],
      );
    });
  }

  @override
  void onFailureFetch(String message) {
    print(message);
  }

  void changeRadius(String name) {
    double radius = double.parse(name.split(" ")[0]);
    filtriranePostaje.clear();
    listaSize = 0;
    for(var i = 0; i < svePostaje.length; i++) {
      var postaja = svePostaje[i];
      if(postaja.udaljenost != null) {
        postaja.udaljenost = Util.calculateDistance(
            postaja.lon, postaja.lat, position.latitude, position.longitude);
        postaja.udaljenost = (postaja.udaljenost!.round()* 10) / 10;

        if(postaja.udaljenost! <= radius) {
          listaSize++;
          filtriranePostaje.add(postaja);
        }
      }
    }

    setState(() {
      _mainWidget = buildListWidget();
    });
  }

  void sortFuel(String name, int sort) {
    if(sort == 1) {
      for(var i = 0; i < filtriranePostaje.length; i++) {
        for(var j = 0; j < filtriranePostaje.length; j++) {
          if(filtriranePostaje[i].gorivo! != "---" && filtriranePostaje[j].gorivo! != "---") {
            double prvi = double.parse(filtriranePostaje[i].gorivo!);
            double drugi = double.parse(filtriranePostaje[j].gorivo!);

            if(prvi < drugi) {
              var temp = filtriranePostaje[i];
              filtriranePostaje[i] = filtriranePostaje[j];
              filtriranePostaje[j] = temp;
            }
          }

        }
      }
    } else if(sort == 0) {
      for(var i = 0; i < filtriranePostaje.length; i++) {
        for(var j = 0; j < filtriranePostaje.length; j++) {
          if(filtriranePostaje[i].gorivo! != "---" && filtriranePostaje[j].gorivo! != "---") {
            double prvi = double.parse(filtriranePostaje[i].gorivo!);
            double drugi = double.parse(filtriranePostaje[j].gorivo!);

            if(prvi > drugi) {
              var temp = filtriranePostaje[i];
              filtriranePostaje[i] = filtriranePostaje[j];
              filtriranePostaje[j] = temp;
            }
          }
        }
      }
    } else if(sort == -1) {
      for(var i = 0; i < filtriranePostaje.length; i++) {
        for(var j = 0; j < filtriranePostaje.length; j++) {

          if(filtriranePostaje[i].udaljenost! < filtriranePostaje[j].udaljenost!) {
            var temp = filtriranePostaje[i];
            filtriranePostaje[i] = filtriranePostaje[j];
            filtriranePostaje[j] = temp;
          }
        }
      }
    }

    setState(() {_mainWidget = buildListWidget();});
  }

  void changeFuelPrice(int code, String name) {
    for(var i = 0; i < filtriranePostaje.length; i++ ) {
      filtriranePostaje[i].gorivo = "---";
      for(var j = 0; j < filtriranePostaje[i].cijenici.length; j++) {
        if(filtriranePostaje[i].cijenici[j].vrstaGorivoId == code) {
          filtriranePostaje[i].gorivo = filtriranePostaje[i].cijenici[j].cijena!.toStringAsFixed(2);
        }
      }
    }
    setState(() {_mainWidget = buildListWidget();});
    showFlash(context: this.homeContext, duration: Duration(seconds: 2) ,builder: (context, controller) {
      return Flash(
        controller: controller,
        position: FlashPosition.bottom,
        behavior: FlashBehavior.floating,
        backgroundColor: Theme.of(this.homeContext).backgroundColor,
        horizontalDismissDirection: HorizontalDismissDirection.horizontal,
        borderRadius: BorderRadius.circular(16),
        child: FlashBar(
          content: Text("Postavljen je " + name, style: TextStyle(
            color: Theme.of(this.homeContext).textTheme.bodyText2!.color
          ),),
        ),
      );
    },);
  }

  @override
  void onSuccessFetch(List<Postaja> postaje, List<Gorivo> goriva) {
    for (var i = 0; i < postaje.length; i++) {
      var postaja = postaje[i];
      if (postaja.lat != null && postaja.lon != null) {
        postaja.udaljenost = Util.calculateDistance(
            postaja.lon, postaja.lat, position.latitude, position.longitude);

        postaja.udaljenost = double.parse(postaja.udaljenost!.toStringAsFixed(1));

        if (postaja.udaljenost! <= 5.0) {
          listaSize++;
          filtriranePostaje.add(postaja);
        }
      }
    }

    this.goriva = goriva;
    svePostaje = postaje;
    setState(() {
      _mainWidget = buildListWidget();
    });
    checkForInfoAlert();
  }

  @override
  bool get wantKeepAlive => true;
}