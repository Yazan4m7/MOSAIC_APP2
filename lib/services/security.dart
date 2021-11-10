import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mosaic_doctors/models/mobileDevice.dart';
import 'package:mosaic_doctors/models/sessionData.dart';
import 'package:mosaic_doctors/services/labDatabase.dart';
import 'package:mosaic_doctors/shared/Constants.dart';
import 'package:mosaic_doctors/shared/globalVariables.dart';
import 'package:mosaic_doctors/shared/locator.dart';

enum SessionStatus { valid, inValid }

class Security {
  static Future<Null>? isRegistering;
  static var completer = new Completer<Null>();

  static checkSession() async {
    if (isRegistering != null) await isRegistering; // wait for future complete

    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    String? UUID;
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      UUID = build.androidId; //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      UUID = data.identifierForVendor; //UUID for iOS
    }
    var map = Map<String, dynamic>();

    if (getIt<SessionData>().doctor == null)
      await LabDatabase.getDoctorInfo(Global.prefs!.getString("phoneNo")!);
    String getSessionQuery =
        "select * from mobile_sessions where device_uid = '$UUID' AND is_allowed =1 AND user_id = ${getIt<SessionData>().doctor!.id}";
    map['action'] = "GET";
    map['query'] = getSessionQuery;

    final response = await http.post(Constants.ROOT, body: map);

    if (response.body.isEmpty) {
      return SessionStatus.inValid;
    } else {
      return SessionStatus.valid;
    }
  }

  static registerSession() async {
    isRegistering = completer.future;

    if (await checkIfAlreadyRegistered()) return;
    var map = Map<String, dynamic>();
    String? deviceName;
    String? deviceVersion;
    String? identifier;
    String? platform;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        platform = "Android";
        var build = await deviceInfoPlugin.androidInfo;
        deviceName = build.model;
        deviceVersion = build.version.release;
        identifier = build.androidId; //UUID for Android
      } else if (Platform.isIOS) {
        platform = "iOS";
        var data = await deviceInfoPlugin.iosInfo;
        deviceName = data.name;
        deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }

    //String ip = await getIP();

    if (getIt<SessionData>().doctor == null)
      await LabDatabase.getDoctorInfo(Global.prefs!.getString("phoneNo")!);
    String registerDeviceQuery = "INSERT INTO `mobile_sessions` "
        "(`id`, `device_uid`, `user_id`, `platform` , `os_id`, `device_name`, `ip`, `is_allowed`, `date_created`) VALUES "
        "(NULL, '$identifier', '${getIt<SessionData>().doctor!.id}','$platform' , '$deviceVersion', '$deviceName', 'xxx', '1', current_timestamp())";
    map['action'] = "POST";
    map['query'] = registerDeviceQuery;
    print("registering $registerDeviceQuery ");
    await http.post(Constants.ROOT, body: map);
    print("registered");
    if (!completer.isCompleted) {
      completer.complete();
      isRegistering = null;
    }
  }

  static getIP() async {
    try {
      Uri url = Uri(host: 'https://api.ipify.org');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // The response body is the IP in plain text, so just
        // return it as-is.
        return (response.body);
      } else {
        // The request failed with a non-200 code
        // The ipify.org API has a lot of guaranteed uptime
        // promises, so this shouldn't ever actually happen.
        print(response.statusCode);
        print(response.body);
        return null;
      }
    } catch (e) {}
  }

  static getLoggedInDevices() async {
    var map = Map<String, dynamic>();
    List<Device> loggedInDevices = [];
    String getDevicesQuery =
        "select * from mobile_sessions where user_id = ${getIt<SessionData>().doctor!.id}";
    map['action'] = "GET";
    map['query'] = getDevicesQuery;
    print("getting logge in devices  $getDevicesQuery");
    final response = await http.post(Constants.ROOT, body: map);
    var parsed = json.decode(response.body);
    print("logged in : " + parsed);
    for (int i = 0; i < parsed.length; i++) {
      Device device = Device.fromJson(parsed[i]);
      loggedInDevices.add(device);
    }
    return loggedInDevices;
  }

  static checkIfAlreadyRegistered() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    String? UUID;
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      UUID = build.androidId; //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      UUID = data.identifierForVendor; //UUID for iOS
    }
    var map = Map<String, dynamic>();

    if (getIt<SessionData>().doctor == null)
      await LabDatabase.getDoctorInfo(Global.prefs!.getString("phoneNo")!);
    String getSessionQuery =
        "select * from mobile_sessions where device_uid = '$UUID' AND is_allowed =1 AND user_id = ${getIt<SessionData>().doctor!.id}";
    map['action'] = "GET";
    map['query'] = getSessionQuery;

    final response = await http.post(Constants.ROOT, body: map);

    if (response.body.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static logoutDevice(String? UUID) async {
    print("Loggin out $UUID");
    var map = Map<String, dynamic>();
    String removeDeviceQuery =
        "DELETE FROM `mobile_sessions` WHERE `mobile_sessions`.`device_uid` = '$UUID'";
    map['action'] = "POST";
    map['query'] = removeDeviceQuery;
    var response = await http.post(Constants.ROOT, body: map);
    print("Logged out :  ${response.body}");
  }

  static getDeviceUUID() async {
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    String? UUID;
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      UUID = build.androidId; //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      UUID = data.identifierForVendor; //UUID for iOS
    }
    return UUID;
  }
}
