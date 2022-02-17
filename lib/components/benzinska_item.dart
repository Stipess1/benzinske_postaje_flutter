
import 'package:benzinske_postaje/model/gorivo.dart';
import 'package:benzinske_postaje/model/postaja.dart';
import 'package:benzinske_postaje/screens/info/view/benzinska_info.dart';
import 'package:flutter/material.dart';
import 'package:benzinske_postaje/util/hex_color.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';

class BenzinskaItem extends StatelessWidget {

  Postaja postaja;
  List<Gorivo> goriva;

  BenzinskaItem({Key? key, this.onTap, required this.postaja, required this.goriva}) : super(key: key);

  final void Function() ?onTap;

  Widget buildImage() {
    if(postaja.img!.contains("http")) {
      return Hero(
        tag: postaja.id!,
        child: Image.network(
            postaja.img!,
            width: 50,
            fit: BoxFit.contain),
      );
    } else {

      return Hero(
        tag: postaja.id!,
        child: Image.asset(
            postaja.img!,
            width: 50,
            fit: BoxFit.contain),
      );
    }
  }

  Widget buildStatus() {

    String status = postaja.otvoreno! ? "Otvoreno" : "Zatvoreno";
    Color text = postaja.otvoreno! ? Color(0xFF29C467) : HexColor.fromHex("c42929");
    Color border = postaja.otvoreno! ? Color(0x2F2dd36f) : Color(0x2Fd32d35);

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, right: 10, bottom: 5, left: 10),
        child: Text(status,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: TextStyle(
              color: text,
              fontWeight: FontWeight.w600

          ),
        ),
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: border
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 15, right: 15),
      child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 1,
                  blurRadius: 14,
                  offset: Offset(0, 8)
              )]
          ),
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: () {
                Navigator.push(context, PageRouteBuilder(
                  transitionDuration: Duration(milliseconds: 350),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child,);
                    },
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return BenzinskaInfo(postaja: postaja, goriva: this.goriva, isMapSelected: false);
                    },
                  )
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),

                child: Row(
                  children: <Widget> [
                    Flexible(
                      flex: 1,
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          // width: 35,
                          alignment: Alignment.center,
                          child: buildImage(),
                        ),
                      ),
                    ),
                    Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget> [
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Text(postaja.naziv!,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.fade,
                                  // style: Theme.of(context).textTheme.body1,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15
                                  ),
                                ),
                              ),
                              Text(postaja.adresa!,
                                overflow: TextOverflow.fade,
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 13
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget> [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Icon(Ionicons.navigate_outline, size: 16,),
                                  ),
                                  Text(postaja.udaljenost.toString() + " km"),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4, top: 5),
                                    child: buildStatus(),
                                  )
                                ],
                              )
                            ],
                          ),
                        )
                    ),

                    Flexible(
                      flex: 2,
                      fit: FlexFit.loose,
                      child: Container(
                        child: Row(

                          children: [
                            Padding(
                              padding: const EdgeInsets.only( right: 5),
                              child: Container(height: 80, width: 3, child: VerticalDivider(color: Colors.grey)),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedSwitcher(
                                    duration: Duration(seconds: 1),
                                    transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: child),
                                    child: Text(postaja.gorivo!, style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: "VarelaRound"
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Text("kn/L", style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400
                                    ),
                                      textAlign: TextAlign.center
                                  )
                                ],
                              ),
                            )
                            ,
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }
}