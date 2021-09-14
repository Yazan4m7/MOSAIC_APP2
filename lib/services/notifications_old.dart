//import 'dart:io';
//
//import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart'
//    as notifs;
//import 'package:get/get.dart';
//import 'package:jiffy/jiffy.dart';
//import 'package:mosaic_doctors/models/sessionData.dart';
//import 'package:mosaic_doctors/services/labDatabase.dart';
//import 'package:mosaic_doctors/shared/Constants.dart';
//import 'package:mosaic_doctors/shared/date_helper.dart';
//import 'package:mosaic_doctors/shared/globalVariables.dart';
//import 'package:mosaic_doctors/shared/locator.dart';
//import 'package:mosaic_doctors/views/labStatementMainScreen.dart';
//
//import 'package:timezone/data/latest.dart' as tz;
//import 'package:timezone/timezone.dart' as tz;
//import 'package:permission_handler/permission_handler.dart';
//class NotificationsOld {
//  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//  FlutterLocalNotificationsPlugin();
//  static BuildContext BContext;
//
//  static initializeFCM() async{
//    await Firebase.initializeApp();
//    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//
//    if (Platform.isIOS)
//    await _firebaseMessaging.requestNotificationPermissions(
//      IosNotificationSettings(alert: true,
//        badge: true,
//        provisional: false,
//        sound: true,)
//    );
//    else{
//      final status = await Permission.notification.request();
//    print("N. Permission for android : $status");}
//
//    _firebaseMessaging.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print("onMessage: $message");
//        const AndroidNotificationDetails androidPlatformChannelSpecifics =
//        AndroidNotificationDetails('1', 'MOSAIC', 'MOSAIC_DESC',
//            importance: Importance.max,
//            priority: Priority.high,
//            showWhen: false);
//        const NotificationDetails platformChannelSpecifics =
//        NotificationDetails(android: androidPlatformChannelSpecifics);
//
//        await flutterLocalNotificationsPlugin
//            .show(0, "Title", "body", platformChannelSpecifics, payload:message['data']['month']);
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print("onResume: $message");
//        showLastMonthAccountStatement(message['data']['month']);
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print("onL: $message");
//        showLastMonthAccountStatement(message['data']['month']);
//      },
//    );
//   try {
//     String phoneNumber = await Global.getData("phoneNo");
//     if (Constants.debuggers.contains(phoneNumber)) {
//       _firebaseMessaging.subscribeToTopic('testing');
//       print("Subscribed to testing topic");
//     }
//     else{
//       print("Didnt subscribe $phoneNumber is not a debugger");
//     }
//   }catch(e){
//     print("Cannot subcribe to testing topic $e");
//   }
//    print("Notification services enabled.");
//    _firebaseMessaging.getToken().then((value) => print("N. Token : " + value));
//  }
//
//
//  static initializeLocalNotificationPlugin(BuildContext context) async {
//    BContext = context;
//    try {
//      const AndroidInitializationSettings initializationSettingsAndroid =
//          AndroidInitializationSettings('mipmap/mosaic_logo_1cmt');
//      final IOSInitializationSettings initializationSettingsIOS =
//          IOSInitializationSettings(
//              onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//      final InitializationSettings initializationSettings =
//          InitializationSettings(
//        android: initializationSettingsAndroid,
//        iOS: initializationSettingsIOS,
//      );
//      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
//          onSelectNotification: showLastMonthAccountStatement);
//      print("Local N. services initialized");
//    } catch (e) {
//      print("ERROR IN  Local N. $e");
//    }
//  }
//
//  static Future onDidReceiveLocalNotification(
//      int id, String title, String body,String extra) async {
//    String dateParameter = extra;
//    print("Local notifiation on recieve fired, month : $dateParameter");
//    Jiffy requiredMonth = Jiffy(dateParameter,'MM-yy');
//    Get.to(LabStatementMainScreen(requiredMonth));
//  }
//
//  static Future showLastMonthAccountStatement(String month) async {
//    print("showLastMonthAccountStatement(String month) $month");
//    Jiffy requiredMonth = Jiffy(month,'MM-yyyy');
//    print("Global.getData('phoneNo'");
//    String phoneNumber = await Global.getData('phoneNo');
//    print("Global.getData('phoneNo'");
//    await LabDatabase.getDoctorInfo(phoneNumber);
//    Get.to(LabStatementMainScreen(requiredMonth));
//    print('notification payload: ' + month);
//  }
//
//  static Future<void> scheduleNotification({String title, String body}) async {
//    flutterLocalNotificationsPlugin.cancelAll();
//
//    bool scheduledBefore = Global.prefs.getBool("febNotificationScheduled") ?? false;
//    var date = new DateTime.now();
//    var month = date.month;
//    print("Scheduling notification : current month : ${date.month}");
//    if (month == 3 && !scheduledBefore && Platform.isIOS) {
//      print("Scheduling notification!!");
//      int daysUntilNextMonth = DateHelper.daysUntilNxtMonth();
//
//      print("Days until next month : $daysUntilNextMonth");
//      tz.initializeTimeZones();
//
//      var androidSpecifics = notifs.AndroidNotificationDetails(
//        '1', // This specifies the ID of the Notification
//        'Scheduled notification',
//        // This specifies the name of the notification channel
//        'A scheduled notification',
//        //This specifies the description of the channel
//        icon: 'mipmap/mosaic_logo_1cmt',
//      );
//
//      final IOSInitializationSettings initializationSettingsIOS =
//      IOSInitializationSettings(
//          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
//      var iOSSpecifics = notifs.IOSNotificationDetails();
//
//      var platformChannelSpecifics = notifs.NotificationDetails(
//          android: androidSpecifics, iOS: iOSSpecifics);
//
//      await flutterLocalNotificationsPlugin.zonedSchedule(
//          0,
//          'Your account statement for last month is ready!',
//          'Click here to view',
//          tz.TZDateTime.now(tz.local).add(Duration(minutes: 5)),
//          platformChannelSpecifics,
//          androidAllowWhileIdle: true,
//          uiLocalNotificationDateInterpretation:
//          UILocalNotificationDateInterpretation.absoluteTime,payload: "02-2021");
//      Global.prefs.setBool("febNotificationScheduled",true);
//    }
//  }
//}
