import 'package:benzinske_postaje/components/ifab.dart';
import 'package:benzinske_postaje/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Fab extends StatelessWidget {

  IFab? iFab;
  String? fuel;
  String? radius;
  String? filtriraj;
  List<FontWeight>? styles;
  GetStorage box = GetStorage();

  Fab(IFab iFab, String fuel, List<FontWeight> styles, String radius, String filtriraj) {
    this.iFab = iFab;
    this.fuel = fuel;
    this.styles = styles;
    this.radius = radius;
    this.filtriraj = filtriraj;

    if(box.read('fuel') != null) {
      this.fuel = Util.getFuelFromId(box.read('fuel'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return btn1(context);
  }

  Widget btn1(BuildContext context) {
    return  Container(
          decoration: BoxDecoration(color: Theme.of(context).backgroundColor, shape: BoxShape.circle),
          width: 56,
          height: 56,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                child: IconButton(onPressed: () {
                  showCupertinoModalBottomSheet(
                    expand: false,
                    context: context,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    builder: (context) {
                      return modalFit(context);
                    },
                  );
                }, icon: Icon(Ionicons.filter), iconSize: 24, color: Colors.grey,),
              ),
            ),
          )
      );
  }

  Widget modalFit(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.only(topLeft: Radius.elliptical(16, 16), topRight: Radius.elliptical(16, 16)),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(AppLocalizations.of(context)!.typeOfFuel, style: Theme.of(context).textTheme.bodyText2),
                leading: Icon(Ionicons.color_fill_outline, color: Theme.of(context).iconTheme.color,),
                trailing: Text(this.fuel!, style: Theme.of(context).textTheme.bodyText2),
                onTap: () => showCupertinoModalBottomSheet(
                  expand: false,
                  context: context,
                  builder: (context) {
                    return buildFuelTypes(context);
                  },
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.chooseRadius, style: Theme.of(context).textTheme.bodyText2),
                trailing: Text(this.radius!, style: Theme.of(context).textTheme.bodyText2),
                leading: Icon(Ionicons.compass_outline, color: Theme.of(context).iconTheme.color),
                onTap: () => showCupertinoModalBottomSheet(
                  expand: false,
                  context: context,
                  builder: (context) {
                    return buildRadius(context);
                  }
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.sort, style: Theme.of(context).textTheme.bodyText2),
                leading: Icon(Ionicons.funnel_outline, color: Theme.of(context).iconTheme.color),
                trailing: Text(this.filtriraj!, style: Theme.of(context).textTheme.bodyText2),
                onTap: () => showCupertinoModalBottomSheet(
                  expand: false,
                  context: context,
                  builder: (context) {
                    return buildSort(context);
                  }
                ),
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.gasPricesWrong, style: Theme.of(context).textTheme.bodyText2),
                leading: Icon(Ionicons.alert_circle_outline, color: Theme.of(context).iconTheme.color),
                onTap: () => iFab!.fuelPriceWrong(),
              ),
            ],
          ),
        ));
    }

  Widget buildFuelTypes(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.only(topLeft: Radius.elliptical(16, 16), topRight: Radius.elliptical(16, 16)),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("Eurodizel+", style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2!.color,
                  fontWeight: styles![0]
              )),
              onTap: () {
                iFab!.setFuel(7, "Eurodizel+", 0);
                Navigator.of(context).popUntil((route) => route.isFirst);
                box.write('fuel', 7);
              },
            ),
            ListTile(
              title: Text("Eurodizel", style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2!.color,
                  fontWeight: styles![1]
                )
              ),
              onTap: () {
                iFab!.setFuel(8, "Eurodizel", 1);
                Navigator.of(context).popUntil((route) => route.isFirst);
                box.write('fuel', 8);
              }
            ),
            ListTile(
              title: Text("Eurosuper 95+", style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2!.color,
                  fontWeight: styles![2]
              )),
              onTap: () {
                iFab!.setFuel(1, "Eurosuper 95+", 2);
                Navigator.of(context).popUntil((route) => route.isFirst);
                box.write('fuel', 1);
              }
            ),
            ListTile(
              title: Text("Eurosuper 95", style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2!.color,
                  fontWeight: styles![3]
              )),
              onTap: () {
                iFab!.setFuel(2, "Eurosuper 95", 3);
                Navigator.of(context).popUntil((route) => route.isFirst);
                box.write('fuel', 2);
              }
            ),
            ListTile(
              title: Text("Eurosuper 100+", style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2!.color,
                  fontWeight: styles![4]
              )),
              onTap: () {
                iFab!.setFuel(5, "Eurosuper 100+", 4);
                Navigator.of(context).popUntil((route) => route.isFirst);
                box.write('fuel', 5);
              }
            ),
            ListTile(
              title: Text("Eurosuper 100", style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2!.color,
                  fontWeight: styles![5]
              )),
              onTap: () {
                iFab!.setFuel(6, "Eurosuper 100", 5);
                Navigator.of(context).popUntil((route) => route.isFirst);
                box.write('fuel', 6);
              }
            ),
            ListTile(
              title: Text("UNP (autoplin)", style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2!.color,
                  fontWeight: styles![6]
              )),
              onTap: () {
                iFab!.setFuel(9, "UNP (autoplin)", 6);
                Navigator.of(context).popUntil((route) => route.isFirst);
                box.write('fuel', 9);
              }
            ),
            ListTile(
              title: Text("Plavi dizel", style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2!.color,
                  fontWeight: styles![7]
              )),
              onTap: () {
                iFab!.setFuel(11, "Plavi dizel", 7);
                Navigator.of(context).popUntil((route) => route.isFirst);
                box.write('fuel', 11);
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRadius(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.only(topLeft: Radius.elliptical(16, 16), topRight: Radius.elliptical(16, 16)),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text("20 km", style: Theme.of(context).textTheme.bodyText2),
              onTap: () {
                iFab!.setRadius("20 km", 0);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            ListTile(
              title: Text("15 km", style: Theme.of(context).textTheme.bodyText2),
              onTap: () {
                iFab!.setRadius("15 km", 1);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            ListTile(
              title: Text("10 km", style: Theme.of(context).textTheme.bodyText2),
              onTap: () {
                iFab!.setRadius("10 km", 2);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            ListTile(
              title: Text("5 km", style: Theme.of(context).textTheme.bodyText2),
              onTap: () {
                iFab!.setRadius("5 km", 3);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSort(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.only(topLeft: Radius.elliptical(16, 16), topRight: Radius.elliptical(16, 16)),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              title: Text(AppLocalizations.of(context)!.sortLowPrice, style: Theme.of(context).textTheme.bodyText2),
              onTap: () {
                iFab!.sortFuel(AppLocalizations.of(context)!.sortLowPrice, 0, 1);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.sortHighPrice, style: Theme.of(context).textTheme.bodyText2),
              onTap: () {
                iFab!.sortFuel(AppLocalizations.of(context)!.sortHighPrice, 1, 0);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.sortDistance, style: Theme.of(context).textTheme.bodyText2),
              onTap: () {
                iFab!.sortFuel(AppLocalizations.of(context)!.sortDistance, 2, -1);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }

}