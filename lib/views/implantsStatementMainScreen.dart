import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mosaic_doctors/models/implantStatementRowModel.dart';
import 'package:mosaic_doctors/models/nbDoctor.dart';
import 'package:mosaic_doctors/models/sessionData.dart';
import 'package:mosaic_doctors/models/statementTotals.dart';
import 'package:mosaic_doctors/services/ExportingServiceImplants.dart';
import 'package:mosaic_doctors/services/implantsDatabase.dart';
import 'package:mosaic_doctors/shared/Constants.dart';
import 'package:mosaic_doctors/shared/font_styles.dart';
import 'package:mosaic_doctors/shared/locator.dart';
import 'package:mosaic_doctors/shared/responsive_helper.dart';
import 'package:mosaic_doctors/shared/widgets.dart';
import 'package:mosaic_doctors/views/paymentView.dart';

import 'ImplantsEntryRow.dart';

class ImplantsStatementView extends StatefulWidget {
  Jiffy? month;
  ImplantsStatementView([this.month]);
  @override
  _ImplantsStatementViewState createState() => _ImplantsStatementViewState();
}

class _ImplantsStatementViewState extends State<ImplantsStatementView> {
  Future? nbDoctorRecord;
  bool isStatementReady = false;
  Future? accountStatementEntries;
  List<ImplantStatementRowModel?> pdfTable = [];
  StatementTotals? totalsItem;
  List<PopupMenuEntry<String>> options = [];

  getAccountStatement() {
    accountStatementEntries = ImplantsDatabase.getDoctorImplantAccountStatement(
        getIt<SessionData>().doctor!.implantsRecordId, true);
  }

  getAccountStatementTotals() {
    nbDoctorRecord = ImplantsDatabase.getDoctorRecord(false);
  }

  refreshStatement() {
    accountStatementEntries = ImplantsDatabase.getDoctorImplantAccountStatement(
        getIt<SessionData>().doctor!.implantsRecordId, false);
    nbDoctorRecord = ImplantsDatabase.getDoctorRecord(true);
    setState(() {});
  }

  getTransactionType() {
    if (ImplantsDatabase.nbTransTypes == null)
      ImplantsDatabase.getTransactionTypes(true);
  }

  @override
  void initState() {
    getAccountStatement();
    getAccountStatementTotals();
    getTransactionType();
    super.initState();
  }

  GlobalKey? _scaffoldKey;
  double? screenHeight;
  double? rowWidth; // 16 padding
  double? screenWidth; // 16 padding
  final formatter = new NumberFormat("#,###");

