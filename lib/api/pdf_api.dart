import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:flutter/material.dart' as flu;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:pendaftaran_siswa_smktag/widgets/logo_widget.dart';

class PdfApi {
  // static Future<File> generateCenteredText(String text) async {
  //   final pdf = Document();

  //   pdf.addPage(MultiPage(build: (context) => <Widget>[]));
  //   return saveDocument(
  //       name: 'Bukti pembayaran ppdb SMK 17 AGUSTUS 1945 SURABAYA', pdf: pdf);
  // }

  static Future<File> generate(String text, Map<String, dynamic>? data) async {
    final pdf = Document();
    final logo =
        (await rootBundle.load('assets/img/logo.png')).buffer.asUint8List();

    pdf.addPage(MultiPage(
        build: (context) => <Widget>[
              Row(children: [Text("Nama"), Text(data!['nama'])]),
              buildCustomHeadline(logo)
            ]));
    return saveDocument(name: 'Contoh', pdf: pdf);
  }

  static Future<File> saveDocument(
      {required String name, required Document pdf}) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static Widget _buildField() {
    return Container();
  }

  static Widget buildCustomHeadline(Uint8List logo) => Container(
      padding: EdgeInsets.only(bottom: .5 * PdfPageFormat.cm),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 2, color: PdfColors.black))),
      child: Row(children: [
        Image(MemoryImage(logo), width: 2.4 * PdfPageFormat.cm),
        SizedBox(width: .8 * PdfPageFormat.cm),
        Flexible(
            child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(color: PdfColors.black, fontSize: 36),
            children: <TextSpan>[
              TextSpan(
                  text: 'Bukti Pendaftaran Peserta Didik Baru ',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              TextSpan(
                  text: 'SMK 17 AGUSTUS 1945 SURABAYA',
                  style: TextStyle(fontSize: 18))
            ],
          ),
        ))
      ]));
}
