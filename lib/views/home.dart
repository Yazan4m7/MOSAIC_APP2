import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mosaic_doctors/models/doctor.dart';
import 'package:mosaic_doctors/models/sessionData.dart';
import 'package:mosaic_doctors/services/auth_service.dart';
import 'package:mosaic_doctors/services/implantsDatabase.dart';
import 'package:mosaic_doctors/services/labDatabase.dart';
import 'package:mosaic_doctors/services/notifications.dart';
import 'package:mosaic_doctors/services/security.dart';
import 'package:mosaic_doctors/shared/font_styles.dart';
import 'package:mosaic_doctors/shared/globalVariables.dart';
import 'package:mosaic_doctors/shared/locator.dart';
import 'package:mosaic_doctors/shared/responsive_helper.dart';
import 'package:mosaic_doctors/shared/widgets.dart';

import 'implantsStatementMainScreen.dart';
import 'labStatementMainScreen.dart';

class HomeView extends StatefulWidget {
  @override
  _homeViewState createState() => _homeViewState();
}

class _homeViewState extends State<HomeView> {
  String? doctorName = "";
  bool isLoading = true;
  bool? isNobelClient;

  List<PopupMenuEntry<String>> options = [];
  getDoctorData() async {
    Doctor? doctor =
        await (LabDatabase.getDoctorInfo(Global.prefs!.getString("phoneNo")!));
    if (doctor == null) {
      getIt<SessionData>().loginWelcomeMessage =
          "Number not assiocated with a doctor account, please contact MOSAIC";
      print("doc is null");
      AuthService.signOut();
    } else {
      doctorName = doctor.name;
      isLoading = false;
      if (mounted) setState(() {});
    }
  }

  checkSession() async {
    Future.delayed(Duration(seconds: 3));
    if (await Security.checkSession() == SessionStatus.inValid) {
      print("Session status : invalid");
      AuthService.signOut();
    } else {
      print("Session status : valid");
    }
  }

  @override
  void initState() {
    Responsiveness.setResponsiveProperties();
    getDoctorData();

    Notifications.initializeFCM();
    // Notifications.scheduleNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // checkSession();
    //double screenWidth = MediaQuery.of(context).size.width;
    ImplantsDatabase.getTransactionTypes(true);
    double screenHeight = MediaQuery.of(context).size.height;
    GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
    return MaterialApp(
        //  theme: GlobalTheme.globalTheme,
        //backgroundColor: Colors.white.withOpacity(.97),
        home: Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: true,
        child: Container(
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Color(0xffc3c3c3), Colors.white30]),
          ),
          child: Stack(
            children: [
              Container(
                alignment: Alignment(2.5, 5),
                child: Image.asset(
                  'assets/images/logo_transaperant.png',
                  height: 600,
                ),
              ),
              isLoading
                  ? Container(
                      child: SpinKitChasingDots(
                      color: Colors.black,
                    ))
                  : Column(
                      children: [
                        SharedWidgets.getAppBarUI(
                            context,
                            _scaffoldKey as GlobalKey<ScaffoldState>,
                            "HOME",
                            PopupMenuButton<String>(
                              onSelected: popupMenuAction,
                              itemBuilder: (BuildContext context) {
                                options.clear();

                                options.add(PopupMenuItem(
                                  child: Row(
                                    children: [
                                      Icon(Icons.logout),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Log out",
                                        style: TextStyle(color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  value: "Sign out",
                                ));
                                return options;
                              },
                            ),
                            _exitApp),
                        Padding(
                          padding: EdgeInsets.only(top: screenHeight / 25),
                          child: Image.asset(
                            'assets/images/MOSAIC_Group.png',
                            width: Responsiveness.logoWidth.w,
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: screenHeight / 24),
                            child: Text(
                              getIt<SessionData>().doctor!.id == "103"
                                  ? "" + doctorName!
                                  : (getIt<SessionData>().countryCode == "JO"
                                      ? "د. " + doctorName!
                                      : "Dr. " + doctorName!),
                              style: MyFontStyles.doctorNameFontStyle(context),
                            )),
                        SizedBox(
                          height: screenHeight / 40,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 4,
                            child: InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xffEDEDED),
                                        Color(0xffF9F9F9)
                                      ],
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0)),
                                height: screenHeight / 8.5,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 50.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Lab Statement',
                                        style: TextStyle(
                                            fontSize: Responsiveness
                                                .mainNavCardsFontSize),
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/MOSAIC_vertical2.png',
                                            alignment: Alignment.centerRight,
                                            height: (screenHeight / 5.6).h,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        LabStatementMainScreen()));
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            elevation: 4,
                            child: InkWell(
                              child: Container(
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xffEDEDED),
                                        Color(0xffF9F9F9)
                                      ],
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                    ),
                                    borderRadius: BorderRadius.circular(15.0)),
                                height: screenHeight / 8.5,
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 50.w),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Implants Statement',
                                          style: TextStyle(
                                              fontSize: Responsiveness
                                                  .mainNavCardsFontSize),
                                        ),
                                        // SizedBox(width: 20,),
                                        Image.asset(
                                            'assets/images/Nobel_vertical.png',
                                            height: (screenHeight / 8.9).h)
                                      ]),
                                ),
                              ),
                              onTap: () async {
                                if (isNobelClient == null)
                                  isNobelClient =
                                      await ImplantsDatabase.isNobelClient(
                                          getIt<SessionData>()
                                              .doctor!
                                              .implantsRecordId);

                                isNobelClient!
                                    ? Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ImplantsStatementView()))
                                    : SharedWidgets.showMOSAICDialog(
                                        "Sorry, you have not purchased any NobelBiocare® implants yet.",
                                        context);
                              },
                            ),
                          ),
                        )
                      ],
                    ),
            ],
          ),
        ),
      ),
    ));
  }

  static _exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  popupMenuAction(String optionSelected) {
    switch (optionSelected) {
      case "Sign out":
        AuthService.signOut();
        break;
      /* case "Logged in devices":
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                LoggedInDevices()));
        break;*/

    }
  }
}
