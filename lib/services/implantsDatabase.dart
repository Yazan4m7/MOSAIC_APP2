import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mosaic_doctors/models/implantStatementRowModel.dart';
import 'package:mosaic_doctors/models/nbDoctor.dart';
import 'package:mosaic_doctors/models/nbTransactionTypes.dart';
import 'package:mosaic_doctors/models/sessionData.dart';
import 'package:mosaic_doctors/shared/Constants.dart';
import 'package:mosaic_doctors/shared/locator.dart';

class ImplantsDatabase {
  static var ROOT = Constants.ROOT;
  static List<ImplantStatementRowModel> implantsStatementEntries = [];
  static List<String?> docImplantsOrdersIds = [];
  static Map<int, NbTransactionTypes> nbTransTypes =
      new Map<int, NbTransactionTypes>();
  static isNobelClient(String? doctorId) async {
    if (doctorId == null) {
      print("No doctor ID, returning false.");
      return false;
    }
    if (await getDoctorRecord(true) == null) {
      print("No doctor record, returning false.");
      return false;
    }

    print("Is Nobel client : Getting orders");
    var map = Map<String, dynamic>();
    String checkQuery =
        "SELECT * from `nb_orders` WHERE `doctor_id` = '$doctorId' limit 1";
    map['action'] = "GET";
    map['query'] = checkQuery;
    final response = await http.post(ROOT, body: map);
    print("NB orders body : ${response.body}");
    if (response.body.isNotEmpty) return true;
    return false;
  }

  static Future getDoctorImplantAccountStatement(
      String? doctorId, bool forceReload) async {
    if (implantsStatementEntries.isNotEmpty && forceReload) {
      print("Statement already has data.");
      return implantsStatementEntries;
    }
    var queryResults = await postQueryToDB(
        "SELECT nb_account_statements.*, nb_order_items.item_id as orderItemId, nb_items.price" +
            " FROM nb_account_statements" +
            " LEFT JOIN nb_order_items ON nb_account_statements.item_id=nb_order_items.id" +
            " LEFT JOIN nb_items" +
            " ON nb_order_items.item_id = nb_items.id" +
            " WHERE nb_account_statements.doctor_id = $doctorId");

    implantsStatementEntries.clear();
    if (queryResults == null) return null;
    for (int i = 0; i < queryResults.length; i++) {
      ImplantStatementRowModel implantStatementEntry =
          ImplantStatementRowModel.fromJson(queryResults[i]);
      if (implantStatementEntry.orderId != "N/A")
        docImplantsOrdersIds.add(implantStatementEntry.orderId);
      implantsStatementEntries.add(implantStatementEntry);
    }

    implantsStatementEntries.sort((a, b) {
      return a.createdAt!.compareTo(b.createdAt!);
    });

    return implantsStatementEntries;
  }

  static Future getDoctorRecord(bool forceReload) async {
    if (getIt<SessionData>().nbDoctor != null && !forceReload)
      return getIt<SessionData>().nbDoctor;
    var result = await postQueryToDB(
        "SELECT * from `nb_doctors` WHERE `nb_doctors`.`id` = ${getIt<SessionData>().doctor!.implantsRecordId} AND `phone` = '${getIt<SessionData>().doctor!.phone}' ");
    if (result == null) {
      print("getDoc rec returning null");
      return null;
    }

    print("returning doc record $result");
    NbDoctor nbDoctor = NbDoctor.fromJson(result[0]);
    if (nbDoctor.unitsBoughtParallel == '0' &&
        nbDoctor.unitsBoughtActive == '0') return null;
    getIt<SessionData>().nbDoctor = nbDoctor;
    if (implantsStatementEntries.isEmpty)
      await getDoctorImplantAccountStatement(
          getIt<SessionData>().doctor!.implantsRecordId, false);
    getIt<SessionData>().implantsFirstOrderDate =
        implantsStatementEntries.first.createdAt!;
    return nbDoctor;
  }

  static Future getTransactionTypes(bool forceReload) async {
    var queryResults =
        await postQueryToDB("SELECT * from `nb_transaction_types`");
    if (queryResults == null) {
      print("No Transaction types loaded");
      return null;
    }
    if (nbTransTypes == null) nbTransTypes = new Map<int, NbTransactionTypes>();
    for (int i = 0; i < queryResults.length; i++) {
      NbTransactionTypes type = NbTransactionTypes.fromJson(queryResults[i]);
      nbTransTypes[int.parse(type.id!)] = type;
    }
  }

  static Future postQueryToDB(String query) async {
    var map = Map<String, dynamic>();
    map['action'] = "GET";
    map['query'] = query;
    final response = await http.post(ROOT, body: map);
    if (response.body.isEmpty) return null;
    var parsed = await json.decode(response.body);
    return parsed;
  }
}
