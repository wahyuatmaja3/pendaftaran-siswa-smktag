import 'package:flutter/material.dart';
import 'package:pendaftaran_siswa_smktag/pages/dataDaftar_page.dart';
import 'package:pendaftaran_siswa_smktag/pages/formDaftar_page.dart';
import 'package:pendaftaran_siswa_smktag/pages/isDaftar_page.dart';

class PendaftaranScreen extends StatefulWidget {
  const PendaftaranScreen({super.key});

  @override
  State<PendaftaranScreen> createState() => _PendaftaranScreenState();
}

class _PendaftaranScreenState extends State<PendaftaranScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      border: Border.all(color: Colors.black, width: 2),
                      borderRadius: BorderRadius.circular(20)),
                  width: double.infinity,
                  height: 60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.list_alt_sharp),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Daftar peserta didik baru",
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => isDaftar()));
                },
              )),
        ],
      ),
    );
  }
}
