import 'dart:async';

import 'package:benzinske_postaje/util/storage_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with AutomaticKeepAliveClientMixin<MapScreen>, WidgetsBindingObserver {

  LatLng pos = LatLng(45.6807694, 16.038212);
  String url = "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png";
  Completer<GoogleMapController> _controller = Completer();

  GoogleMapController? _mapController;
  bool isMapCreated = false;
  bool isDark = false;

  @override
  void initState() {
    checkGpsLocation();
    super.initState();

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {

    if(state == AppLifecycleState.resumed) {
      checkThemeMode();
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

      initialCameraPosition: CameraPosition(
        target: pos,
        zoom: 13
      ),
      onMapCreated: _onMapCreated,
    ),
    // child: FlutterMap(
    //   mapController: _mapController,
    //   options: MapOptions(
    //       center: pos,
    //       zoom: 13,
    //       interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag | InteractiveFlag.doubleTapZoom
    //   ),
    //   layers: [
    //     TileLayerOptions(
    //       urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
    //       subdomains: ['a', 'b', 'c'],
    //       attributionBuilder: (_) {
    //         return Text("© OpenStreetMap contributors");
    //       },
    //     ),
    //     MarkerLayerOptions(
    //         markers: [
    //           Marker(
    //               width: 80,
    //               height: 80,
    //               point: pos,
    //               builder: (ctx) {
    //                 return Container(
    //                   child: FlutterLogo(),
    //                 );
    //               }
    //           )
    //         ]
    //     )
    //   ],
    // ),
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

}