import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mosaic_doctors/shared/responsive_helper.dart';
import 'package:mosaic_doctors/shared/widgets.dart';
import 'package:mosaic_doctors/views/MepsPayment.dart';
import 'package:mosaic_doctors/views/paymentView.dart';
import 'package:mosaic_doctors/views/webViewGeneric.dart';

class PaymentTypeSelection extends StatefulWidget {
  @override
  _paymentTypeSelectionViewState createState() =>
      _paymentTypeSelectionViewState();
}

class _paymentTypeSelectionViewState extends State<PaymentTypeSelection> {
  String err = "";

  @override
  void initState() {
    Responsiveness.setResponsiveProperties();
    err = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
    return MaterialApp(
        //  theme: GlobalTheme.globalTheme,
        //backgroundColor: Colors.white.withOpacity(.97),
        home: SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SharedWidgets.getAppBarUI(
                        context,
                        _scaffoldKey as GlobalKey<ScaffoldState>,
                        "NEW PAYMENT",
                        null,
                        null,
                        Colors.transparent,
                        0.0),
                    Container(
                      height: MediaQuery.of(context).size.height - 350.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  height: screenHeight / 8.5,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'PAY WITH MOSAIC CARD',
                                          style: TextStyle(
                                              fontSize: Responsiveness
                                                      .mainNavCardsFontSize! -
                                                  8.sp),
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
                                      builder: (context) => PaymentView()));
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
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  height: screenHeight / 8.5,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'PAY WITH CREDIT CARD',
                                          style: TextStyle(
                                              fontSize: Responsiveness
                                                      .mainNavCardsFontSize! -
                                                  8.sp),
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/visa_master_logos.png',
                                              alignment: Alignment.centerRight,
                                              height: (screenHeight / 9.0).h,
                                            ),
                                          ],
                                        ), // SizedBox(width: 20)
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  _showPaymentInitializerDialog();
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          Divider(
                            height: 10,
                            thickness: 1,
                          ),
                          SizedBox(height: 40.h),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: InkWell(
                              child: Container(
                                child: Text(
                                  "Terms and Conditions",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 45.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => WebViewGeneric(
                                        url:
                                            "Mobile App Terms and Conditions.htm",
                                        title: "Terms and Conditions")));
                              },
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: InkWell(
                              child: Container(
                                child: Text(
                                  "Privacy Policy",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 45.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => WebViewGeneric(
                                        url:
                                            "'/MOSAIC Mobile application privacy policy.html'",
                                        title: "Privacy Policy")));
                              },
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: InkWell(
                              child: Container(
                                child: Text(
                                  "Refund Policy",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 45.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              onTap: () async {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => WebViewGeneric(
                                        url: "MOSAIC Refund policy.htm",
                                        title: "Refund Policy")));
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
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

  double amountToPay = 0;
  TextEditingController _amountController = TextEditingController(text: '5');

  _showPaymentInitializerDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height / 1.5,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 7.2.h,
                    padding: EdgeInsets.only(
                        left: 20, top: 45.0 + 20, right: 20, bottom: 20),
                    margin: EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(0, 10),
                              blurRadius: 10),
                        ]),
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return Container(
                          height: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              RichText(
                                  text: TextSpan(
                                    text: '',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text:
                                              'Please enter the amount you want to pay: ',
                                          style: TextStyle(fontSize: 52.sp)),
                                      TextSpan(
                                        text: '(in JOD)',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 42.sp),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center),
                              Text(
                                err,
                                style: TextStyle(color: Colors.red),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                      icon: Icon(
                                          Icons.remove_circle_outline_sharp),
                                      onPressed: () {
                                        setState(() {
                                          if (int.parse(
                                                  _amountController.text) <
                                              6)
                                            return;
                                          else
                                            _amountController.text = (int.parse(
                                                        _amountController
                                                            .text) -
                                                    5)
                                                .toString();
                                        });
                                      },
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TextFormField(
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          suffixStyle: TextStyle(),
                                          contentPadding: EdgeInsets.only(
                                              left: 0,
                                              bottom: 0,
                                              top: 0,
                                              right: 0),
                                          hintText: 'Amount in JOD'),
                                      controller: _amountController,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                        icon: Icon(
                                            Icons.add_circle_outline_sharp),
                                        onPressed: () {
                                          setState(() {
                                            _amountController.text = (int.parse(
                                                        _amountController
                                                            .text) +
                                                    5)
                                                .toString();
                                          });
                                        },
                                        color: Colors.black87),
                                  ),
                                ],
                                mainAxisAlignment: MainAxisAlignment.center,
                              ),
                              OutlinedButton(
                                child: Text(
                                  "START PAYMENT",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black87),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0))),
                                ),
                                onPressed: () {
                                  if (!isNumeric(_amountController.text)) {
                                    setState(() {
                                      err = "Please enter a valid number";
                                    });
                                    return;
                                  }
                                  // if (double.parse(_amountController.text) <
                                  //     5) {
                                  //   setState(() {
                                  //     err =
                                  //         "Please enter a value greater than 5";
                                  //   });
                                  //   return;
                                  // }
                                  Navigator.of(context).pop();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MepsPayment(
                                          amountToPay: double.parse(
                                              _amountController.text))));
                                },
                              )
                            ],
                          ));
                    }),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 45,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(45)),
                        child: Image.asset("assets/images/Icon-Black.png",
                            width: 220.h),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
