import 'dart:convert';
import 'dart:math';

import 'package:mosaic_doctors/services/labDatabase.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
class ExternalCasesController{

  static createCase(String patientName, String address, String dateIn,String dateReturn, String tel, String email, String jobNo,
      String stumpShade, String vitaClassic, String master3d, String translucency,String surfaceTexture, List<String>? enclosedItems,List<String>? miscellaneous,
      List<String>? prosthetics,List<String>? crownBridgeMetalFree,List<String>? crownBridgeMetalRestoration,List<String>? implantWorkMetalFree,List<String>? implantWorkMetalRestoration,
      List<String>? implantWorkAllOn46,List<String>? ulUnits, List<String>? urUnits,List<String>? llUnits,List<String>? lrUnits) async {
    var rng = new Random();
    var token = rng.nextInt(1000);
    var query =
"INSERT INTO `uk_orders` "+
"(`id`, `patient_name`, `address`, `date_in`, `date_return`, `tel`, `email`, `job_no`, `stump_shade`, `vita_classic`, `master_3d`,"+
" `translucency`, `surface_texture`, `enclosed_items`, `miscellaneous`, `prosthetics`, `crown_bridge_metal_free`, `crown_bridge_metal_restoration`"+
", `implant_work_metal_free`, `implant_work_metal_restoration`, `implant_work_all_on_46`, `token`,`ul_units`,`ur_units`,`ll_units`,`lr_units`) "+
"VALUES (NULL, '$patientName', '$address', '$dateIn', '$dateReturn',"+
    "'$tel', '$email', '$jobNo','$stumpShade', '$vitaClassic', '$master3d','$translucency', '$surfaceTexture', '$enclosedItems',"+
    "'$miscellaneous', '$prosthetics', '$crownBridgeMetalFree','$crownBridgeMetalRestoration', '$implantWorkMetalFree', '$implantWorkMetalRestoration',"+
        "'$implantWorkAllOn46', '$token', '$ulUnits', '$urUnits', '$llUnits', '$lrUnits'); ";
    print("Posting new case query");
    var result = await LabDatabase.postQueryToDB(query);
    print("Posting new case query");
    var orderId = await LabDatabase.postQueryToDB("SELECT `id` from `uk_orders` where patient_name = '$patientName' AND token ='$token' ");
    print("order id : ${orderId[0]["id"]}");
    return orderId[0]["id"];
  }

}