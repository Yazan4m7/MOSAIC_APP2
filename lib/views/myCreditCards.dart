

import 'package:flutter/material.dart';
import 'package:mosaic_doctors/models/sessionData.dart';
import 'package:mosaic_doctors/shared/locator.dart';

class MyCreditCards extends StatelessWidget {
  double cardHeight = 250;
  double cardWidth = 520;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Card(
            child: Stack(
              children: <Widget>[
                Image.asset("assets/images/GTP_card.png",width: cardWidth,height: cardHeight,),
                Positioned(
                  bottom : cardHeight/2.8,
                  left:cardHeight/6,
                  child: Text("",
                    // cardInfo.cardNumber,
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.white
                    ),
                  ),
                ),

                Positioned(
                  bottom: cardHeight/4.3,
                  left:cardHeight/1.5,
                  child: Text("",
                    // cardInfo.expiryDate,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),

                Positioned(
                  bottom: cardHeight/10,
                  left: cardHeight/10,
                  child: Text(
                    getIt<SessionData>().doctor!.name!,
                    style: TextStyle(
                        fontFamily: "Droid",
                        color: Colors.white,
                        fontSize: 25.0
                    ),
                    textAlign: TextAlign.end,

                  ),
                ),
              ],
            ),
            elevation: 5.0,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            semanticContainer: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)
            ),
          ),
        ],
      ),
    );
  }
}
