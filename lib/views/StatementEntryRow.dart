import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mosaic_doctors/models/AccountStatementEntry.dart';
import 'package:mosaic_doctors/models/previousMonthBalance.dart';
import 'package:mosaic_doctors/shared/Constants.dart';
import 'package:mosaic_doctors/shared/customDialogBox.dart';
import 'package:mosaic_doctors/shared/font_styles.dart';
import 'package:mosaic_doctors/shared/responsive_helper.dart';
import 'package:mosaic_doctors/views/caseDetailsView.dart';

class LabEntryRow extends StatefulWidget {
  LabEntryRow(this.entry);
  final dynamic entry;

  @override
  _LabEntryRowState createState() => _LabEntryRowState();
}

class _LabEntryRowState extends State<LabEntryRow> {
  static bool isEven = false;
  Widget _buildTiles(AccountStatementEntry root) {
    double rowWidth = MediaQuery.of(context).size.width;
    isEven = !isEven;

    return InkWell(
      child: Container(
        padding: EdgeInsets.only(left: 0),
        decoration: BoxDecoration(
            color: isEven ? Colors.grey.shade200 : Colors.transparent),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(left: 3),
              width: rowWidth / labDateCellWidthFactor,
              child: Text(
                  root is PreviousMonthBalance
                      ? ""
                      : root.createdAt!.length > 10
                          ? root.createdAt!.substring(8, 10) +
                              '-' +
                              Jiffy([
                                0000,
                                int.parse(root.createdAt!.substring(5, 7)) + 1,
                                00
                              ]).format("MM") +
                              "-" +
                              root.createdAt!.substring(2, 4)
                          : root.createdAt!,
                  style: MyFontStyles.statementEntryFontStyle(context)),
            ),
            Container(
              padding: EdgeInsets.only(right: labPatientNameRightPadding),
              width: rowWidth / labEntryCellWidthFactor,
              child: Text(
                root.patientName!,
                style: root.patientName == "Payment"
                    ? MyFontStyles.statementPatientNameFontStyle(context)
                        .copyWith(
                            fontSize:
                                Responsiveness.patientNameFontSize!.sp + 2)
                    : MyFontStyles.statementPatientNameFontStyle(context),
                textAlign: TextAlign.right,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: labCellsLeftPadding),
              width: rowWidth / labCreditCellWidthFactor,
              child: Text(root.credit == "N/A" ? "" : root.credit!,
                  style: MyFontStyles.statementEntryFontStyle(context)
                      .copyWith(color: Colors.green),
                  textAlign: TextAlign.left),
            ),
            Container(
              padding: EdgeInsets.only(left: labCellsLeftPadding),
              width: rowWidth / labDebitCellWidthFactor,
              child: Text(root.debit == "N/A" ? "" : root.debit!,
                  style: MyFontStyles.statementEntryFontStyle(context),
                  textAlign: TextAlign.left),
            ),
            Container(
              padding: EdgeInsets.only(left: labCellsLeftPadding),
              width: rowWidth / labBalanceCellWidthFactor,
              child: Text(double.parse(root.balance!).toStringAsFixed(2),
                  style: MyFontStyles.statementEntryFontStyle(context),
                  textAlign: TextAlign.left),
            )
          ],
        ),
      ),
      onTap: () {
        if (root.debit != "N/A") // its a case
        {
          print("root date : ${Jiffy(root.createdAt).format("yyyy-MM-dd")} ");
          if (root.patientName!.contains("عكس ح") &&
              Jiffy(root.createdAt).isBefore(Jiffy([2021, 01, 09]))) {
            showMOSAICDialog("Case details unavailable.");
            return;
          }
          if (root.caseId == "N/A") {
            showMOSAICDialog("Case information currently unavailable.");
            return;
          }
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CaseDetailsView(
                  caseId: root.caseId.toString(),
                  patientName: root.patientName ?? "N/A",
                  deliveryDate: root.createdAt ?? "N/A")));
        } else // its a payment
        {
          return;
        }
      },
    );
  }

  showMOSAICDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(
            title: "Alert",
            descriptions: text,
            text: "Ok",
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(widget.entry);
  }
}
