import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mosaic_doctors/models/discount.dart';
import 'package:mosaic_doctors/models/doctor.dart';
import 'package:mosaic_doctors/models/job.dart';
import 'package:mosaic_doctors/models/sessionData.dart';
import 'package:mosaic_doctors/services/labDatabase.dart';
import 'package:mosaic_doctors/shared/font_styles.dart';
import 'package:mosaic_doctors/shared/locator.dart';
import 'package:mosaic_doctors/shared/styles.dart';
import 'package:mosaic_doctors/shared/widgets.dart';
import 'package:mosaic_doctors/views/feedback.dart';

class CaseDetailsView extends StatefulWidget {
  String caseId;
  String patientName;
  String deliveryDate;
  CaseDetailsView({this.caseId, this.patientName, this.deliveryDate});

  @override
  _CaseDetailsViewState createState() => _CaseDetailsViewState();
}

class _CaseDetailsViewState extends State<CaseDetailsView> {
  Future jobsList;
  Future caseItem;
  getCaseDetails() {
    jobsList = LabDatabase.getCaseJobs(widget.caseId);
    caseItem = LabDatabase.getCase(widget.caseId);
  }

  @override
  void initState() {
    getCaseDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();
    double screenWidth = MediaQuery.of(context).size.width - 40;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: GlobalTheme.caseDetailsViewBoxDec,
        key: _scaffoldKey,
        child: Column(
          children: [
            SafeArea(
                child: SharedWidgets.getAppBarUI(
                    context, _scaffoldKey, "Case Info")),
            SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 4,
                        child: Column(children: [
                          Container(
                              width: MediaQuery.of(context).size.width - 20,
                              child: Text(
                                "Patient Name",
                                style:
                                    MyFontStyles.textHeadingFontStyle(context),
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width - 20,
                            alignment: Alignment.topLeft,
                            child: Text(
                              widget.patientName ?? "N/A",
                              style: MyFontStyles.doctorNameFontStyle(context)
                                  .copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400),
                            ),
                          ),
                          SizedBox(height: 25),
                          Column(
                            children: [
                              Container(
                                  alignment: Alignment.topLeft,
                                  child: Text("Delivery Date",
                                      style: MyFontStyles.textHeadingFontStyle(
                                          context))),
                              Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      widget.deliveryDate == null
                                          ? "N/A "
                                          : widget.deliveryDate
                                              .substring(0, 10),
                                      style: MyFontStyles
                                          .textValueheadingFontStyle(context)))
                            ],
                          ),
                        ]),
                      ),
                      SizedBox(height: 30),
                      Row(children: <Widget>[
                        Container(
                            child: Text("Jobs :",
                                style: MyFontStyles.textHeadingFontStyle(
                                    context))),
                      ]),
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: screenWidth / 4,
                            child: Text('Total Units',
                                style: MyFontStyles.valueFontStyle(context)
                                    .copyWith(fontWeight: FontWeight.w700)),
                          ),
                          Container(
                            width: screenWidth / 5,
                            child: Text('Type',
                                style: MyFontStyles.valueFontStyle(context)
                                    .copyWith(fontWeight: FontWeight.w700)),
                          ),
                          Container(
                            width: screenWidth / 3,
                            child: Text('Material',
                                style: MyFontStyles.valueFontStyle(context)
                                    .copyWith(fontWeight: FontWeight.w700)),
                          ),
                          Container(
                            width: screenWidth / 6,
                            child: Text('Price',
                                style: MyFontStyles.valueFontStyle(context)
                                    .copyWith(fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      Divider(),
                      Container(
                        height: screenHeight / 3,
                        child: FutureBuilder(
                          future: jobsList,
                          builder: (context, projectSnap) {
                            switch (projectSnap.connectionState) {
                              case ConnectionState.none:
                                return SharedWidgets.loadingCircle(
                                    'Connection failed');
                              case ConnectionState.waiting:
                                return SharedWidgets.loadingCircle(
                                    'Waiting Connection');
                              case ConnectionState.active:
                                break;
                              case ConnectionState.done:
                                {
                                  if (projectSnap == null) {
                                    return CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white));
                                  }
                                  if (!projectSnap.hasData)
                                    return Text('No Jobs',
                                        style:
                                            MyFontStyles.textHeadingFontStyle(
                                                context));
                                }
                                break;
                            }
                            Doctor doctor = getIt<SessionData>().doctor;
                            print(
                                "Doctor disount list length: ${doctor.discounts.length} case id : ${widget.caseId} jobs list len: ${projectSnap.data.length}");
                            return Stack(
                              children: [
                                ListView.builder(
                                  //scrollDirection: Axis.vertical,
                                  padding: EdgeInsets.all(0),
                                  shrinkWrap: true,
                                  itemCount: projectSnap.data.length,
                                  itemBuilder: (context, index) {
                                    Job job = projectSnap.data[index];

                                    String numOfUnits =
                                        (','.allMatches(job.unitNum).length + 1)
                                            .toString();

                                    double unitPriceAfterDiscount =
                                        double.parse(LabDatabase
                                            .materials[
                                                int.parse(job.materialId) - 1]
                                            .price);

                                    double discount = 0.0;
                                    if (doctor.discounts[
                                            int.parse(job.materialId)] !=
                                        null) {
                                      Discount unitDiscount = doctor
                                          .discounts[int.parse(job.materialId)];

                                      double unitPriceAfterDiscount =
                                          double.parse(LabDatabase
                                              .materials[
                                                  int.parse(job.materialId) - 1]
                                              .price);
                                      if (unitDiscount.type == '0') {
                                        // discount is fixed
                                        discount =
                                            double.parse(unitDiscount.discount);
                                      } else {
                                        discount = ((double.parse(
                                                    unitDiscount.discount) /
                                                100) *
                                            double.parse(LabDatabase
                                                .materials[
                                                    int.parse(job.materialId) -
                                                        1]
                                                .price));
                                      }
                                    }
                                    unitPriceAfterDiscount = unitPriceAfterDiscount - discount;
                                    print("unit price after discount calculating : $unitPriceAfterDiscount");
                                    double priceAfterDiscount =
                                        double.parse(numOfUnits) *
                                            unitPriceAfterDiscount;
                                    if (numOfUnits == '0') numOfUnits = '1';
                                    return SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                width: screenWidth / 4,
                                                child: Text(numOfUnits,
                                                    style: MyFontStyles
                                                        .valueFontStyle(
                                                            context)),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: screenWidth / 4,
                                                child: Text(
                                                  LabDatabase
                                                      .jobTypes[int.parse(
                                                              job.typeId) -
                                                          1]
                                                      .name,
                                                  style: MyFontStyles
                                                      .valueFontStyle(context),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: screenWidth / 3,
                                                child: Text(
                                                    LabDatabase
                                                        .materials[int.parse(job
                                                                .materialId) -
                                                            1]
                                                        .name,
                                                    style: MyFontStyles
                                                        .valueFontStyle(
                                                            context)),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: screenWidth / 5,
                                                child: Text(
                                                    priceAfterDiscount
                                                        .toString(),
                                                    style: MyFontStyles
                                                        .valueFontStyle(
                                                            context)),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 120.w,
                                  right: 120.w,
                                  child: FlatButton(
                                    color: Colors.black87,
                                    onPressed: () async {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FeedbackView(
                                                    caseId: widget.caseId,
                                                    patientName:
                                                        widget.patientName,
                                                    doctorId: doctor.id,
                                                  )));
                                    },
                                    shape: StadiumBorder(),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 50.0, vertical: 12.0),
                                      child: Text(
                                        "PROVIDE FEEDBACK",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 50.0.sp),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
