import 'dart:typed_data';
import 'package:flutter/material.dart' as mats hide Image;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:jiffy/jiffy.dart';
import 'package:mosaic_doctors/models/AccountStatementEntry.dart';
import 'package:mosaic_doctors/models/sessionData.dart';
import 'package:mosaic_doctors/shared/locator.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
export 'package:flutter/src/painting/image_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';

class Exporting {

  static createPdf(
      mats.BuildContext context,
      List<AccountStatementEntry> entries,
      Jiffy month,
      String totalDebit,
      String totalCredit) async {
    ByteData imageData1 = await rootBundle.load('assets/images/logo_black.png');
    final image = MemoryImage(imageData1.buffer.asUint8List());
    bool _isEvenRow = false;

    final pdf = Document();

    final formatter = new intl.NumberFormat("#,###");
    var arialFontData = await rootBundle.load("assets/fonts/arial.ttf");
    var arialBoldFontData =
        await rootBundle.load("assets/fonts/arial-bold.ttf");

    final Font arial = Font.ttf(arialFontData);
    final Font arialBold = Font.ttf(arialBoldFontData);
    double openingBalance = 0;
    pdf.addPage(MultiPage(
        pageFormat: PdfPageFormat.a4.copyWith(
            marginBottom: 1.5 * PdfPageFormat.cm,
            marginTop: 2 * PdfPageFormat.cm),
        crossAxisAlignment: CrossAxisAlignment.start,
        header: (Context context) {
          return SizedBox();
        },
        footer: (Context context) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                    child: Text(
                        'Page ${context.pageNumber} of ${context.pagesCount}',
                        style: Theme.of(context)
                            .defaultTextStyle
                            .copyWith(color: PdfColors.grey))),
                Container(
                    alignment: Alignment.centerRight,
                    margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                    child: Text(Jiffy().format('dd, MMMM, yyyy'),
                        style: Theme.of(context)
                            .defaultTextStyle
                            .copyWith(color: PdfColors.grey)))
              ]);
        },
        build: (Context context) => <Widget>[
              Center(
                  child: Text("STATEMENT OF ACCOUNT",
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold))),
              SizedBox(height: 1 * PdfPageFormat.cm),
              Header(
                  level: 0,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Month Covered : ${month.format('MMMM of yyyy')}',
                                  style: TextStyle(
                                    fontSize: 8,
                                  )),
                              SizedBox(height: 4),
                              Text('Currency : JOD',
                                  style: TextStyle(
                                    fontSize: 8,
                                  )),
                            ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                    'الطبيب/ العيادة:',
                                    style: TextStyle(font: arial, fontSize: 14),
                                  )),
                              SizedBox(height: 5),
                              Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                    '${getIt<SessionData>().doctor.name}',
                                    style: TextStyle(
                                        font: arialBold,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ]),
                      ])),
              Padding(padding: const EdgeInsets.all(10)),
              Table(
                  columnWidths: {
                    0: FlexColumnWidth(2.5),
                    1: FlexColumnWidth(4),
                    2: FlexColumnWidth(1.5),
                    3: FlexColumnWidth(1.5),
                    4: FlexColumnWidth(1.5),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.symmetric(outside: BorderSide(width: 1)),
                  children: [
                    TableRow(
                        decoration: BoxDecoration(
                            color: PdfColors.grey400, border: Border.all()),
                        children: [
                          Container(
                              padding: EdgeInsets.all(4),
                              child: Text("Date created",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Container(
                              padding: EdgeInsets.all(4),
                              child: Text("Patient/Transaction",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Container(
                              padding: EdgeInsets.all(4),
                              child: Text("Debit",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Container(
                              padding: EdgeInsets.all(4),
                              child: Text("Credit",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Container(
                              padding: EdgeInsets.all(4),
                              child: Text("Balance",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)))
                        ]),
                    ...entries.map((item) {
                      openingBalance = double.parse(entries
                          .where((element) =>
                              element.patientName == "رصيد مدور" ||
                              element.patientName == "رصيد افتتاحي")
                          .first
                          .balance);
                      _isEvenRow = !_isEvenRow;
                      return TableRow(
                          decoration: _isEvenRow
                              ? BoxDecoration(color: PdfColors.grey200)
                              : BoxDecoration(),
                          children: [
                            Container(
                                padding: item.patientName == "رصيد مدور"
                                    ? EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5)
                                    : EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 5),
                                child: Text(item.patientName == "رصيد مدور"
                                    ? ""
                                    : item.createdAt.substring(0, 10))),
                            Container(
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  item.patientName == "رصيد افتتاحي"
                                      ? "رصيد مدور"
                                      : item.patientName.contains("عكس")
                                          ? fixReversedStatement(
                                              item.patientName)
                                          : item.patientName,
                                  style: (item.patientName == "رصيد مدور" ||
                                          item.patientName == "رصيد افتتاحي")
                                      ? TextStyle(
                                          font: arialBold,
                                          fontWeight: FontWeight.bold)
                                      : TextStyle(font: arial),
                                ),
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 5),
                                child: Text(item.debit == "N/A"
                                    ? ""
                                    : formatter
                                        .format(double.parse(item.debit)))),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 5),
                                child: Text(item.credit == "N/A"
                                    ? ""
                                    : formatter
                                        .format(double.parse(item.credit)))),
                            Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 5),
                                child: Text(
                                    formatter
                                        .format(double.parse(item.balance)),
                                    style: (item.patientName == "رصيد مدور" ||
                                            item.patientName == "رصيد افتتاحي")
                                        ? TextStyle(fontWeight: FontWeight.bold)
                                        : TextStyle()))
                          ]);
                    }).toList(),
                    TableRow(
                        decoration: BoxDecoration(
                            color: PdfColors.grey400, border: Border.all()),
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: Text("")),
                          Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text("Totals:",
                                  style: TextStyle(
                                      font: arialBold,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              child: Text(
                                  formatter.format(double.parse(totalDebit)))),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              child: Text(
                                  formatter.format(double.parse(totalCredit)))),
                          Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              child: Text(formatter.format(
                                  double.parse(totalDebit) +
                                      openingBalance -
                                      double.parse(totalCredit))))
                        ])
                  ]),
            ]));

    return pdf;
  }


  static createPdfTest(mats.BuildContext context,
      List<AccountStatementEntry> entries,
      Jiffy month,
      String totalDebit,
      String totalCredit){
    final pdf = Document();

    pdf.addPage(Page(
        pageFormat: PdfPageFormat.a4,
        build: (Context context) {
          return Center(
            child: Text("Hello World"),
          ); // Center
        })); // Page

  }
  static fixReversedStatement(String text) {
    String fixedText = text
        .replaceAll(')', "")
        .replaceAll('(', "")
        .replaceAll("عكس حركة", "")
        .replaceAll("عكس حساب", "");
    return fixedText + ")عكس حركة(";
  }

  static saveAsPDF(context, List<AccountStatementEntry> entries, Jiffy month,
      String totalDebit, String totalCredit) async {
    final pdf =
        await createPdf(context, entries, month, totalDebit, totalCredit);
    Directory tempDir;

    if (Platform.isIOS) {
      await Permission.storage.request();
      tempDir = await getApplicationDocumentsDirectory();
    } else tempDir = await getExternalStorageDirectory();

    File file = File("${tempDir.path}/MOSAIC.pdf");
    print("file created");
    await file.writeAsBytes(await pdf.save(), flush: true);
    print("opening ${file.path}");
    OpenFile.open(file.path);
    print("opened");
  }

  static printLabPDF(context, List<AccountStatementEntry> entries, Jiffy month,
      String totalDebit, String totalCredit) async {
    final pdf =
        await createPdf(context, entries, month, totalDebit, totalCredit);
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
