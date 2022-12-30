import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pendaftaran_siswa_smktag/pages/dataDaftar_page.dart';
import 'package:pendaftaran_siswa_smktag/pages/formDaftar_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class isDaftar extends StatefulWidget {
  const isDaftar({super.key});

  @override
  State<isDaftar> createState() => _isDaftarState();
}

class _isDaftarState extends State<isDaftar> {
  final user = FirebaseAuth.instance.currentUser!;

  Future UserIsDaftar() async {
    var doc = await FirebaseFirestore.instance
        .collection('siswa')
        .doc(user.uid)
        .get();
    if (doc.exists) {
      setState(() {
        isDaftar = true;
      });
    }
  }

  bool isDaftar = false;

  @override
  void initState() {
    // TODO: implement initState
    UserIsDaftar();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => isDaftar ? DataDaftar() : FormDaftar();
}
