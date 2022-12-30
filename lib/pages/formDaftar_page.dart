import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pendaftaran_siswa_smktag/pages/home_page.dart';
import 'package:pendaftaran_siswa_smktag/pages/isDaftar_page.dart';
import 'package:pendaftaran_siswa_smktag/widgets/inputStyle.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'package:path/path.dart' as Path;
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FormDaftar extends StatefulWidget {
  const FormDaftar({super.key});

  @override
  State<FormDaftar> createState() => _FormDaftarState();
}

class _FormDaftarState extends State<FormDaftar> {
  final user = FirebaseAuth.instance.currentUser!;
  bool isCompleted = false;
  PlatformFile? fotoSiswa;
  PlatformFile? kk;
  PlatformFile? ijazah;
  PlatformFile? skhu;
  final formKey = GlobalKey<FormState>();

  UploadTask? task;

  bool fotoIsvalid = true;
  bool kkIsvalid = true;
  bool ijazahIsvalid = true;
  bool skhuIsvalid = true;

  late String? _email = user.email!;
  String _jenisKelamin = "Laki-laki";
  String _agama = "Islam";
  String _jurusan = "Rekayasa Perangkat Lunak";
  String kkName = "";
  String ijazahName = "";
  String skhuName = "";
  String urlFoto = '';
  String urlKk = '';
  String urlIjazah = '';
  String urlSkhu = '';
  final _emailController = TextEditingController();
  final _namaLengkapController = TextEditingController();
  final _nisnController = TextEditingController();
  final _nikController = TextEditingController();
  final _tempatLahirController = TextEditingController();
  final _tglLahirController = TextEditingController(text: '');
  final _alamatController = TextEditingController();

  void dispose() {
    _namaLengkapController.dispose();
    super.dispose();
  }

  List<Step> steps() => [
        Step(
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            isActive: _currentStep >= 0,
            title: Text('Data Siswa'),
            content: Form(key: formKey, child: _dataSiswa())),
        Step(
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: _currentStep >= 1,
            title: Text('Dokumen'),
            content: _dokumen()),
        Step(
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: _currentStep >= 2,
            title: Text('Selesai'),
            content: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Data anda akan tersimpan dengan email :"),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border(
                            bottom: BorderSide(width: 2, color: Colors.amber))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _email!,
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      ];

  int _currentStep = 0;

  Future openFile(PlatformFile? file) async {
    final openfile = await File(file!.path!);
    OpenFile.open(openfile.path);
  }

