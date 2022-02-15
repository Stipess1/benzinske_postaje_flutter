import 'package:benzinske_postaje/screens/home/view/navbar.dart';
import 'package:benzinske_postaje/util/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await GetStorage.init();
  runApp(MyApp());
  // debugPaintSizeEnabled = true;
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

      return ChangeNotifierProvider(
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeNotifier>(context);
          return MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('hr', ''),
              Locale('en', '')
            ],
            debugShowCheckedModeBanner: false,
            title: "Benzinske postaje",
            home: NavBar(),
            themeMode: themeProvider.themeMode,
            theme: ThemeNotifier.lightTheme,
            darkTheme: ThemeNotifier.darkTheme,
          );
        }, create: (BuildContext context) {
          return ThemeNotifier();
      },
      );
  }
}



// scaffoldBackgroundColor: Colors.white,
// fontFamily: 'VarelaRound',
// primaryColor: Color(0xFF4B4B4B),
// textTheme: TextTheme(bodyText1: TextStyle(color: Color(0xFF4B4B4B)),
//     bodyText2: TextStyle(color: Colors.black)), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF4B4B4B))