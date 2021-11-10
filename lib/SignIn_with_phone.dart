import 'dart:async';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mosaic_doctors/models/sessionData.dart';
import 'package:mosaic_doctors/services/auth_service.dart';
import 'package:mosaic_doctors/shared/globalVariables.dart';
import 'package:mosaic_doctors/shared/locator.dart';
import 'package:mosaic_doctors/shared/styles.dart';
import 'package:mosaic_doctors/shared/widgets.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Timer? _timer;
  int _start = 30;
  bool _sendCodeEnabled = true;
  bool _keyboardVisible = false;

  var focusNode = FocusNode();
  var keyboardVisibilityController = KeyboardVisibilityController();
  void startTimer() {
    const oneSec = const Duration(seconds: 1);

    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0 && mounted) {
          setState(() {
            _sendCodeEnabled = false;
            timer.cancel();
          });
        } else {
          if (mounted)
            setState(() {
              _start--;
            });
        }
      },
    );
  }

  @override
  void dispose() {
    if (_timer != null) _timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (mounted)
        setState(() {
          _keyboardVisible = visible;
          if (visible)
            _scrollToTop();
          else
            _scrollToBottom();
        });
    });
    super.initState();
  }

  _scrollToTop() async {
    await Future.delayed(Duration(milliseconds: 300));
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 600), curve: Curves.ease);
  }

  _scrollToBottom() {
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 600), curve: Curves.ease);
  }

  String? phoneNo, verificationId, smsCode;
  TextEditingController phoneNoTxtController = TextEditingController();
  TextEditingController smsCodeTxtController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool codeSent = false;
  GlobalKey formKey = GlobalKey();

  static String? countryCode =
      WidgetsBinding.instance!.window.locale.countryCode;
  String phoneCode = countryCode != 'JO' ? "+44" : "+962";
  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).viewInsets.bottom);
    double screenHeight = MediaQuery.of(context).size.height;
    //double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      theme: GlobalTheme.globalTheme,
      home: Scaffold(
        // resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        body: Container(
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Color(0xffc3c3c3), Colors.white30]),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: _keyboardVisible
                    ? MediaQuery.of(context).viewInsets.bottom * -1 - 100
                    : -100,
                right: -110,
                child: Container(
                  alignment: Alignment(2.5, 5),
                  child: Image.asset(
                    'assets/images/logo_transaperant.png',
                    height: 600,
                  ),
                ),
              ),
              SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    Form(
                        key: formKey,
                        child: Column(
                          children: <Widget>[
                            Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: screenHeight / 8,
                                ),
                                Image.asset(
                                  'assets/images/MOSAIC_Group.png',
                                  width: 200,
                                ),
                                Divider(),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 50.0, right: 50.0),
                                  child: Text(
                                    getIt<SessionData>().loginWelcomeMessage,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 30.0, right: 30.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 3,
                                            child: TextFormField(
                                              readOnly: true,
                                              onTap: () {
                                                showCountryPicker(
                                                    context: context,
                                                    showPhoneCode: true,
                                                    countryListTheme:
                                                        CountryListThemeData(
                                                      flagSize: 25,
                                                      backgroundColor:
                                                          Colors.white,
                                                      textStyle: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.blueGrey),
                                                      //Optional. Sets the border radius for the bottomsheet.
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                20.0),
                                                        topRight:
                                                            Radius.circular(
                                                                20.0),
                                                      ),
                                                      //Optional. Styles the search field.
                                                      inputDecoration:
                                                          InputDecoration(
                                                        labelText: 'Search',
                                                        hintText:
                                                            'Start typing to search',
                                                        prefixIcon: const Icon(
                                                            Icons.search),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                            color: const Color(
                                                                    0xFF8C98A8)
                                                                .withOpacity(
                                                                    0.2),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    onSelect:
                                                        (Country country) =>
                                                            setState(() {
                                                              phoneCode = '+' +
                                                                  country
                                                                      .phoneCode;
                                                            }));
                                              },
                                              onChanged: (value) {
                                                print(
                                                    "phone code box changed : $phoneCode");
                                              },
                                              enabled: true,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    left: 0,
                                                    bottom: 0,
                                                    top: 9,
                                                    right: 0),
                                                prefixIcon: const Icon(
                                                  Icons.phone,
                                                  color: Colors.black87,
                                                ),
                                                hintText: phoneCode,
                                              ),
                                            )),
                                        Expanded(
                                          flex: 7,
                                          child: TextFormField(
                                            keyboardType: TextInputType.phone,
                                            decoration: InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    left: 15,
                                                    bottom: 0,
                                                    top: 0,
                                                    right: 0),
                                                hintText: 'Phone number'),
                                            controller: phoneNoTxtController,
                                          ),
                                        ),
                                      ],
                                    )),
                                codeSent
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: 50.0, right: 50.0),
                                        child: TextFormField(
                                          focusNode: focusNode,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                              hintText: 'OTP code'),
                                          controller: smsCodeTxtController,
                                        ))
                                    : Container(),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 50.0, right: 50.0),
                                    child: _buildButton(
                                        codeSent ? 'LOG IN' : 'SEND CODE', () {
                                      if (codeSent) {
                                        // hide keyboard
                                        FocusScope.of(context).unfocus();
                                        Global.prefs!.setString(
                                            "phoneNo",
                                            phoneCode +
                                                phoneNoTxtController.text);
                                        AuthService().signInWithOTP(
                                            phoneCode +
                                                phoneNoTxtController.text,
                                            smsCodeTxtController.text,
                                            verificationId);
                                      } else {
                                        startTimer();
                                        print(
                                            "Setting phone number ${phoneCode + phoneNoTxtController.text}");
                                        Global.prefs!.setString(
                                            "phoneNo",
                                            phoneCode +
                                                phoneNoTxtController.text);
                                        verifyPhone(phoneCode +
                                            phoneNoTxtController.text);
                                      }
                                    })),
                                codeSent
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            left: 70.0, right: 70.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Didnt recieve the code ? please allow $_start seconds and re-send",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black),
                                            ),
                                            !_sendCodeEnabled
                                                ? RaisedButton(
                                                    child: Center(
                                                        child: Text(
                                                            'RE-SEND CODE')),
                                                    onPressed: () {
                                                      print(
                                                          "Setting phone number ${phoneCode + phoneNoTxtController.text}");
                                                      Global.prefs!.setString(
                                                          "phoneNo",
                                                          phoneCode +
                                                              phoneNoTxtController
                                                                  .text);
                                                      verifyPhone(phoneCode +
                                                          phoneNoTxtController
                                                              .text);
                                                      startTimer();
                                                    })
                                                : RaisedButton(
                                                    child: Center(
                                                        child: Text(
                                                            'RE-SEND CODE')),
                                                    onPressed: () {
                                                      verifyPhone(phoneCode +
                                                          phoneNoTxtController
                                                              .text);
                                                    })
                                          ],
                                        ))
                                    : SizedBox(),
                              ],
                            ),
                          ],
                        )),
//                    _keyboardVisible
//                        ? SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
//                        : SizedBox()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    if (phoneNo == '') {
      SharedWidgets.showMOSAICDialog("Invalid or empty phone number", context);
      return;
    }
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      SharedWidgets.showMOSAICDialog(authException.message, context);
    };

    final PhoneCodeSent smsSent = (String verId, [int? forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
        _scrollToTop();
        focusNode.requestFocus();
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }

  _buildButton(String text, Function onPress) {
    return Container(
      height: 50.0,
      margin: EdgeInsets.all(10),
      child: RaisedButton(
        onPressed: onPress as void Function()?,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
        padding: EdgeInsets.all(0.0),
        child: Ink(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff3A3A3A), Color(0xff181818)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            constraints: BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ),
    );
  }
}
