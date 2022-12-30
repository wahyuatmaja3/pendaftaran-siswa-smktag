import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:open_file/open_file.dart';
import 'package:pendaftaran_siswa_smktag/api/pdf_api.dart';
import 'package:pendaftaran_siswa_smktag/pages/formDaftar_page.dart';
import 'package:pdf/pdf.dart';

class DataDaftar extends StatefulWidget {
  const DataDaftar({super.key});

  @override
  State<DataDaftar> createState() => _DataDaftarState();
}

class _DataDaftarState extends State<DataDaftar> {
  final user = FirebaseAuth.instance.currentUser!;

  String nama = '';
  String jenisKelamin = '';
  String nisn = '';
  String nik = '';
  String tempatTglLahir = '';
  String alamat = '';
  String agama = '';
  String urlFoto = '';
  String urlKk = '';
  String urlIjazah = '';
  String urlSkhu = '';
  String email = '';

  Future _getData() async {
    await FirebaseFirestore.instance
        .collection("siswa")
        .doc(user.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        setState(() {
          nama = snapshot.data()!['nama'];
          jenisKelamin = snapshot.data()!['jenis kelamin'];
          nisn = snapshot.data()!['nisn'];
          nik = snapshot.data()!['nik'];
          tempatTglLahir = snapshot.data()!['tempatTglLahir'];
          alamat = snapshot.data()!['alamat'];
          agama = snapshot.data()!['agama'];
          urlFoto = snapshot.data()!['urlFoto'];
          urlKk = snapshot.data()!['urlKk'];
          urlIjazah = snapshot.data()!['urlIjazah'];
          urlSkhu = snapshot.data()!['urlSkhu'];
          email = snapshot.data()!['email'];
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getData();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Padding(
    //     padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(
    //           "Anda sudah mendaftar",
    //           style: TextStyle(fontSize: 20),
    //         ),
    //         Container(
    //           padding: EdgeInsets.only(top: 20),
    //           height: 500,
    //           child: Column(
    //             children: [_dataField("Nama", nama)],
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );

    final height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('siswa')
              .doc(user.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return new Text("Loading");
            }
            var dataSiswa = snapshot.data;
            // return new Text(dataSiswa!["nama"]);
            return Container(
                child: SingleChildScrollView(
                    child: Padding(
              padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Anda sudah mendaftar",
                    style: TextStyle(fontSize: 28),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  _dataField("email", dataSiswa!["email"]),
                  SizedBox(
                    height: 12,
                  ),
                  _dataField("nama", dataSiswa["nama"]),
                  SizedBox(
                    height: 12,
                  ),
                  _dataField("jenis kelamin", dataSiswa["jenis kelamin"]),
                  SizedBox(
                    height: 12,
                  ),
                  _dataField("nisn", dataSiswa["nisn"]),
                  SizedBox(
                    height: 12,
                  ),
                  _dataField("nik", dataSiswa["nik"]),
                  SizedBox(
                    height: 12,
                  ),
                  _dataField(
                      "tempat, tanggal lahir", dataSiswa["tempatTglLahir"]),
                  SizedBox(
                    height: 12,
                  ),
                  _dataField("alamat", dataSiswa["alamat"]),
                  SizedBox(
                    height: 12,
                  ),
                  _dataField("agama", dataSiswa["agama"]),
                  SizedBox(
                    height: 15,
                  ),
                  _filePreview("Foto siswa", dataSiswa["foto"]),
                  SizedBox(
                    height: 12,
                  ),
                  _filePreview("Kartu keluarga", dataSiswa["kk"]),
                  SizedBox(
                    height: 12,
                  ),
                  _filePreview("Foto Ijazah", dataSiswa["ijazah"]),
                  SizedBox(
                    height: 12,
                  ),
                  _filePreview("SKHU", dataSiswa["skhu"]),
                  SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(color: Colors.black, width: 2),
                          borderRadius: BorderRadius.circular(20)),
                      width: double.infinity,
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Edit",
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new FormDaftar()),
                      );
                    },
                  )
                  // ),
                  // SizedBox(
                  //   height: 60,
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           backgroundColor: Colors.black),
                  //       onPressed: () {
                  //         Navigator.push(
                  //           context,
                  //           new MaterialPageRoute(
                  //               builder: (context) => new FormDaftar()),
                  //         );
                  //       },
                  //       child: Text("Edit")),
                  // ),
                  // SizedBox(
                  //   height: 15,
                  // ),
                  // SizedBox(
                  //     width: double.infinity,
                  //     height: 60,
                  //     child: ElevatedButton.icon(
                  //         style: ElevatedButton.styleFrom(
                  //             backgroundColor: Colors.amber,
                  //             foregroundColor: Colors.black),
                  //         onPressed: () async {
                  //           var mapSis = {
                  //             "nama": dataSiswa['nama'],
                  //             "jenisKelamin": dataSiswa['jenisKelamin'],
                  //             "nisn": dataSiswa['nisn'],
                  //             "nik": dataSiswa['nik'],
                  //             "tempatTglLahir": dataSiswa['tempatTglLahir'],
                  //             "alamat": dataSiswa['alamat'],
                  //             "agama": dataSiswa['agama'],
                  //             "urlFoto": dataSiswa['urlFoto'],
                  //             "urlKk": dataSiswa['urlKk'],
                  //             "urlIjazah": dataSiswa['urlIjazah'],
                  //             "urlSkhu": dataSiswa['urlSkhu'],
                  //             "email": dataSiswa['email'],
                  //           };
                  //           final pdfFile =
                  //               await PdfApi.generate("Coba bikin pdf", mapSis);
                  //           PdfApi.openFile(pdfFile);
                  //         },
                  //         icon: Icon(Icons.print_outlined),
                  //         label: Text("Cetak bukti")))
                ],
              ),
            )));
          }),
    );
  }

  Widget _dataField(String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              Expanded(
                  child: Text(
                data,
                style: TextStyle(fontSize: 16),
              ))
            ],
          ),
        )
      ],
    );
  }

  Widget _filePreview(String title, String url) {
    var fileName = url.split('/').last;
    fileName = fileName.split('?').first;
    fileName = fileName.replaceAll("%2F", " ");
    fileName = fileName.replaceAll(
        RegExp(r"Kartu%20Keluarga |Foto |Skhu |Ijazah "), "");
    final ext = fileName.split('.').last;

    final isImage = ext == "jpg" || ext == "jpeg" || ext == "png";

    print(fileName);
    print(ext);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
        Container(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8)),
            child: isImage
                ? Image.network(url)
                : GestureDetector(
                    onTap: () => openFile(url: url, fileName: fileName),
                    child: Container(
                        height: 80,
                        child: Row(
                          children: [
                            Flexible(child: Text(fileName)),
                            Expanded(
                              child: Icon(
                                Icons.folder_rounded,
                                color: Colors.blue,
                                size: 60,
                              ),
                            )
                          ],
                        )),
                  ))
      ],
    );
  }

  Future openFile({required String url, String? fileName}) async {
    final file = await downloadFile(url, fileName!);
    if (file == null) return;

    print("path: ${file.path}");
    OpenFile.open(file.path);
  }

  // Lanjut video https://www.youtube.com/watch?v=6tfBflFUO7s
  // Menit 1:36

  // Download file into private folder not visible to user
  Future<File?> downloadFile(String url, String name) async {
    try {
      final appStorage = await getApplicationDocumentsDirectory();
      final file = File('${appStorage.path}/$name');

      final response = await Dio().get(url,
          options: Options(
              responseType: ResponseType.bytes,
              followRedirects: false,
              receiveTimeout: 0));

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();

      return file;
    } catch (e) {
      return null;
    }
  }
}
