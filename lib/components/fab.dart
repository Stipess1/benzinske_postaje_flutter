import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Fab extends StatelessWidget {

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
      borderRadius: BorderRadius.only(topLeft: Radius.elliptical(8, 8), topRight: Radius.elliptical(8, 8)),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text('Edit', style: Theme.of(context).textTheme.bodyText2,),
                leading: Icon(Icons.edit, color: Theme.of(context).iconTheme.color,),
                onTap: () => showCupertinoModalBottomSheet(
                  expand: false,
                  context: context,
                  builder: (context) {
                    return modalFit(context);
                  },
                ),
              ),
              ListTile(
                title: Text('Copy', style: Theme.of(context).textTheme.bodyText2),
                leading: Icon(Icons.content_copy, color: Theme.of(context).iconTheme.color),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: Text('Cut', style: Theme.of(context).textTheme.bodyText2),
                leading: Icon(Icons.content_cut, color: Theme.of(context).iconTheme.color),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: Text('Move', style: Theme.of(context).textTheme.bodyText2),
                leading: Icon(Icons.folder_open, color: Theme.of(context).iconTheme.color),
                onTap: () => Navigator.of(context).pop(),
              ),
              ListTile(
                title: Text('Delete', style: Theme.of(context).textTheme.bodyText2),
                leading: Icon(Icons.delete, color: Theme.of(context).iconTheme.color),
                onTap: () => Navigator.of(context).pop(),
              )
            ],
          ),
        ));
  }

}