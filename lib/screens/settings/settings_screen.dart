
import 'package:benzinske_postaje/util/theme_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();

  ThemeNotifier? themeNotifier;
}

class _SettingsScreenState extends State<SettingsScreen> {

  var list = [
    false,
    false,
  ];

  var box;

  @override
  void initState() {
    box = GetStorage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Thema: " + Theme.of(context).scaffoldBackgroundColor.toString());
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle!,
        sized: false,
        child: SafeArea(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget> [
                    Text("U vezi", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text("Verzija", style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text("1.9"),
                    ToggleButtons(
                      isSelected: list,
                      children: <Widget>[
                          Icon(Feather.moon),
                          Icon(Feather.sun)
                      ],
                      onPressed: (int index) {
                        list[index] = !list[index];

                        final provider = Provider.of<ThemeNotifier>(context, listen: false);
                        if(index == 0) {
                          box.write("themeMode", "dark");
                          provider.setDarkMode();
                        } else {
                          box.write("themeMode", "light");
                          provider.setLightMode();
                        }
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
            )
        ),
      ),
    );

  }
}