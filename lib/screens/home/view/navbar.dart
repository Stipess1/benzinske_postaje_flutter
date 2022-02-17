import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:animations/animations.dart';
import 'package:benzinske_postaje/components/fab.dart';
import 'package:benzinske_postaje/components/ifab.dart';
import 'package:benzinske_postaje/components/inav.dart';
import 'package:benzinske_postaje/model/gorivo.dart';
import 'package:benzinske_postaje/model/postaja.dart';
import 'package:benzinske_postaje/screens/home/view/IHome.dart';
import 'package:benzinske_postaje/screens/map/map_screen.dart';
import 'package:benzinske_postaje/screens/settings/settings_screen.dart';
import 'package:benzinske_postaje/util/hex_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:preload_page_view/preload_page_view.dart';

import '../controller/gas_stations_controller.dart';
import '../controller/igas_stations_controller.dart';
import 'home_screen.dart';

class NavBar extends StatefulWidget {
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with WidgetsBindingObserver implements IFab, IHome, INav{

  late HomeScreen homeScreen;
  MapScreen mapScreen = MapScreen();
  SettingsScreen settingsScreen = SettingsScreen();

  PreloadPageController? _pageController;
  Position? position;

  List<Widget>? pages;
  int page = 0;
  bool? isDark;
  String fuel = "Eurodizel";
  String radius = "5 km";
  String filtriraj = "";

  List<FontWeight> styles = [
    FontWeight.normal,
    FontWeight.bold,
    FontWeight.normal,
    FontWeight.normal,
    FontWeight.normal,
    FontWeight.normal,
    FontWeight.normal,
    FontWeight.normal,
  ];

  // Navbar postavke
  NotchSmoothness? notchSmoothness;
  double rightCornerRadius = 0;
  GapLocation? gapLocation;
  FloatingActionButtonLocation? floatingActionButtonLocation;

  var icons = <IconData>[
    Ionicons.home_outline,
    Ionicons.map_outline,
    Ionicons.settings_outline
  ];

  var activeIcons = <IconData> [
    Ionicons.home,
    Ionicons.map,
    Ionicons.settings
  ];

  @override
  void initState() {
    notchSmoothness = NotchSmoothness.smoothEdge;
    gapLocation = GapLocation.end;
    floatingActionButtonLocation = FloatingActionButtonLocation.endDocked;
    WidgetsBinding.instance!.addObserver(this);
    homeScreen = HomeScreen(this);
    pages = [
      homeScreen,
      mapScreen,
      settingsScreen
    ];

    _pageController = PreloadPageController(initialPage: page);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      checkPermission();
    });
    super.initState();
  }

  Future<void> checkPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      var status = await Permission.location.request();
      if(status == PermissionStatus.granted) {
        position = await Geolocator.getCurrentPosition();
        fetchGasStations();
      } else {
        permissionNotGranted();
      }
    } else {
      if(await Permission.location.serviceStatus.isEnabled) {
        position = await Geolocator.getCurrentPosition();
        fetchGasStations();
      } else {
        gpsNotEnabled();
      }
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final granted = await Permission.location.isGranted;
      if(granted) {
        homeScreen.state.setLoading();
        position = await Geolocator.getCurrentPosition();
        fetchGasStations();
      } else {
        permissionNotGranted();
      }
    }
  }

  void fetchGasStations() {
    IGasStationsController gasStationsController =
    new GasStationsController(this);
    gasStationsController.fetchGasStations();
  }

  void permissionNotGranted() {
    homeScreen.state.permissionNotGranted();
  }

  void gpsNotEnabled() {
    homeScreen.state.gpsNotEnabled();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: _buildNavBar(context),
      floatingActionButton: rightCornerRadius!=0 ? SizedBox.shrink(): FloatingActionButton(onPressed: () {  },
        // label: Fab(),
        child: Fab(this, fuel, styles, radius, filtriraj),
      ),
      floatingActionButtonLocation: floatingActionButtonLocation,
      body: PageTransitionSwitcher(
        transitionBuilder: (Widget child, Animation<double> animation, Animation<double> secondaryAnimation) {
          return FadeThroughTransition(animation: animation,
              secondaryAnimation: secondaryAnimation, child: child);
        },
        child: PreloadPageView.builder(
          itemCount: 3,
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          preloadPagesCount: 1,
          itemBuilder: (context, index) {
            return pages![index];
          },
        ),
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {

    var labels = <String>[
      AppLocalizations.of(context)!.home,
      AppLocalizations.of(context)!.map,
      AppLocalizations.of(context)!.settings
    ];

    return AnimatedBottomNavigationBar.builder(
        tabBuilder: (index, isActive) {
          final color = isActive ? HexColor.fromHex("3880ff") : Colors.grey;
          final fontWeight = isActive ? FontWeight.bold : FontWeight.normal;

          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              setIcons(index, isActive, color),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: color,
                    fontWeight: fontWeight
                  ),
                ),
              )
            ],
          );
        },
        itemCount: 3,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        gapLocation: gapLocation,
        activeIndex: page,
        splashSpeedInMilliseconds: 0,
        splashRadius: 0,
        leftCornerRadius: 8,
        notchSmoothness: notchSmoothness,
        rightCornerRadius: rightCornerRadius,
        onTap: (index) {
          setState(() {
            page = index;
            _pageController!.animateToPage(page, curve: Curves.ease, duration: Duration(milliseconds: 300), );
          });
        });
  }

  Widget setIcons(int index, bool isActive, Color color) {
    if(isActive) {
      return Icon(activeIcons[index],
        size: 22,
        color: color,
      );
    } else {
      return Icon(icons[index],
        size: 22,
        color: color,
      );
    }


  }

  @override
  void setFuel(int code, String name, int index) {
    homeScreen.state.changeFuelPrice(code, name);
    this.fuel = name;
    for(var i = 0; i < styles.length; i++) {
      styles[i] = FontWeight.normal;
    }
    styles[index] = FontWeight.bold;

    setState(() {});
  }

  @override
  void setRadius(String name, int index) {
    homeScreen.state.changeRadius(name);
    this.radius = name;

    setState(() {});
  }

  @override
  void sortFuel(String name, int index, int sort) {
    homeScreen.state.sortFuel(name, sort);
    this.filtriraj = name;

    setState(() {});
  }

  @override
  void fuelPriceWrong() {
    homeScreen.state.buildInfoAlertDialog();
  }

  @override
  void onFailureFetch(String message) {
      print(message);
  }

  @override
  void onSuccessFetch(List<Postaja> list, List<Gorivo> goriva) {
    mapScreen.state.fetchGasStations();
    homeScreen.state.fetchGasStations();
  }

  @override
  Future<void> requestPermission() async {
    var status = await Permission.location.request();
    if(status == PermissionStatus.granted) {
      position = await Geolocator.getCurrentPosition();
      fetchGasStations();
    } else {
      openAppSettings();
    }
  }
}