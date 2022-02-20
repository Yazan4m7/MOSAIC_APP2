import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:http/http.dart' as http;
import 'package:mosaic_doctors/models/sessionData.dart';
import 'package:mosaic_doctors/services/auth_service.dart';
import 'package:mosaic_doctors/services/notifications.dart';
import 'package:mosaic_doctors/shared/globalVariables.dart';
import 'package:mosaic_doctors/shared/locator.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Global.initializeSharedPreferences();
  await Firebase.initializeApp();
  //AuthService.signOut();

  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    home: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(resizeToAvoidBottomInset: false, body: EntryPoint()),
    ),
  ));
}

class EntryPoint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Notifications.initializeFCM();
    // Set user's country

    try {
      getIt<SessionData>().countryCode =
          WidgetsBinding.instance!.window.locale.countryCode!;
      print("Country code [Method 1]: " + getIt<SessionData>().countryCode);
    } catch (e) {
      print(
          "Couldn't get country code from WidgetsBinding, trying the backup method..");
      _getCountryCodeBackupMethod();
    }

    return ScreenUtilInit(
        designSize: Size(1080, 1920),
        builder: () => MaterialApp(
              home: AuthService().handleAuth(),
            ));
  }

  _getCountryCodeBackupMethod() async {
    final link = Uri.parse('http://ip-api.com/json');
    final jsonEncoded = await http.read(link);

    final Map jsonDecoded = json.decode(jsonEncoded);
    getIt<SessionData>().countryCode = jsonDecoded['countryCode'];
    print("Country Code [method2] : " + getIt<SessionData>().countryCode);
  }
}
