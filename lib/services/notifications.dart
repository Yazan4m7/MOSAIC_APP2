import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mosaic_doctors/services/labDatabase.dart';
import 'package:mosaic_doctors/shared/Constants.dart';
import 'package:mosaic_doctors/shared/globalVariables.dart';
import 'package:mosaic_doctors/views/labStatementMainScreen.dart';

class Notifications {
  static String? month = '';

  /// To verify things are working, check out the native platform logs.
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    month = message.data['month'];
    showLastMonthAccountStatement(month!);
  }

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static late AndroidNotificationChannel channel;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static initializeFCM() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        month = message.data['month'];

        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,

                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      showLastMonthAccountStatement(message.data['month']);
    });
    String? phoneN = Global.prefs!.getString("phoneNo");
    if (Constants.debuggers.contains(phoneN)) {
      FirebaseMessaging.instance.subscribeToTopic('testing');
      print("Subscribed to testing topic");
    } else {
      print(
          "Number ($phoneN) not in testers group, not subscribing to testing topic");
    }
  }

  static Future onSelectNotification(String? payload) async {
    showLastMonthAccountStatement(month!);
  }

  static Future showLastMonthAccountStatement(String month) async {
    print("showLastMonthAccountStatement(String month) $month");
    Jiffy requiredMonth = Jiffy(month, 'MM-yyyy');
    print("Global.getData('phoneNo'");
    String phoneNumber = await Global.getData('phoneNo');
    print("Global.getData('phoneNo'");
    await LabDatabase.getDoctorInfo(phoneNumber);
    Get.to(LabStatementMainScreen(requiredMonth));
    print('notification payload: ' + month);
  }
}
