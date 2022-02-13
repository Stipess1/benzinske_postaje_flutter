import 'package:benzinske_postaje/util/hex_color.dart';
import 'package:benzinske_postaje/util/storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

class ThemeNotifier with ChangeNotifier {
  static final darkTheme = ThemeData(
    primaryColor: Colors.black,
      scaffoldBackgroundColor: HexColor.fromHex("1f2d3d"),
      iconTheme: IconThemeData(
          color: Colors.white
      ),
    // brightness: Brightness.dark,
    fontFamily: 'VarelaRound',
    cardColor: HexColor.fromHex("253649"),
    appBarTheme: AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light
      )
    ),
    backgroundColor: HexColor.fromHex("1c2836"),
      textTheme: TextTheme(bodyText1: TextStyle(color: HexColor.fromHex("c0ccda")),
          bodyText2: TextStyle(color: HexColor.fromHex("b1bbc7")), headline5: TextStyle(color: HexColor.fromHex("c0ccda")), caption: TextStyle(color: HexColor.fromHex("c0ccda"))), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.white70),
      dividerColor: HexColor.fromHex("4DFFFFFF")
  );

  static final lightTheme = ThemeData(
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'VarelaRound',
    iconTheme: IconThemeData(
      color: Colors.black
    ),
    appBarTheme: AppBarTheme(
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark
        ),
    ),
    primaryTextTheme: TextTheme(
      headline6: TextStyle(
        color: Colors.black
      )
    ),
    dividerColor: Colors.grey,
    backgroundColor: const Color(0xFFF5F5F5),
    textTheme: TextTheme(bodyText1: TextStyle(color: Color(0xFF4B4B4B), ),
      bodyText2: TextStyle(color: Colors.black)), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF4B4B4B)),
  );

  ThemeMode? themeMode;

  final box = GetStorage();

  ThemeNotifier() {
    var themeMode = box.read('themeMode');
    var systemTheme = SchedulerBinding.instance!.window.platformBrightness;
    bool isDarkMode = systemTheme == Brightness.dark;
    if(themeMode == null && !isDarkMode){
      themeMode = "light";
      box.write('themeMode', 'light');
    }

    if(themeMode == "light") {
      this.themeMode = ThemeMode.light;
    } else {
      this.themeMode = ThemeMode.dark;
    }
    notifyListeners();
  }

  void setDarkMode() {
    themeMode = ThemeMode.dark;
    box.write('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() {
    themeMode = ThemeMode.light;
    box.write('themeMode', 'light');
    notifyListeners();
  }
}