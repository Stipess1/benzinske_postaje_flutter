import 'dart:async';

import 'package:benzinske_postaje/model/gorivo.dart';
import 'package:benzinske_postaje/model/postaja.dart';
import 'package:benzinske_postaje/screens/home/controller/gas_stations_controller.dart';
import 'package:benzinske_postaje/screens/home/controller/igas_stations_controller.dart';
import 'package:benzinske_postaje/screens/home/view/IHome.dart';
import 'package:benzinske_postaje/screens/info/view/benzinska_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../util/util.dart';


class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapScreenState();
  late _MapScreenState state;
}

class _MapScreenState extends State<MapScreen> with AutomaticKeepAliveClientMixin<MapScreen>, WidgetsBindingObserver implements IHome {
  late Position position;
  LatLng pos = LatLng(45.6807694, 16.038212);
  String url = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = [];
  late Widget _mainWidget;

  GoogleMapController? _mapController;
  bool isMapCreated = false;
  bool isDark = false;

  @override
  void initState() {
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
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if(state == AppLifecycleState.resumed) {
      checkThemeMode();
    }

  }

  Future<void> fetchGasStations() async {
    position = await Geolocator.getCurrentPosition();
    await checkGpsLocation();
    IGasStationsController gasStationsController =
    new GasStationsController(this);
    gasStationsController.fetchGasStations();
  }

  void checkThemeMode() {
    var box = GetStorage();

    if(box.read("themeMode") == "light") {
      isDark = false;
    } else {
      isDark = true;
    }

    if(isDark && isMapCreated) {
      changeMapDark();
    } else if(isMapCreated && !isDark){
      changeMapLight();
    }
    setState(() {});
  }

  Future<void> checkGpsLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    pos = LatLng(position.latitude, position.longitude);
  }

  Future<String> getJson(String path) async{
    return await rootBundle.loadString(path);
  }

  void changeMapDark() {
    getJson("assets/map/dark_map.json").then(setMapStyle);
  }

  void changeMapLight() {
    getJson("assets/map/light_map.json").then(setMapStyle);
  }

  void setMapStyle(String mapStyle) {
    _mapController!.setMapStyle(mapStyle);
  }

  @override
  void dispose() {
    _mapController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  super.build(context);

  checkThemeMode();

  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: Theme.of(context).appBarTheme.systemOverlayStyle!.copyWith(
      statusBarColor: Colors.transparent
    ),
    child: _mainWidget
  );

  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    _controller.complete(controller);
    _mapController = controller;
    
    isMapCreated = true;
    if(isDark) {
      changeMapDark();
    } else {
      changeMapLight();
    }

    controller.animateCamera(CameraUpdate.newLatLng(pos));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void onFailureFetch(String message) {
    print(message);
  }

  @override
  Future<void> onSuccessFetch(List<Postaja> postaje, List<Gorivo> goriva) async {
    for (var i = 0; i < postaje.length; i++){
      var postaja = postaje[i];
      if (postaja.lat != null && postaja.lon != null) {

        postaja.udaljenost = Util.calculateDistance(
            postaja.lon, postaja.lat, position.latitude, position.longitude);

        postaja.udaljenost = double.parse(postaja.udaljenost!.toStringAsFixed(1));
        final BitmapDescriptor markerIcon = postaja.otvoreno! ? await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)), "assets/images/otvoreno.png") : await BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(48, 48)), "assets/images/zatvoreno.png");

        markers.add(Marker(
          markerId: MarkerId(postaja.id.toString()),
          draggable: false,
          icon: markerIcon,
          onTap: () {
            showCupertinoModalBottomSheet(
                context: context,
                expand: false,
                isDismissible: true,
                builder: (builder) {
                  return Material(
                    borderRadius: BorderRadius.only(topLeft: Radius.elliptical(16, 16), topRight: Radius.elliptical(16, 16)),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: BenzinskaInfo(goriva: goriva, postaja: postaja),
                  );
                }
            );
          },
          position: LatLng(postaja.lon!, postaja.lat!)
        ));
      }
    }
    // https://github.com/flutter/flutter/issues/28493
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _mainWidget = GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: false,
          myLocationEnabled: true,
          compassEnabled: false,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
          markers: Set.from(markers),

          initialCameraPosition: CameraPosition(
              target: pos,
              zoom: 13
          ),
          onMapCreated: _onMapCreated,
        );
      });
    });
  }

}