  @override
  Widget build(BuildContext context) {
    print("types : ${ImplantsDatabase.nbTransTypes}");
    pdfTable.clear();
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
                SharedWidgets.getImplantsStatementAppBarUI(
                    context,
                    _scaffoldKey as GlobalKey<ScaffoldState>?,
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
                  "No Orders Found.",
                ),
              ),
            ));
          }
          return Column(
            children: [
              Container(
                width: rowWidth,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: screenHeight! / 90.h,
                            child: Container(
                              child: SingleChildScrollView(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(left: 0),
                                      width: rowWidth! /
                                          implantsDateCellWidthFactor,
                                      child: Text("Date",
                                          style: MyFontStyles
                                              .statementHeaderFontStyle(
                                                  context)),
                                    ),
                                    Container(
                                      width: rowWidth! /
                                          implantsEntryCellWidthFactor,
                                      child: Text("Implant",
                                          style: MyFontStyles
                                              .statementHeaderFontStyle(
                                                  context),
                                          textAlign: TextAlign.left),
                                    ),
                                    Container(
                                      width: rowWidth! /
                                          implantsTypeCellWidthFactor,
                                      child: Text("Trans.",
                                          style: MyFontStyles
                                              .statementHeaderFontStyle(
                                                  context),
                                          textAlign: TextAlign.left),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 0),
                                      width: rowWidth! /
                                          implantsQtyCellWidthFactor,
                                      child: Text("Qty.",
                                          style: MyFontStyles
                                              .statementHeaderFontStyle(
                                                  context),
                                          textAlign: TextAlign.left),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 3),
                                      width: rowWidth! /
                                          implantsPriceCellWidthFactor,
                                      child: Text("P.",
                                          style: MyFontStyles
                                              .statementHeaderFontStyle(
                                                  context),
                                          textAlign: TextAlign.left),
                                    ),
                                    Container(
                                      // alignment: Alignment.center,
                                      width: rowWidth! /
                                          implantsAmountCellWidthFactor,
                                      child: Text("T.",
                                          style: MyFontStyles
                                              .statementHeaderFontStyle(
                                                  context),
                                          textAlign: TextAlign.left),
                                    ),
                                    Container(
                                      // alignment: Alignment.center,
                                      width: rowWidth! /
                                          implantsBalanceCellWidthFactor,
                                      child: Text("BL.",
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
                              height: screenHeight! - (screenHeight! / 2.58),
                              width: rowWidth,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(bottom: screenHeight! / 25),
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount:
                                        accountStatementEntrys.data.length,
                                    itemBuilder: (context, index) {
                                      ImplantStatementRowModel? ASE =
                                          accountStatementEntrys.data[index];
                                      pdfTable.add(ASE);
                                      return ImplantsEntryRow(ASE);
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

  Widget _buildBottomCounters(double? screenHeight, double? screenWidth) {
    getAccountStatementTotals();
    return FutureBuilder(
        future: nbDoctorRecord,
        builder: (context, data) {
          if (data.connectionState == ConnectionState.waiting) {
            return Positioned(
              bottom: 100,
              left: 1,
              right: 1,
              child: SpinKitWanderingCubes(
                color: Colors.black,
              ),
            );
          }
          NbDoctor? nbDoctor = data.data as NbDoctor?;
          //print(" Totals : debit = ${totalsItem.totalDebit} credit ${totalsItem.totalCredit} opening = ${totalsItem.openingBalance}");
          if (data.data == null)
            // in case of no data
            return SizedBox();
          // in case of data
          return Container(
            // color: Colors.white,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Divider(
                    thickness: 1,
                    height: 5,
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Text(
                          " P. : Price | T. : Total | BL. : Balance",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: implantsBottomValueFS),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 4,
                    height: 8,
                  ),
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "IMPLANTS OFFER PERIOD:",
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                              fontSize: implantsBottomTitleFS - 8.sp),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 4,
                  ),
                  Container(
                    color: Colors.white,
                    height: screenHeight! / 18,
                    child: Row(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            flex: 5,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    "STARTS AT",
                                    style: MyFontStyles
                                            .textValueheadingFontStyle(context)
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                implantsBottomTitleFS - 8.sp),
                                  ),
                                  Text(
                                    getIt<SessionData>()
                                        .implantsFirstOrderDate!
                                        .substring(0, 10),
                                    style: TextStyle(
                                        fontSize: implantsBottomValueFS),
                                  )
                                ],
                              ),
                            ),
                          ),
                          VerticalDivider(),
                          Flexible(
                            flex: 5,
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    "ENDS AT",
                                    style: MyFontStyles
                                            .textValueheadingFontStyle(context)
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                implantsBottomTitleFS - 8.sp),
                                  ),
                                  Text(
                                    (int.parse(getIt<SessionData>()
                                                    .implantsFirstOrderDate!
                                                    .substring(0, 4)) +
                                                1)
                                            .toString() +
                                        getIt<SessionData>()
                                            .implantsFirstOrderDate!
                                            .substring(4, 10),
                                    style: TextStyle(
                                        fontSize: implantsBottomValueFS),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Divider(
                    thickness: 3,
                    height: 8,
                  ),
                  Container(
                    height: screenHeight / 12,
                    child: Row(children: [
                      Flexible(
                        flex: 4,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Implants Consumed",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: implantsBottomTitleFS - 10.sp),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: Text("Active",
                                      style: TextStyle(
                                          fontSize: implantsBottomValueFS)),
                                ),
                                Flexible(
                                  flex: 5,
                                  child: Text("Parallel",
                                      style: TextStyle(
                                          fontSize: implantsBottomValueFS)),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: Text(nbDoctor!.unitsBoughtActive!),
                                ),
                                Flexible(
                                  flex: 5,
                                  child: Text(nbDoctor.unitsBoughtParallel!),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(),
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Bonus Available",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: implantsBottomTitleFS - 10.sp),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: Text("Active",
                                      style: TextStyle(
                                          fontSize: implantsBottomValueFS)),
                                ),
                                Flexible(
                                  flex: 5,
                                  child: Text("Parallel",
                                      style: TextStyle(
                                          fontSize: implantsBottomValueFS)),
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Flexible(
                                  flex: 5,
                                  child: Text(nbDoctor.availableBonusActive!),
                                ),
                                Flexible(
                                  flex: 5,
                                  child: Text(nbDoctor.availableBonusParallel!),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      VerticalDivider(),
                      Flexible(
                        flex: 3,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Balance",
                                  style: MyFontStyles.textValueheadingFontStyle(
                                          context)
                                      .copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize:
                                              implantsBottomTitleFS - 3.sp),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Flexible(
                              flex: 5,
                              child: Text(
                                formatter.format(int.parse(nbDoctor.balance!)) +
                                    " JOD",
                                style: TextStyle(
                                    fontSize: implantsBottomValueFS + 10.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
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
                      width: screenWidth! + 16,
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
                      )),
                ]),
          );
        });
  }

  refreshState() {
    setState(() {});
  }

  changeFontSize(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
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
                                  Responsiveness.patientNameFontSize == 38
                                      ? () {}
                                      : () {
                                          setState(() {
                                            Responsiveness.increaseSize();
                                          });
                                        },
                              color: Responsiveness.patientNameFontSize == 38
                                  ? Colors.grey
                                  : Colors.black87),
                          Text(Responsiveness.entryFontSize.toString()),
                          IconButton(
                            icon: Icon(Icons.remove_circle_outline_sharp),
                            onPressed: Responsiveness.patientNameFontSize == 25
                                ? () {}
                                : () {
                                    setState(() {
                                      Responsiveness.decreaseSize();
                                    });
                                  },
                            color: Responsiveness.patientNameFontSize == 25
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
                  onTap: () async {
                    ExportingServiceImplants.printImplantsPDF(
                        context,
                        pdfTable as List<ImplantStatementRowModel>,
                        await (ImplantsDatabase.getDoctorRecord(true)
                            as FutureOr<NbDoctor>));
                    Navigator.of(context).pop();
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.print),
                  title: new Text('Print'),
                  onTap: () async {
                    ExportingServiceImplants.printImplantsPDF(
                        context,
                        pdfTable as List<ImplantStatementRowModel>,
                        await (ImplantsDatabase.getDoctorRecord(true)
                            as FutureOr<NbDoctor>));
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
