
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
    var themeMode = box.read('themeMode');

    if(themeMode == "dark") {
      list[0] = true;
    } else {
      list[1] = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle!,
        sized: false,
        child: SafeArea(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget> [
                    Text("U vezi", style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    ListTile(
                      title: Text("Verzija", style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color
                        ),
                      ),
                      subtitle: Text("1.9", style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText2!.color
                        )
                      ),
                    ),
                    ListTile(
                      title: Text("Email", style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color
                        ),
                      ),
                      subtitle: Text("stjepstjepanovic@gmail.com", style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText2!.color
                        )
                      ),
                    ),
                    ToggleButtons(
                      isSelected: list,
                      color: Theme.of(context).textTheme.bodyText2!.color,
                      borderRadius: BorderRadius.circular(15),
                      selectedBorderColor: Theme.of(context).dividerColor,
                      children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                      child: Icon(Feather.moon),
                                      alignment: PlaceholderAlignment.middle
                                  ),
                                  TextSpan(
                                    text: " Tamni način",
                                    style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyText2!.color
                                    )
                                  )
                                ]
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            text: TextSpan(
                                children: [
                                  WidgetSpan(
                                      child: Icon(Feather.sun),
                                      alignment: PlaceholderAlignment.middle
                                  ),
                                  TextSpan(
                                      text: " Svijetli način",
                                      style: TextStyle(
                                        color: Theme.of(context).textTheme.bodyText2!.color
                                      )
                                  )
                                ]
                            ),
                          ),
                        )
                      ],
                      onPressed: (int index) {
                        final provider = Provider.of<ThemeNotifier>(context, listen: false);
                        if(index == 0) {
                          box.write("themeMode", "dark");
                          provider.setDarkMode();
                        } else {
                          box.write("themeMode", "light");
                          provider.setLightMode();
                        }
                        setState(() {
                          for (int i = 0; i < list.length; i++) {
                            list[i] = i == index;
                          }
                        });
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