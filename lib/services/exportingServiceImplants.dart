import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart' as mats hide Image;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:jiffy/jiffy.dart';
import 'package:mosaic_doctors/models/implantStatementRowModel.dart';
import 'package:mosaic_doctors/models/nbDoctor.dart';
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

class ExportingServiceImplants{
  static saveIASAsPDF(context,  List<ImplantStatementRowModel> entries, NbDoctor nbDoctor) async {
    final pdf =
    await createImplantsPdf(context, entries, nbDoctor);
    Directory? tempDir;

    if (Platform.isIOS) {
      await Permission.storage.request();
      tempDir = await getApplicationDocumentsDirectory();
    } else
      tempDir = await getExternalStorageDirectory();

    File file = File("${tempDir!.path}/MOSAIC.pdf");
    print("file created");
    await file.writeAsBytes(await pdf.save(), flush: true);
    print("opening ${file.path}");
    OpenFile.open(file.path);
    print("opened");
  }
  static createImplantsPdf(mats.BuildContext context,
      List<ImplantStatementRowModel> entries, NbDoctor nbDoctor) async {
    ByteData imageData1 = await rootBundle.load('assets/images/logo_black.png');
    final image = MemoryImage(imageData1.buffer.asUint8List());
    bool _isEvenRow = false;

    final pdf = pw.Document();

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
              child: Text("IMPLANTS STATEMENT OF ACCOUNT",
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
                              'Offer Period : ${getIt<SessionData>().implantsFirstOrderDate!.substring(0, 10)} - ${(int.parse(getIt<SessionData>().implantsFirstOrderDate!.substring(0, 4)) + 1).toString() + getIt<SessionData>().implantsFirstOrderDate!.substring(4, 10)}',
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
                                '${getIt<SessionData>().doctor!.name}',
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
                1: FlexColumnWidth(3.5),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1.5),
                5: FlexColumnWidth(1.5),
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
                          child: Text("Date",
                              style:
                              TextStyle(fontWeight: FontWeight.bold))),
                      Container(
                          padding: EdgeInsets.all(4),
                          child: Text("Implant",
                              style:
                              TextStyle(fontWeight: FontWeight.bold))),
                      Container(
                          padding: EdgeInsets.all(4),
                          child: Text("Trans.",
                              style:
                              TextStyle(fontWeight: FontWeight.bold))),
                      Container(
                          padding: EdgeInsets.all(4),
                          child: Text("Qty",
                              style:
                              TextStyle(fontWeight: FontWeight.bold))),
                      Container(
                          padding: EdgeInsets.all(4),
                          child: Text("Price",
                              style:
                              TextStyle(fontWeight: FontWeight.bold))),
                      Container(
                          padding: EdgeInsets.all(4),
                          child: Text("Total",
                              style:
                              TextStyle(fontWeight: FontWeight.bold))),
                      Container(
                          padding: EdgeInsets.all(4),
                          child: Text("Balance",
                              style:
                              TextStyle(fontWeight: FontWeight.bold)))
                    ]),
                ...entries.map((item) {
                  _isEvenRow = !_isEvenRow;
                  String minusIfReturn =
                  (item.type == 'Failure' || item.type == 'Exchange')
                      ? '-'
                      : '';
                  return TableRow(
                      decoration: _isEvenRow
                          ? BoxDecoration(color: PdfColors.grey200)
                          : BoxDecoration(),
                      children: [
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: Text(item.createdAt!.substring(0, 10))),
                        Container(
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: Column(

                                children: [
                                  RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text: '',
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: item.entry,
                                            style: TextStyle(
                                                font: arialBold,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  item.identifier != "N/A"
                                      ? RichText(
                                    textDirection: TextDirection.rtl,
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      text: '',
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: item.identifier,
                                            style: TextStyle(
                                                font: arialBold,
                                                fontWeight:
                                                FontWeight.bold)),
                                      ],
                                    ),
                                  )
                                      : SizedBox()
                                ])),
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child:
                            Text(item.type == "N/A" ? "" : item.type!)),
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: Text(item.qty == "N/A" ? "" : item.qty!)),
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: Text(item.qty == "-" ? "-" : minusIfReturn + item.unitPrice!)),
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: Text(item.amount!)),
                        Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 3, horizontal: 5),
                            child: Text(item.balance!,
                                style:
                                TextStyle(fontWeight: FontWeight.bold)))
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
                          child: Text('')),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 3, horizontal: 5),
                          child: Text('')),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 3, horizontal: 5),
                          child: Text('')),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 3, horizontal: 5),
                          child: Text('')),
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 3, horizontal: 5),
                          child: Text(nbDoctor.balance! + ' JOD',
                              style: TextStyle(
                                  font: arialBold,
                                  fontWeight: FontWeight.bold)))
                    ])
              ]),
        ]));

    return pdf;
  }

  static printImplantsPDF(context, List<ImplantStatementRowModel> entries,
      NbDoctor nbDoctor) async {
    final pdf = await createImplantsPdf(context, entries, nbDoctor);
    await Printing.layoutPdf(
        onLayout: ((PdfPageFormat format) async => pdf.save()) );
  }


}