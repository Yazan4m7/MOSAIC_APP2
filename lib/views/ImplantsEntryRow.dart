// Create the Widget for the row
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:mosaic_doctors/models/implantStatementRowModel.dart';
import 'package:mosaic_doctors/services/implantsDatabase.dart';
import 'package:mosaic_doctors/shared/Constants.dart';
import 'package:mosaic_doctors/shared/customDialogBox.dart';
import 'package:mosaic_doctors/shared/font_styles.dart';
import 'package:mosaic_doctors/shared/responsive_helper.dart';
import 'package:mosaic_doctors/shared/widgets.dart';

class ImplantsEntryRow extends StatefulWidget {
  ImplantsEntryRow(this.entry);
  final dynamic entry;
  @override
  _ImplantsEntryRowState createState() => _ImplantsEntryRowState();
}

class _ImplantsEntryRowState extends State<ImplantsEntryRow> {
  static bool isEven = false;
  Widget _buildTiles(ImplantStatementRowModel root) {
    double rowWidth = MediaQuery.of(context).size.width;
    isEven = !isEven;
    print("Entry : ${root.entry}");
    String implantName = root.entry!.split(' ')[0];
    String implantSize = root.entry!.split(' ')[1];
    String identifier =
        root.identifier == 'N/A' ? '' : '                 ' + root.identifier!;
    String minusIfReturn =
        (root.type == 'Failure' || root.type == 'Exchange') ? '-' : '';
    return InkWell(
      child: Container(
        padding: EdgeInsets.only(top: 0),
        decoration: BoxDecoration(
            color: isEven ? Colors.grey.shade200 : Colors.transparent),
        child: Row(
          children: [
            Container(
              // height: 15,
              margin: EdgeInsets.only(top: 9, bottom: 9),
              width: rowWidth / implantsDateCellWidthFactor,
              child: SharedWidgets.TextWidget(
                  text: root.createdAt!.length > 10
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
                  style: MyFontStyles.statementEntryFontStyle(context),
                  maxChars: 10),
            ),
            Container(
                padding: EdgeInsets.only(right: 0),
                width: rowWidth / implantsEntryCellWidthFactor,
                child: RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(
                    text: '',
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                          text: root.qty != '-' ? implantName : root.entry,
                          style: root.qty != '-'
                              ? MyFontStyles.statementEntryFontStyle(context)
                              : MyFontStyles.statementEntryFontStyle(context)
                                  .copyWith(fontSize: 34.sp)),
                      TextSpan(
                          text: root.qty != '-'
                              ? ' ' + implantSize + identifier
                              : '',
                          style: MyFontStyles.statementEntryFontStyle(context)
                              .copyWith(
                                  height: 1.3,
                                  fontSize:
                                      Responsiveness.entryFontSize!.sp - 5.sp)),
                    ],
                  ),
                )),
            Container(
              padding: EdgeInsets.all(0),
              width: rowWidth / implantsTypeCellWidthFactor,
              child: Text(
                  root.type != 'Payment'
                      ? ImplantsDatabase
                          .nbTransTypes[int.parse(root.type!)]!.type!
                      : root.type!,
                  style: MyFontStyles.statementEntryFontStyle(context)
                      .copyWith(fontSize: 33.sp),
                  textAlign: TextAlign.left),
            ),
            Container(
              padding: EdgeInsets.only(left: 0, right: 0),
              width: rowWidth / implantsQtyCellWidthFactor,
              child: Text(' ' + root.qty!,
                  style:
                      MyFontStyles.statementEntryFontStyle(context).copyWith(),
                  textAlign: TextAlign.left),
            ),
            Container(
              padding: EdgeInsets.only(left: 3, right: 0),
              width: rowWidth / implantsPriceCellWidthFactor,
              child: Text(
                  root.qty == "-"
                      ? "-"
                      : (ImplantsDatabase.nbTransTypes[int.parse(root.type!)]!
                                  .factor! *
                              int.parse(root.unitPrice!))
                          .toString(),
                  style:
                      MyFontStyles.statementEntryFontStyle(context).copyWith(),
                  textAlign: TextAlign.left),
            ),
            Container(
              padding: EdgeInsets.only(left: 1),
              width: rowWidth / implantsAmountCellWidthFactor,
              child: Text(root.amount!,
                  style: MyFontStyles.statementEntryFontStyle(context),
                  textAlign: TextAlign.left),
            ),
            Container(
              padding: EdgeInsets.all(1),
              width: rowWidth / implantsBalanceCellWidthFactor,
              child: Text(double.parse(root.balance!).toStringAsFixed(3),
                  style: MyFontStyles.statementEntryFontStyle(context),
                  textAlign: TextAlign.left),
            )
          ],
        ),
      ),
      onTap: () {},
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
