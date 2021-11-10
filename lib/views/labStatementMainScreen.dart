import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mosaic_doctors/models/AccountStatementEntry.dart';
import 'package:mosaic_doctors/models/sessionData.dart';
import 'package:mosaic_doctors/models/statementTotals.dart';
import 'package:mosaic_doctors/services/auth_service.dart';
import 'package:mosaic_doctors/services/exportingService.dart';
import 'package:mosaic_doctors/services/labDatabase.dart';
import 'package:mosaic_doctors/services/security.dart';
import 'package:mosaic_doctors/shared/Constants.dart';
import 'package:mosaic_doctors/shared/font_styles.dart';
import 'package:mosaic_doctors/shared/locator.dart';
import 'package:mosaic_doctors/shared/responsive_helper.dart';
import 'package:mosaic_doctors/shared/widgets.dart';
import 'package:mosaic_doctors/views/StatementEntryRow.dart';
import 'package:mosaic_doctors/views/paymentView.dart';

import '../SignIn_with_phone.dart';
import 'createCaseWizerd.dart';

class LabStatementMainScreen extends StatefulWidget {
  Jiffy? month;
  LabStatementMainScreen([this.month]);
  @override
  _LabStatementMainScreenState createState() => _LabStatementMainScreenState();
}

class _LabStatementMainScreenState extends State<LabStatementMainScreen> {
  // build bottom banner when statement is ready
  bool isStatementReady = false;
  Future? accountStatementEntries;
  double roundedBalance = 0;
  List<AccountStatementEntry?> pdfTable = [];
  bool isOldestMonth = false;
  Jiffy twoMonthsAgo = Jiffy()..subtract(months: 2);
  bool isNewestMonth = true;

  static Jiffy currentMonth = Jiffy();
  StatementTotals? totalsItem;
  List<PopupMenuEntry<String>> options = [];

  getAccountStatement() {
    accountStatementEntries = LabDatabase.getDoctorAccountStatement(
        getIt<SessionData>().doctor!.id, false);
  }

  getAccountStatementTotals(currentMonth) {
    totals = LabDatabase.getAccountStatementTotals(currentMonth);
  }

  refreshStatement() {
    accountStatementEntries = LabDatabase.getDoctorAccountStatement(
        getIt<SessionData>().doctor!.id, true);
    setState(() {});
  }

