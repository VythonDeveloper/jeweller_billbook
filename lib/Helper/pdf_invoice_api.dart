import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:intl/intl.dart';
import 'package:number_to_words/number_to_words.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static var dateFormat = new DateFormat('MMMM d, yyyy HH:mm');
  static var dataMap;
  static Future<File> generate(
      {required String action, required Map<String, dynamic> dataMap}) async {
    // final ByteData companyLogoBytes =
    //     await rootBundle.load('./lib/assets/images/icon.png');
    // final Uint8List companyLogo = companyLogoBytes.buffer.asUint8List();

    // final ByteData authSignBytes =
    //     await rootBundle.load('./lib/assets/images/authsign.png');
    // final Uint8List authSign = authSignBytes.buffer.asUint8List();

    PdfInvoiceApi.dataMap = dataMap;
    final pdf = Document();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      build: (context) => [
        Text(
          'text',
        ),
      ],
      // footer: (context) => buildFooter(),
    ));

    return action == "View"
        ? saveDocumentForView(
            name: 'Invoice_' +
                DateTime.now().millisecondsSinceEpoch.toString() +
                '.pdf',
            pdf: pdf)
        : saveDocumentForShare(
            name: 'Invoice_' +
                DateTime.now().millisecondsSinceEpoch.toString() +
                '.pdf',
            pdf: pdf);
  }

  static Future<File> saveDocumentForView(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<File> saveDocumentForShare(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();
    final dir = await getExternalStorageDirectory();
    final file = File('${dir!.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  static Future<void> openFile(File file) async {
    print(file.path);
    final url = file.path;
    await OpenFile.open(url);
  }

  static Future<void> shareFile(File file) async {
    final url = file.path;
    if (url.isNotEmpty) {
      await FlutterShare.shareFile(
        title: 'Share',
        text: 'Sharing from StockBook',
        chooserTitle: 'Chooser title',
        filePath: url,
      );
    }
  }

  static Widget buildHeader(companyLogo) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================  Header  =======================
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            children: [
              Image(
                MemoryImage(
                  companyLogo,
                ),
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 3 * PdfPageFormat.mm),
              Text(
                'Book Your Own',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          Text(
            'Aesby More, Station Road, Durgapur - 713201, West Bengal, India',
            style: TextStyle(fontSize: 10),
          ),
          Row(
            children: [
              Text(
                '+91 8653 8269 02',
                style: TextStyle(fontSize: 10),
              ),
              // SizedBox(width: 0.3 * PdfPageFormat.cm),
              Spacer(),
              Text(
                "GSTIN: 19AD38B53EF326EF",
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(),
        ],
      );

  static Widget buildInvoiceDetails() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table.fromTextArray(
            headers: [
              'Invoice Id: ' + dataMap['id'].toString(),
              'Invoice Date: ' +
                  dateFormat.format(
                      DateTime.fromMillisecondsSinceEpoch(dataMap['bookedOn'])),
            ],
            data: [],
            border: null,
            headerStyle: TextStyle(fontWeight: FontWeight.bold),
            headerDecoration: BoxDecoration(color: PdfColors.grey300),
            cellHeight: 30,
            cellAlignments: {
              0: Alignment.centerLeft,
              1: Alignment.centerRight,
            },
          ),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          buildText(title: "Bill To", value: ""),
          SizedBox(height: 0.3 * PdfPageFormat.cm),
          Text(dataMap['customerName'],
              style: TextStyle(fontWeight: FontWeight.bold)),
          Text(dataMap['customerMobile']),
          Divider()
        ],
      );

  static Widget buildInvoiceMatter() => Column(children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: PdfColor.fromHex('#0D47A1'),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SvgPicture.asset(
                        //   'lib/assets/icons/homeMarker.svg',
                        //   color: Colors.white,
                        //   height: 15,
                        // ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Source',
                          style: TextStyle(
                            fontSize: 15,
                            color: PdfColor.fromHex('#ffffff'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    dataMap['pickAddress'],
                    style: TextStyle(
                      color: PdfColor.fromHex('#050505'),
                    ),
                  ),
                ],
              ),
            ),
            //  Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 20),
            //   child: Icon(
            //     Icons.arrow_forward_ios_rounded,
            //   ),
            // ),
            SizedBox(width: 50),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: PdfColor.fromHex('#D32F2F'),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SvgPicture.asset(
                        //   'lib/assets/icons/destination.svg',
                        //   color: Colors.white,
                        //   height: 15,
                        // ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Destination',
                          style: TextStyle(
                            fontSize: 15,
                            color: PdfColor.fromHex('#ffffff'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    dataMap['dropAddress'],
                    style: TextStyle(
                      color: PdfColor.fromHex('#050505'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  color: PdfColor.fromHex('#90CAF9'),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.map,
                    //   color: Colors.blue.shade900,
                    // ),
                    Text(
                      'Distance',
                      style: TextStyle(
                        fontSize: 17,
                        color: PdfColor.fromHex('#0D47A1'),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      dataMap['distance'],
                      style: TextStyle(
                        fontSize: 15,
                        color: PdfColor.fromHex('#0D47A1'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  color: PdfColor.fromHex('#FFE082'),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.watch_later_outlined,
                    //   color: Colors.amber.shade900,
                    // ),
                    Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 17,
                        color: PdfColor.fromHex('#FF6F00'),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      dataMap['transitTime'],
                      style: TextStyle(
                        fontSize: 15,
                        color: PdfColor.fromHex('#FF6F00'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                  color: PdfColor.fromHex('#A5D6A7'),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icon(
                    //   Icons.attach_money_rounded,
                    //   color: Colors.green.shade900,
                    // ),
                    Text(
                      'Cost',
                      style: TextStyle(
                        fontSize: 17,
                        color: PdfColor.fromHex('#1B5E20'),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Rs. ',
                      style: TextStyle(
                        fontSize: 15,
                        color: PdfColor.fromHex('#1B5E20'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 15,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Driver: ',
                style: TextStyle(
                  color: PdfColor.fromHex('#808080'),
                  fontSize: 15,
                ),
              ),
              TextSpan(
                text: dataMap['driverName'],
                style: TextStyle(
                  color: PdfColor.fromHex('#808080'),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Vehicle: ',
                style: TextStyle(
                  color: PdfColor.fromHex('#808080'),
                  fontSize: 15,
                ),
              ),
              TextSpan(
                text: dataMap['vehicleType'] +
                    ', ' +
                    dataMap['vehicleName'] +
                    ', ' +
                    dataMap['vehicleNumber'],
                style: TextStyle(
                  color: PdfColor.fromHex('#808080'),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        Divider(),
        buildTotal(),
        Divider(),
      ]);

  static Widget buildTotal() {
    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 5),
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Net total',
                  value: 'Rs. ',
                  unite: true,
                ),
                Text(
                  '(Includes GST)',
                  style: TextStyle(
                    fontSize: 10,
                    color: PdfColor.fromHex('#808080'),
                  ),
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Divider(),
                Text("Fully Paid",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 3 * PdfPageFormat.mm),
                Text("Invoice Amount (in words)",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  NumberToWord()
                          .convert(
                            'en-in',
                            dataMap['cost'],
                          )
                          .toUpperCase() +
                      "RUPEES",
                ),
                SizedBox(height: 3 * PdfPageFormat.cm),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildOtherInfo(authSign) => Column(children: [
        // Terms and Conditions and Barcode and Signature
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Container(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text("Invoice QR Code"),
            //       SizedBox(height: 0.3 * PdfPageFormat.cm),
            //       Container(
            //         height: 50,
            //         width: 50,
            //         child: BarcodeWidget(
            //           barcode: Barcode.qrCode(),
            //           data: "https://aryagold.co.in/orderInvoice?orderId=" +
            //               dataMap['id'],
            //         ),
            //       ),
            //       SizedBox(height: 0.3 * PdfPageFormat.cm),
            //       Text(
            //         "TERMS & CONDITIONS:",
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //       Text(
            //         "1. Goods once sold will not be taken back or exchanged",
            //         style: TextStyle(fontSize: 10),
            //       ),
            //       Text(
            //         "2. All disputes are subject to [Durgapur] jurisdiction only",
            //         style: TextStyle(fontSize: 10),
            //       )
            //     ],
            //   ),
            // ),
            SizedBox(width: 20),
            Container(
              child: Column(
                children: [
                  Image(
                    MemoryImage(
                      authSign,
                    ),
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: 3 * PdfPageFormat.mm),
                  Text("AUTHORISED SIGNATORY FOR\nBook Your Own"),
                ],
              ),
            )
          ],
        ),
      ]);

  // static Widget buildFooter() => Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Divider(),
  //         SizedBox(height: 2 * PdfPageFormat.mm),
  //         buildSimpleText(
  //             title: 'Visit our website', value: "https://aryagold.co.in"),
  //       ],
  //     );

  static buildSimpleText({required String title, required String value}) {
    final style = TextStyle(fontWeight: FontWeight.bold);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText(
      {required String title,
      required String value,
      double width = double.infinity,
      TextStyle? titleStyle,
      bool unite = false}) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
