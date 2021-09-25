import 'package:benzinske_postaje/components/benzinska_item.dart';
import 'package:benzinske_postaje/model/gorivo.dart';
import 'package:benzinske_postaje/model/postaja.dart';
import 'package:benzinske_postaje/screens/home/controller/igas_stations_controller.dart';
import 'package:benzinske_postaje/screens/home/controller/gas_stations_controller.dart';
import 'package:benzinske_postaje/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'IHome.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<HomeScreen> implements IHome  {
  late Position position;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  late List<Gorivo> goriva;
  List<Postaja> svePostaje = [];
  List<Postaja> filtriranePostaje = [];
  int listaSize = 0;
  late Widget _mainWidget;


  Future<void> checkPermission() async {
    if (!await Permission.location.request().isGranted) {
      await Permission.location.request();
    } else {
      position = await Geolocator.getCurrentPosition();
      fetchGasStations();
    }
  }

  void fetchGasStations() {
    IGasStationsController gasStationsController =
        new GasStationsController(this);
    gasStationsController.fetchGasStations();
  }

  @override
  void initState() {
    super.initState();

    _mainWidget = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator()
        ],
      ),
    );

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      checkPermission();
    });

  }

  Widget buildListWidget() {
    return ListView(
      children: <Widget> [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            "Benzinske u blizini (" +
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
  }

  @override
  Widget build(BuildContext context) {
   super.build(context);
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
                return FadeTransition(child: child, opacity: animation,);
              },
              duration: Duration(seconds: 1),
              child: _mainWidget,
            )
          ),
        ),
      ),
    );
  }

  @override
  void onFailureFetch(String message) {
    print(message);
  }

  @override
  void onSuccessFetch(List<Postaja> postaje, List<Gorivo> goriva) {
    for (var i = 0; i < postaje.length; i++) {
      var postaja = postaje[i];
      if (postaja.lat != null && postaja.lon != null) {
        postaja.udaljenost = Util.calculateDistance(
            postaja.lon, postaja.lat, position.latitude, position.longitude);
        postaja.udaljenost = (postaja.udaljenost!.round()* 10) / 10;

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
  }

  @override
  bool get wantKeepAlive => true;
}