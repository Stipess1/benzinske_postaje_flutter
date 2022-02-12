import 'dart:async';

import 'package:benzinske_postaje/model/gorivo.dart';
import 'package:benzinske_postaje/model/postaja.dart';
import 'package:benzinske_postaje/screens/home/controller/gas_stations_controller.dart';
import 'package:benzinske_postaje/screens/home/controller/igas_stations_controller.dart';
import 'package:benzinske_postaje/screens/home/view/IHome.dart';
import 'package:benzinske_postaje/util/storage_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';


class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with AutomaticKeepAliveClientMixin<MapScreen>, WidgetsBindingObserver implements IHome {
  late Position position;
  LatLng pos = LatLng(45.6807694, 16.038212);
  String url = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> markers = [];

  GoogleMapController? _mapController;
  bool isMapCreated = false;
  bool isDark = false;

  @override
  void initState() {
    checkGpsLocation();
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      checkPermission();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if(state == AppLifecycleState.resumed) {
      checkThemeMode();
    }

  }

  void fetchGasStations() {
    IGasStationsController gasStationsController =
    new GasStationsController(this);
    gasStationsController.fetchGasStations();
  }

  Future<void> checkPermission() async {
    if (!await Permission.location.request().isGranted) {
      var status = await Permission.location.request();
      if(status == PermissionStatus.granted) {
        fetchGasStations();
      } else {
        print("Nije dopusteno");
      }
    } else {
      position = await Geolocator.getCurrentPosition();
      print("dopusteno");
      fetchGasStations();
    }
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
  Widget build(BuildContext context) {
  super.build(context);

  checkThemeMode();

  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: Theme.of(context).appBarTheme.systemOverlayStyle!.copyWith(
      statusBarColor: Colors.transparent
    ),
    child: GoogleMap(
      mapType: MapType.normal,
      myLocationButtonEnabled: false,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      markers: Set.from(markers),

      initialCameraPosition: CameraPosition(
        target: pos,
        zoom: 13
      ),
      onMapCreated: _onMapCreated,
    ),
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
    
    setState(() {

    });
    await checkGpsLocation();
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
  void onSuccessFetch(List<Postaja> postaje, List<Gorivo> goriva) {
    for (var i = 0; i < postaje.length; i++){
      var postaja = postaje[i];
      if (postaja.lat != null && postaja.lon != null) {
        markers.add(Marker(
          markerId: MarkerId(postaja.id.toString()),
          infoWindow: InfoWindow(
            title: postaja.naziv,
            snippet: postaja.adresa
          ),
          draggable: false,
          onTap: () {

          },
          position: LatLng(postaja.lon!, postaja.lat!)
        ));
      }
    }
    setState(() {

    });
  }

}