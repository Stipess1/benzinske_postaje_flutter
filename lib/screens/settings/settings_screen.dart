
import 'package:benzinske_postaje/util/theme_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SettingsScreenState();

  ThemeNotifier? themeNotifier;

}

class _SettingsScreenState extends State<SettingsScreen> {

  PackageInfo? packageInfo;
  String? version = "NaN";

  var list = [
    false,
    false,
  ];

  var box;

  @override
  void initState() {
    box = GetStorage();
    var themeMode = box.read('themeMode');
    appInfo();

    if(themeMode == "dark") {
      list[1] = true;
    } else {
      list[0] = true;
    }
    super.initState();
  }

  Future<void> appInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo!.version;
    setState(() {

    });
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
                    Text(AppLocalizations.of(context)!.about, style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.version, style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color
                        ),
                      ),
                      subtitle: Text(version!, style: TextStyle(
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
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.theme, style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color
                        ),
                      ),
                      subtitle: ToggleButtons(
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
                                        text: " " + AppLocalizations.of(context)!.darkTheme,
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
                                        text: " " + AppLocalizations.of(context)!.lightTheme,
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
                      ),
                    ),
                    ListTile(
                      onTap: () => launch("https://mzoe-gor.hr/"),
                      title: Text(AppLocalizations.of(context)!.gasPricesTaken, style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color
                        ),
                      ),
                      subtitle: Text("mzoe-gor.hr", style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText2!.color
                        )
                      ),
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