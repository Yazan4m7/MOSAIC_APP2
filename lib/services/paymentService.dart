import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:mosaic_doctors/models/ccPaymentResponse.dart';
import 'package:mosaic_doctors/models/creditCard.dart';
import 'package:mosaic_doctors/models/sessionData.dart';
import 'package:mosaic_doctors/shared/globalVariables.dart';
import 'package:mosaic_doctors/shared/locator.dart';
import 'package:mosaic_doctors/shared/widgets.dart';
import 'package:mosaic_doctors/views/labStatementMainScreen.dart';
import 'package:pointycastle/asymmetric/api.dart';


class PaymentService with ChangeNotifier {

    static initializePayment(double Amount,String cardNumber,String expiryDate,BuildContext context) async{
      cardNumber= cardNumber.replaceAll(" ", "");
        var key  = await getMOSAICkey();
        CreditCard card =  CreditCard(cardNumber: cardNumber,expiryDate: expiryDate,doctorId: getIt<SessionData>().doctor.id.toString());
        Global.prefs.setString("card",jsonEncode(CreditCard.toJson(card)));
        print("Set card in prefs : ${jsonEncode(CreditCard.toJson(card))}");

        var queryParameters = {
          'MOSAICKey' :  key.toString(),
          'cardNumber' : card.cardNumber,
          'expiryDate' : card.expiryDate,
          'customerId': getIt<SessionData>().doctor.id,
          'amount': Amount.toString(),
        };
        var uri =
        Uri.http('lab.manshore.com', '/external-payment/deposit', queryParameters);
        print(uri.toString());
        var response = await http.get(uri);

          print("Payment Response : " + response.body);
          var data = json.decode(response.body);

          CCPaymentResponse resp = CCPaymentResponse.fromJson(data);
          if (resp.isSuccess == true)
          { SharedWidgets.showMOSAICDialog("Payment processed Successfully!", context,"Thank you",(){  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
              LabStatementMainScreen()), (Route<dynamic> route) => false);
          });
          }
          else //error occurred
            SharedWidgets.showMOSAICDialog(resp.errDescription, context,"Sorry, Payment Failed");
         // SharedWidgets.showMOSAICDialog(e.toString(), context);
      return;
    }

    //deprecated
    static getMyCards() async{
      var queryParameters = {
        'customerId': '2374',
      };
      var uri =
      Uri.http('lab.manshore.com', 'external-payment/get-cards', queryParameters);
      print(uri.toString());
      var response = await http.get(uri, headers: {
      });
      print(response.body);
    }
    static encrypt(String input) async{
        final  publicKey = await parseKeyFromFile<RSAPublicKey>("assets/publicKey.pem");
        final encrypter = Encrypter(RSA(publicKey: publicKey));
        final encrypted = encrypter.encrypt(input);
        return encrypted.base64;
    }
    static decrypt(Encrypted input) async{
        final  privateKey = await parseKeyFromFile<RSAPrivateKey>("assets/privateKey.pem");
        final decrypter = Encrypter(RSA(privateKey: privateKey));
        final decrypted = decrypter.decrypt(input);
        return decrypted;
      }
    static encryptMosaicKey(String input) async{
        final keyFile = await rootBundle.loadString("assets/encryptionKeys/mosaicPublicKey.pem");
        final publicKey =  RSAKeyParser().parse(keyFile) as RSAPublicKey;
        final encrypter = Encrypter(RSA(publicKey: publicKey));
        final encrypted = encrypter.encrypt(input);
        print("Encrypted key : " + encrypted.base64 );
        return encrypted.base64;
      }
    static getMOSAICkey() async{
      String mosaicKey = "pM3-y@zEn*mp0+2Xq";
      final oDate = DateTime(2021, 01, 01,0,0,0);
      final date2 = DateTime.now();
      final difference = date2.difference(oDate).inMinutes;
      return await encryptMosaicKey(mosaicKey + difference.toString());

    }

}