import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marquee/marquee.dart';
import 'package:mosaic_doctors/shared/customDialogBox.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'font_styles.dart';

class SharedWidgets {
  static Widget getAppBarUI(
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey, String title,
      [Widget leftAppbarWidget, Function onBackButtonTap]) {
    return Container(
      height: AppBar().preferredSize.height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.0),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
                onTap: onBackButtonTap ??
                    () {
                      Navigator.pop(context);
                    },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0, top: 10, bottom: 10, right: 10),
                  child: onBackButtonTap == null
                      ? Icon(Icons.arrow_back)
                      : Icon(Icons.clear_rounded),
                ),
              ),
            ),
          ),
          Flexible(
            flex: title.contains("Case Info") ? 8 : 9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Material(
                    color: Colors.transparent,
                    child: title.contains("Account Statement")
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Account Statement",
                              ),
                              Text(
                                title.replaceAll("Account Statement", ""),
                                style:
                                    MyFontStyles.titleBlackFontStyle(context),
                              ),
                            ],
                          )
                        : Text(
                            '  ' + title,
                            style: MyFontStyles.titleBlackFontStyle(context),
                          ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              child: leftAppbarWidget ??
                  SizedBox(
                    width: 120.w,
                  ),
            ),
          )
        ],
      ),
    );
  }

  static Widget getLabStatementAppBarUI(
      BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey,
      String title,
      Widget onBackAMonthIconButton,
      Widget onForwordAMonthIconButton,
      [Widget leftAppbarWidget,
      Function onBackButtonTap]) {
    return Container(
      height: AppBar().preferredSize.height,
      decoration: BoxDecoration(
        color: Colors.transparent,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.0),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
                onTap: onBackButtonTap ??
                    () {
                      Navigator.pop(context);
                    },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0, top: 10, bottom: 10, right: 10),
                  child: onBackButtonTap == null
                      ? Icon(Icons.home)
                      : Icon(Icons.clear_rounded),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                onBackAMonthIconButton,
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Account Statement",
                        ),
                        Text(
                          title.replaceAll("Account Statement", ""),
                          style: MyFontStyles.titleBlackFontStyle(context),
                        ),
                      ],
                    ),
                  ),
                ),
                onForwordAMonthIconButton
              ],
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              child: leftAppbarWidget ??
                  SizedBox(
                    width: 120.w,
                  ),
            ),
          )
        ],
      ),
    );
  }

  static Widget getImplantsStatementAppBarUI(
      BuildContext context, GlobalKey<ScaffoldState> scaffoldKey,
      [Widget leftAppbarWidget]) {
    return Container(
      height: AppBar().preferredSize.height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(50.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 5.0, top: 10, bottom: 10, right: 10),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/NB_logo.png',
                              width: 180.w,
                            ),
                            SizedBox(width: 15.w,),
                            Text("IMPLENTS STATEMENT",
                                style: MyFontStyles.titleBlackFontStyle(context).copyWith(fontSize: 48.0.sp)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              child: leftAppbarWidget ??
                  SizedBox(
                    width: 120.w,
                  ),
            ),
          )
        ],
      ),
    );
  }

  static loadingCircle(String label) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitFadingCube(
            color: Colors.black,
          ),
          SizedBox(height: 15),
          Text(
            label,
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }

  static showMOSAICDialog(String text, BuildContext context,
      [String title, Function onSubmit]) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: title ?? "Alert",
            descriptions: text ?? "N/A",
            text: "Ok",
            onSubmit: onSubmit,
          );
        });
  }

  static Widget TextWidget({String text, TextStyle style, int maxChars}) {
    if (text.length > maxChars)
      return Marquee(
        scrollAxis: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        blankSpace: 5.0,
        velocity: 30.0,
        pauseAfterRound: Duration(seconds: 1),
        startPadding: 0.0,
        showFadingOnlyWhenScrolling: false,
        fadingEdgeStartFraction: 0.1,
        fadingEdgeEndFraction: 0.1,
        accelerationDuration: Duration(milliseconds: 500),
        accelerationCurve: Curves.linear,
        decelerationDuration: Duration(milliseconds: 500),
        decelerationCurve: Curves.easeOut,
        text: text,
        style: style,
      );
    else
      return Text(
        text,
        style: style,
      );
  }
}