  Future selectImage() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: false, type: FileType.image);

    if (result == null) return;

    // final path = result.files.single.path!;

    setState(() {
      fotoSiswa = result.files.first;
    });
    setState(() => fotoIsvalid = true);
    print(fotoSiswa!.extension);

    // setState(() => file = File(path));
  }

  Future uploadFile(PlatformFile? Upfile, String dir, String urlName) async {
    final path = '${dir}/${Upfile!.name}';
    final file = File(Upfile.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    task = ref.putFile(file);

    final snapshot = await task!.whenComplete(() {});
    // String urlDownload = await snapshot.ref.getDownloadURL();
    final urlDownload = await snapshot.ref.getDownloadURL();

    switch (dir) {
      case 'Foto':
        setState(() {
          urlFoto = urlDownload;
        });
        break;
      case 'Kartu Keluarga':
        setState(() {
          urlKk = urlDownload;
        });
        break;
      case 'Ijazah':
        setState(() {
          urlIjazah = urlDownload;
        });
        break;
      case 'Skhu':
        setState(() {
          urlSkhu = urlDownload;
        });
        break;
    }
  }

  Future addDataSiswa(
    String nama,
    String jenisKel,
    String nisn,
    String nik,
    String tempatLahir,
    String tglLahir,
    String alamat,
    String agama,
    String ijazah,
    String urlFoto,
    String urlkk,
    String urlIjazah,
    String urlSkhu,
    String email,
  ) async {
    String tempatTglLahir = '${tempatLahir}, ${tglLahir}';

    final siswa = <String, String>{
      "nama": nama,
      "jenis kelamin": _jenisKelamin,
      "nisn": nisn,
      "nik": nik,
      "tempatTglLahir": tempatTglLahir,
      "alamat": alamat,
      "agama": _agama,
      "jurusan": _jurusan,
      "foto": urlFoto,
      "kk": urlkk,
      "ijazah": urlIjazah,
      "skhu": urlSkhu,
      "email": email
    };
    await FirebaseFirestore.instance
        .collection('siswa')
        .doc(user.uid)
        .set(siswa)
        .onError((e, _) => print("Error menambahkan data $e"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          elevation: 0,
          title: Text("Form pendaftaran"),
        ),
        body: isCompleted
            ? Container(
                child: Column(
                  children: [Text("Data berhasil disimpan")],
                ),
              )
            : Container(
                child: Column(
                  children: [
                    Expanded(
                      child: Stepper(
                        steps: steps(),
                        currentStep: _currentStep,
                        onStepTapped: (step) {
                          if (!formKey.currentState!.validate()) return;
                          setState(() => _currentStep = step);
                        },
                        onStepContinue: () {
                          // Check validate form
                          if (!formKey.currentState!.validate()) return;

                          if (_currentStep == 1) {
                            // Validator for file
                            fotoSiswa == null
                                ? setState(() => fotoIsvalid = false)
                                : null;
                            kk == null
                                ? setState(() => kkIsvalid = false)
                                : null;
                            ijazah == null
                                ? setState(() => ijazahIsvalid = false)
                                : null;
                            skhu == null
                                ? setState(() => skhuIsvalid = false)
                                : null;

                            if (!fotoIsvalid ||
                                !kkIsvalid ||
                                !ijazahIsvalid ||
                                !skhuIsvalid) return;
                            uploadFile(fotoSiswa, "Foto", urlFoto);
                            uploadFile(kk, "Kartu Keluarga", urlKk);
                            uploadFile(ijazah, "Ijazah", urlIjazah);
                            uploadFile(skhu, "Skhu", urlSkhu);
                          }
                          final isLastStep = _currentStep == steps().length - 1;
                          // _currentStep <= steps().length ? _currentStep += 1 : null;

                          if (isLastStep) {
                            addDataSiswa(
                                _namaLengkapController.text.trim(),
                                _jenisKelamin,
                                _nisnController.text.trim(),
                                _nikController.text.trim(),
                                _tempatLahirController.text.trim(),
                                _tglLahirController.text.trim(),
                                _alamatController.text.trim(),
                                _agama,
                                _jurusan,
                                urlFoto,
                                urlKk,
                                urlIjazah,
                                urlSkhu,
                                _email!);

                            // Navigator.pop(context);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => isDaftar()),
                            );

                            // When data save successfully
                            // setState(() => isCompleted = true);
                          } else {
                            setState(() {
                              _currentStep += 1;
                            });
                          }
                        },
                        onStepCancel: () {
                          _currentStep == 0
                              ? null
                              : setState(() {
                                  _currentStep == 0 ? null : _currentStep -= 1;
                                });
                        },
                        controlsBuilder: (context, details) {
                          final isLastStep = _currentStep == steps().length - 1;

                          return Container(
                            padding: EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                if (_currentStep != 0)
                                  Expanded(
                                      child: MaterialButton(
                                    onPressed: details.onStepCancel,
                                    child: Text("kembali"),
                                    textColor: Colors.grey.shade600,
                                  )),
                                Expanded(
                                    child: ElevatedButton(
                                  onPressed: details.onStepContinue,
                                  child: Text(isLastStep ? "Simpan" : "Lanjut"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.black,
                                  ),
                                ))
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ));
  }

  Widget _dataSiswa() {
    return Container(
        child: Column(children: [
      TextFormField(
        controller: _namaLengkapController,
        decoration: InputDecoration(
            labelText: "Nama lengkap",
            border: myinputborder(),
            enabledBorder: myinputborder(),
            focusedBorder: myfocusborder(),
            hintText: "Nama lengkap peserta didik"),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value!.isEmpty ? 'Nama wajib diisi' : null,
      ),
      SizedBox(
        height: 20,
      ),
      DropdownButtonFormField(
        value: _jenisKelamin,
        items: [
          'Laki-laki',
          'Perempuan',
        ].map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(
              items,
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Jenis kelamin belum dipilih!';
          }
        },
        onChanged: (value) {
          print(value);
          setState(() {
            _jenisKelamin = value!;
          });
        },
        decoration: InputDecoration(
          labelText: "Jenis Kelamin",
          border: myinputborder(),
          enabledBorder: myinputborder(),
          focusedBorder: myfocusborder(),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      TextFormField(
        controller: _nisnController,
        decoration: InputDecoration(
            labelText: "NISN",
            border: myinputborder(),
            enabledBorder: myinputborder(),
            focusedBorder: myfocusborder(),
            hintText: "NISN..."),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value!.isEmpty ? 'NISN wajib diisi' : null,
      ),
      SizedBox(
        height: 20,
      ),
      TextFormField(
        controller: _nikController,
        decoration: InputDecoration(
            labelText: "NIK",
            border: myinputborder(),
            enabledBorder: myinputborder(),
            focusedBorder: myfocusborder(),
            hintText: "NIK..."),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value!.isEmpty ? 'NIK wajib diisi' : null,
      ),
      SizedBox(
        height: 20,
      ),
      TextFormField(
        controller: _tempatLahirController,
        decoration: InputDecoration(
            labelText: "Tempat lahir",
            prefixIcon: Icon(Icons.location_pin),
            border: myinputborder(),
            enabledBorder: myinputborder(),
            focusedBorder: myfocusborder(),
            hintText: "Tempat lahir..."),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) =>
            value!.isEmpty ? 'Tempat lahir wajib diisi' : null,
      ),
      SizedBox(
        height: 20,
      ),
      TextFormField(
        controller: _tglLahirController,
        onTap: () async {
          DateTime? dateSelected = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1990),
            lastDate: DateTime(2030),
          );
          if (dateSelected != null) {
            var dateForm = DateFormat('d-MM-yyy');
            _tglLahirController.text = dateForm.format(dateSelected);
          }
        },
        readOnly: true,
        decoration: InputDecoration(
            labelText: "Tanggal lahir",
            prefixIcon: Icon(Icons.calendar_month),
            border: myinputborder(),
            enabledBorder: myinputborder(),
            focusedBorder: myfocusborder(),
            hintText: "Tanggal lahir..."),
        validator: (value) =>
            value!.isEmpty ? 'Tanggal lahir wajib diisi' : null,
      ),
      SizedBox(
        height: 20,
      ),
      TextFormField(
        controller: _alamatController,
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        decoration: InputDecoration(
            labelText: "Alamat",
            border: myinputborder(),
            enabledBorder: myinputborder(),
            focusedBorder: myfocusborder(),
            hintText: "Jl Jupiter no 99"),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value!.isEmpty ? 'Alamat wajib diisi' : null,
      ),
      SizedBox(
        height: 20,
      ),
      DropdownButtonFormField(
        value: _agama,
        items: [
          'Islam',
          'Kristen',
          'Katholik',
          'Hindu',
          'Budha',
          'Dan lain-lain',
        ].map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(
              items,
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (value) {
          print(value);
          setState(() {
            _agama = value!;
          });
        },
        decoration: InputDecoration(
          labelText: "Agama",
          border: myinputborder(),
          enabledBorder: myinputborder(),
          focusedBorder: myfocusborder(),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      DropdownButtonFormField(
        value: _jurusan,
        items: [
          'Rekayasa Perangkat Lunak',
          'Usaha Perjalanan Wisata',
          'Tata Boga',
          'Akomodasi Perhotelan',
        ].map((String items) {
          return DropdownMenuItem(
            value: items,
            child: Text(
              items,
              style: const TextStyle(fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: (value) {
          print(value);
          setState(() {
            _jurusan = value!;
          });
        },
        decoration: InputDecoration(
          labelText: "Jurusan",
          border: myinputborder(),
          enabledBorder: myinputborder(),
          focusedBorder: myfocusborder(),
        ),
      ),
    ]));
  }

  @override
  void initState() {
    // TODO: implement initState
    urlFoto = urlFoto;
    urlKk = urlKk;
    urlIjazah = urlIjazah;
    urlSkhu = urlSkhu;
    super.initState();
  }

  Widget _dokumen() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: selectImage,
            child: Container(
              height: 80,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 2, color: Colors.black)),
              child: Row(
                children: [
                  Text('Foto Siswa'),
                  Expanded(
                    child: Text(""),
                  ),
                  if (fotoSiswa != null)
                    Container(
                      width: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(fotoSiswa!.path!),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (!fotoIsvalid)
            Text(
              "Foto siswa tidak boleh kosong",
              style: TextStyle(color: Colors.red.shade300),
            ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              final result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: [
                    'png',
                    'jpg',
                    'jpeg',
                    'pdf',
                    'doc',
                    'docx',
                    'pdf'
                  ]);

              if (result == null) return;

              // final path = result.files.single.path!;

              setState(() {
                kk = result.files.first;
              });
              setState(() => kkIsvalid = true);

              print('Extension : ${kk!.extension}');

              kkName = Path.basename(kk!.path!);

              // setState(() => kk = File(path));
            },
            child: Container(
              height: 80,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 2, color: Colors.black)),
              child: Row(
                children: [
                  Text('Kartu keluarga'),
                  Expanded(
                    child: Text(""),
                  ),
                  kk != null
                      ? kk!.extension == 'jpg' ||
                              kk!.extension == 'jpeg' ||
                              kk!.extension == 'png'
                          ? Container(
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(kk!.path!),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => openFile(kk),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blue, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                width: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.file_open_outlined,
                                      size: 30,
                                    ),
                                    Text(
                                      kkName,
                                      style: TextStyle(fontSize: 10),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          if (!kkIsvalid)
            Text(
              "Kartu keluarga tidak boleh kosong!!",
              style: TextStyle(color: Colors.red.shade300),
            ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              final result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: [
                    'png',
                    'jpg',
                    'jpeg',
                    'pdf',
                    'doc',
                    'docx',
                    'pdf'
                  ]);

              if (result == null) return;

              // final path = result.files.single.path!;

              setState(() {
                ijazah = result.files.first;
              });
              setState(() => ijazahIsvalid = true);

              print('Extension : ${ijazah!.extension}');

              ijazahName = Path.basename(ijazah!.path!);

              // setState(() => ijazah = File(path));
            },
            child: Container(
              height: 80,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 2, color: Colors.black)),
              child: Row(
                children: [
                  Text('Ijazah SMP'),
                  Expanded(
                    child: Text(""),
                  ),
                  ijazah != null
                      ? ijazah!.extension == 'jpg' ||
                              ijazah!.extension == 'jpeg' ||
                              ijazah!.extension == 'png'
                          ? Container(
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(ijazah!.path!),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => openFile(ijazah),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blue, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                width: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.file_open_outlined,
                                      size: 30,
                                    ),
                                    Text(
                                      ijazahName,
                                      style: TextStyle(fontSize: 10),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          if (!ijazahIsvalid)
            Text(
              "Ijazah tidak boleh kosong!!",
              style: TextStyle(color: Colors.red.shade300),
            ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              final result = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: [
                    'png',
                    'jpg',
                    'jpeg',
                    'pdf',
                    'doc',
                    'docx',
                    'pdf'
                  ]);

              if (result == null) return;

              // final path = result.files.single.path!;

              setState(() {
                skhu = result.files.first;
              });
              setState(() => skhuIsvalid = true);

              print('Extension : ${skhu!.extension}');

              skhuName = Path.basename(skhu!.path!);

              // setState(() => skhu = File(path));
            },
            child: Container(
              height: 80,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(width: 2, color: Colors.black)),
              child: Row(
                children: [
                  Text('skhu SMP'),
                  Expanded(
                    child: Text(""),
                  ),
                  skhu != null
                      ? skhu!.extension == 'jpg' ||
                              skhu!.extension == 'jpeg' ||
                              skhu!.extension == 'png'
                          ? Container(
                              width: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(skhu!.path!),
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () => openFile(skhu),
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.blue, width: 1),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                width: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.file_open_outlined,
                                      size: 30,
                                    ),
                                    Text(
                                      skhuName,
                                      style: TextStyle(fontSize: 10),
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  ],
                                ),
                              ),
                            )
                      : SizedBox(),
                ],
              ),
            ),
          ),
          if (!skhuIsvalid)
            Text(
              "Ijazah tidak boleh kosong!!",
              style: TextStyle(color: Colors.red.shade300),
            ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