  checkSession(BuildContext context) async {
    print("checking session in AS Entry");
    if (await Security.checkSession() == SessionStatus.inValid) {
      print("Session is invalid");
      await AuthService.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false);
    } else
      print("Session is valid.");
  }

  @override
  void initState() {
    currentMonth = widget.month ?? Jiffy();
    getAccountStatement();
    getAccountStatementTotals(currentMonth);
    roundedBalance = 0;

    super.initState();
  }

  static Future<Null>? isRegistering;
  GlobalKey? _scaffoldKey;
  double? screenHeight;
  double? rowWidth; // 16 padding
  double? screenWidth; // 16 padding
  final formatter = new NumberFormat("#,###");
  bool _roundedBalanceBuilt = false;
  bool _accountStatementBuilt = false;
  bool _bottomCountersBuilt = false;
  @override
  Widget build(BuildContext context) {
    print("Doctor can create case : " +
        (getIt<SessionData>().doctor!.canCreateCase == '1').toString());

    _setMonthsNavigationFlags();
    pdfTable.clear();
    _roundedBalanceBuilt = false;
    _scaffoldKey = GlobalKey<ScaffoldState>();
    screenHeight = MediaQuery.of(context).size.height - 22;
    rowWidth = MediaQuery.of(context).size.width; // 16 padding
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        bottom: true,
        key: _scaffoldKey,
        child: Stack(
          children: [
            Positioned(
              child: Column(children: [
                SharedWidgets.getLabStatementAppBarUI(
                    context,
                    _scaffoldKey as GlobalKey<ScaffoldState>?,
                    "Account Statement ${currentMonth.format("MMMM yyyy")}",
                    !isOldestMonth
                        ? IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: goBackAMonth)
                        : IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.grey,
                            ),
                            onPressed: null),
                    !isNewestMonth
                        ? IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: goForwardAMonth)
                        : IconButton(
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                            ),
                            onPressed: null),
                    IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          _settingModalBottomSheet(context);
                        })),
                _buildAccountStatement()
              ]),
            ),
            _buildBottomCounters(screenHeight, screenWidth)
          ],
        ),
      ),
    );
  }

  Widget _buildAccountStatement() {
    return FutureBuilder(
        future: accountStatementEntries,
        builder: (context, AsyncSnapshot accountStatementEntrys) {
          if (accountStatementEntrys.connectionState ==
              ConnectionState.waiting) {
            return Center(
              child: Container(
                height: screenHeight! - 100,
                child: SpinKitWanderingCubes(
                  color: Colors.black,
                ),
              ),
            );
          }

          if (accountStatementEntrys.connectionState == ConnectionState.none) {
            return Center(
                child: Container(
              height: screenHeight! - 300,
              width: screenWidth! - 100,
              child: Center(
                child: Text(
                  "Failed To Connect, Please check your connection to the internet",
                ),
              ),
            ));
          }
          if (accountStatementEntrys.data == null) {
            return Center(
                child: Container(
              height: screenHeight! - 300,
              width: screenWidth! - 100,
              child: Center(
                child: Text(
                  "No Cases Found.",
                ),
              ),
            ));
          }
          return Column(
            //mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: rowWidth,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        children: [
                          Container(
                            height: screenHeight! / 90.h,
                            child: Container(
                              child: SingleChildScrollView(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 3),
                                      width: rowWidth! / labDateCellWidthFactor,
                                      child: Text(" Date",
                                          style: MyFontStyles
                                              .statementHeaderFontStyle(
                                                  context)),
                                    ),
                                    Container(
                                      width:
                                          rowWidth! / labEntryCellWidthFactor,
                                      child: Text("Entry",
                                          style: MyFontStyles
                                              .statementHeaderFontStyle(
                                                  context),
                                          textAlign: TextAlign.center),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 0),
                                      width:
                                          rowWidth! / labCreditCellWidthFactor,
                                      child: Text("Credit",
                                          style: MyFontStyles
                                              .statementHeaderFontStyle(
                                                  context),
                                          textAlign: TextAlign.left),
                                    ),
                                    Container(
                                      width:
                                          rowWidth! / labDebitCellWidthFactor,
                                      child: Text("Debit",
                                          style: MyFontStyles
                                              .statementHeaderFontStyle(
                                                  context),
                                          textAlign: TextAlign.left),
                                    ),
                                    Container(
                                      // alignment: Alignment.center,
                                      width:
                                          rowWidth! / labBalanceCellWidthFactor,
                                      child: Text("Balance",
                                          style: MyFontStyles
                                              .statementHeaderFontStyle(
                                                  context),
                                          textAlign: TextAlign.left),
                                    ),
                                  ],
                                ),
                                scrollDirection: Axis.horizontal,
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              height:
                                  screenHeight! - (screenHeight! / 12) - 328.h,
                              width: rowWidth,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: screenHeight! / 25),
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        accountStatementEntrys.data.length,
                                    itemBuilder: (context, index) {
                                      AccountStatementEntry? ASE =
                                          accountStatementEntrys.data[index];
                                      //if doctor has no transactions this month, and we're at the latest month, build rounded balance and exit.
                                      if (!LabDatabase
                                              .drHasTransactionsThisMonth &&
                                          !_roundedBalanceBuilt &&
                                          (currentMonth.format("yy-MM") ==
                                              Jiffy().format("yy-MM"))) {
                                        index =
                                            accountStatementEntrys.data.length -
                                                1;
                                        pdfTable.add(ASE);

                                        return _buildRoundedBalanceEntry(
                                            accountStatementEntrys.data[
                                                accountStatementEntrys
                                                        .data.length -
                                                    1],
                                            false);
                                      }
                                      if (ASE!.createdAt!.substring(2, 7) !=
                                          currentMonth.format("yy-MM"))
                                        return SizedBox();
                                      if (!_roundedBalanceBuilt) {
                                        return Column(
                                          children: [
                                            _buildRoundedBalanceEntry(ASE),
                                            LabEntryRow(ASE)
                                          ],
                                        );
                                      } else {
                                        pdfTable.add(ASE);

//                                        if(index == accountStatementEntrys.data.length-1)
//                                        {_accountStatementBuilt = true;
//                                        if (!_bottomCountersBuilt)
//                                          WidgetsBinding.instance
//                                            .addPostFrameCallback((_) =>  setState(() {
//                                          _bottomCountersBuilt = true;
//                                        }));
//                                        print("Finished building AS");}
                                        return LabEntryRow(ASE);
                                      }
                                    }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Future? totals;
  Widget _buildBottomCounters(double? screenHeight, double? screenWidth) {
    getAccountStatementTotals(currentMonth);
    return FutureBuilder(
        future: totals,
        builder: (context, AsyncSnapshot data) {
          totalsItem = data.data;
          if (data.data == null)
            return Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: screenWidth! / 8, top: (screenHeight! / 12) / 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            offset: const Offset(0, -2),
                            blurRadius: 8.0),
                      ],
                    ),
                    height: screenHeight / 12,
                    width: screenWidth,
                    child: Row(
                      children: [
                        Flexible(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Credit: "),
                              Row(
                                children: [
                                  Text('0',
                                      style:
                                          MyFontStyles.statementHeaderFontStyle(
                                              context)),
                                  Text(" JOD")
                                ],
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Debit: "),
                              Row(
                                children: [
                                  Text('0',
                                      style:
                                          MyFontStyles.statementHeaderFontStyle(
                                              context),
                                      textAlign: TextAlign.left),
                                  Text(" JOD", style: TextStyle())
                                ],
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Balance: "),
                              Row(
                                children: [
                                  Text(getIt<SessionData>().doctor!.balance!,
                                      style:
                                          MyFontStyles.statementHeaderFontStyle(
                                                  context)
                                              .copyWith(
                                        fontSize:
                                            Responsiveness.entryFontSize!.sp +
                                                3,
                                      )),
                                  Text(" JOD")
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.black87.withOpacity(0.8),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              offset: const Offset(0, 2),
                              blurRadius: 8.0),
                        ],
                      ),
                      height: screenHeight / 13,
                      width: screenWidth + 16,
                      child: FlatButton(
                        textColor: Colors.white,
                        splashColor: Colors.grey,
                        child: Padding(
                          padding: EdgeInsets.only(left: 28.0.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.credit_card,
                                size: 80.w,
                              ),
                              Text("MAKE A PAYMENT",
                                  style: TextStyle(fontSize: 43.sp)),
                              Container(
                                width: 60.w,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 5),
                                child: FlatButton(
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(28.0)),
                                  splashColor: Colors.white,
                                  color: Colors.transparent,
                                  child: Icon(Icons.arrow_forward_rounded,
                                      color: Colors.white),
                                  onPressed: () => {},
                                ),
                              )
                            ],
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PaymentView()));
                          //SharedWidgets.showMOSAICDialog("Payments will be available soon.",context);
                        },
                      ))
                ],
              ),
            );
          // print(totalsItem.totalDebit.toString()+ ' ' + totalsItem.openingBalance.toString()+ ' ' + totalsItem.totalCredit.toString());
          return Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: screenWidth! / 8, top: (screenHeight! / 12) / 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          offset: const Offset(0, -2),
                          blurRadius: 8.0),
                    ],
                  ),
                  height: screenHeight / 12,
                  width: screenWidth,
                  child: Row(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Credit: "),
                            Row(
                              children: [
                                Text(formatter.format(totalsItem!.totalCredit),
                                    style:
                                        MyFontStyles.statementHeaderFontStyle(
                                            context)),
                                Text(" JOD")
                              ],
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Debit: "),
                            Row(
                              children: [
                                Text(formatter.format(totalsItem!.totalDebit),
                                    style:
                                        MyFontStyles.statementHeaderFontStyle(
                                            context),
                                    textAlign: TextAlign.left),
                                Text(" JOD", style: TextStyle())
                              ],
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Balance: "),
                            Row(
                              children: [
                                Text(
                                    getIt<SessionData>().doctor!.balance ==
                                            "N/A"
                                        ? "0"
                                        : formatter.format(
                                            totalsItem!.totalDebit +
                                                totalsItem!.openingBalance -
                                                totalsItem!.totalCredit),
                                    style:
                                        MyFontStyles.statementHeaderFontStyle(
                                                context)
                                            .copyWith(
                                      fontSize:
                                          Responsiveness.entryFontSize!.sp + 3,
                                    )),
                                Text(" JOD")
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ('1' == '1')
                    ? Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue.shade700,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 8.0),
                          ],
                        ),
                        height: screenHeight / 13,
                        width: screenWidth + 16,
                        child: FlatButton(
                          textColor: Colors.white,
                          splashColor: Colors.white70,
                          child: Padding(
                            padding: EdgeInsets.only(left: 28.0.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.add_to_queue,
                                  size: 80.w,
                                  color: Colors.white,
                                ),
                                Text("CREATE A NEW CASE",
                                    style: TextStyle(
                                        fontSize: 43.sp, color: Colors.white)),
                                Container(
                                  width: 60.w,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 5),
                                  child: FlatButton(
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(28.0)),
                                    splashColor: Colors.white,
                                    color: Colors.transparent,
                                    child: Icon(Icons.arrow_forward_rounded,
                                        color: Colors.white),
                                    onPressed: () => {},
                                  ),
                                )
                              ],
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => RegisterForm()));
                            //SharedWidgets.showMOSAICDialog("Payments will be available soon.",context);
                          },
                        ))
                    : Text("Hi"),
                Container(
                    decoration: BoxDecoration(
                      color: Colors.black87.withOpacity(0.8),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            offset: const Offset(0, 2),
                            blurRadius: 8.0),
                      ],
                    ),
                    height: screenHeight / 13,
                    width: screenWidth + 16,
                    child: FlatButton(
                      textColor: Colors.white,
                      splashColor: Colors.grey,
                      child: Padding(
                        padding: EdgeInsets.only(left: 28.0.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.credit_card,
                              size: 80.w,
                            ),
                            Text("MAKE A PAYMENT",
                                style: TextStyle(fontSize: 43.sp)),
                            Container(
                              width: 60.w,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 5),
                              child: FlatButton(
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(28.0)),
                                splashColor: Colors.white,
                                color: Colors.transparent,
                                child: Icon(Icons.arrow_forward_rounded,
                                    color: Colors.white),
                                onPressed: () => {},
                              ),
                            )
                          ],
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PaymentView()));
                        //SharedWidgets.showMOSAICDialog("Payments will be available soon.",context);
                      },
                    ))
              ],
            ),
          );
        });
  }

  double openingBalance = 0;
  Widget _buildRoundedBalanceEntry(AccountStatementEntry? ASE,
      [bool isCurrentMonthEntry = true]) {
    double rowWidth = MediaQuery.of(context).size.width;
    openingBalance = 0;
    if (isCurrentMonthEntry) {
      if (ASE!.credit != "N/A") {
        openingBalance = double.parse(ASE.balance!) + double.parse(ASE.credit!);
      } else {
        openingBalance = double.parse(ASE.balance!) - double.parse(ASE.debit!);
      }
    } else {
      openingBalance = double.parse(ASE!.balance!);
    }
    AccountStatementEntry ASEtoPrint = new AccountStatementEntry(
        patientName: getIt<SessionData>().countryCode == "JO"
            ? "رصيد مدور"
            : "Opening Balance",
        createdAt: "N/A",
        credit: "N/A",
        debit: "N/A",
        balance: openingBalance.toString());
    pdfTable.add(ASEtoPrint);
    pdfTable.add(ASE);
    _roundedBalanceBuilt = true;
    return InkWell(
      onTap: () {
        goBackAMonth();
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: rowWidth / labDateCellWidthFactor,
              child: Text(""),
            ),
            Container(
                padding: EdgeInsets.only(right: labPatientNameRightPadding),
                width: rowWidth / labEntryCellWidthFactor,
                child: Text(
                    getIt<SessionData>().countryCode == "JO"
                        ? "رصيد مدور"
                        : "Opening Balance",
                    style: MyFontStyles.statementPatientNameFontStyle(context)
                        .copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize:
                                Responsiveness.patientNameFontSize!.sp + 3.sp),
                    textAlign: TextAlign.right)),
            Container(
              width: rowWidth / labCreditCellWidthFactor,
              child: Text(""),
            ),
            Container(
              width: rowWidth / labDebitCellWidthFactor,
              child: Text(""),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: labCellsLeftPadding),
              width: rowWidth / labBalanceCellWidthFactor,
              child: Text(openingBalance.toString(),
                  style: MyFontStyles.statementEntryFontStyle(context).copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: Responsiveness.patientNameFontSize!.sp + 7.sp),
                  textAlign: TextAlign.left),
            )
          ],
        ),
      ),
    );
  }

  goBackAMonth() {
    Jiffy threeMonthsAgo = Jiffy()..subtract(months: 3);
    if (currentMonth.format("yy-MM") == threeMonthsAgo.format("yy-MM") ||
        isOldestMonth) {
      SharedWidgets.showMOSAICDialog(
          "Sorry, If you wish to view more Please contact us.", context);
      return;
    }
    try {
      if (Jiffy(LabDatabase.firstEntryDate, "yyyy-MM-dd").format("yy-MM") ==
          currentMonth.format("yy-MM")) {
        SharedWidgets.showMOSAICDialog(
            "Sorry, You have no transactions in that month", context);
        return;
      }
    } catch (e) {
      SharedWidgets.showMOSAICDialog(
          "Sorry, You have no transactions in that month", context);
      return;
    }
    setState(() {
      _bottomCountersBuilt = false;
      _accountStatementBuilt = false;
      _roundedBalanceBuilt = false;
      currentMonth = currentMonth..subtract(months: 1);
    });
  }

  goForwardAMonth() {
    if (currentMonth.format("yy-MM") == Jiffy().format("yy-MM")) {
      SharedWidgets.showMOSAICDialog(
          "Sorry, We can't tell the future.", context);
      return;
    }
    setState(() {
      _bottomCountersBuilt = false;
      _accountStatementBuilt = false;
      _roundedBalanceBuilt = false;
      currentMonth = currentMonth..add(months: 1);
    });
  }

  refreshState() {
    setState(() {});
  }

  changeFontSize(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Center(child: new Text("Change font size")),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.add_circle_outline_sharp),
                              onPressed:
                                  Responsiveness.patientNameFontSize == 48
                                      ? () {}
                                      : () {
                                          setState(() {
                                            Responsiveness.increaseSize();
                                          });
                                        },
                              color: Responsiveness.patientNameFontSize == 48
                                  ? Colors.grey
                                  : Colors.black87),
                          Text(Responsiveness.entryFontSize.toString()),
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline_sharp),
                            onPressed: Responsiveness.patientNameFontSize == 28
                                ? () {}
                                : () {
                                    setState(() {
                                      Responsiveness.decreaseSize();
                                    });
                                  },
                            color: Responsiveness.patientNameFontSize == 28
                                ? Colors.grey
                                : Colors.black87,
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      RaisedButton(
                        child: Text(
                          "Ok",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true)
                              .pop('dialog');

                          refreshState();
                        },
                      )
                    ],
                  ));
            })));
  }

  _setMonthsNavigationFlags() {
    Jiffy threeMonthsAgo = Jiffy()..subtract(months: 3);
    if (currentMonth.format("yy-MM") == Jiffy().format("yy-MM"))
      setState(() {
        isNewestMonth = true;
      });
    else
      setState(() {
        isNewestMonth = false;
      });
    if (currentMonth.format("yy-MM") == threeMonthsAgo.format("yy-MM") ||
        currentMonth.format("yy-MM") == Jiffy([2021, 01, 01]).format("yy-MM"))
      setState(() {
        isOldestMonth = true;
      });
    else
      setState(() {
        isOldestMonth = false;
      });
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.refresh),
                    title: new Text('Refresh'),
                    onTap: () {
                      refreshStatement();
                      Navigator.of(context).pop();
                    }),
                new ListTile(
                  leading: new Icon(Icons.save_alt),
                  title: new Text('Save as PDF'),
                  onTap: () {
                    Exporting.saveAsPDF(
                        context,
                        pdfTable,
                        currentMonth,
                        totalsItem!.totalDebit.toString(),
                        totalsItem!.totalCredit.toString());
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.print),
                  title: new Text('Print'),
                  onTap: () {
                    Exporting.printLabPDF(
                        context,
                        pdfTable,
                        currentMonth,
                        totalsItem!.totalDebit.toString(),
                        totalsItem!.totalCredit.toString());
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.format_size),
                  title: new Text('Change font size'),
                  onTap: () {
                    changeFontSize(context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
