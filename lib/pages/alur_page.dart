import 'package:flutter/material.dart';

class AlurPage extends StatelessWidget {
  const AlurPage({super.key});

  Widget _alurBox(String no, String deskripsi) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.amber.shade300,
          border: Border.all(width: 2, color: Colors.orange),
          borderRadius: BorderRadius.circular(100)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  no,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(100)),
          ),
          SizedBox(
            width: 20,
          ),
          Expanded(child: Text(deskripsi))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        elevation: 0,
        title: Text("Alur Pendaftaran"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            _alurBox('1',
                'Calon peserta didik registrasi online melalui Aplikasi PPDB SMKTAG'),
            SizedBox(
              height: 20,
            ),
            _alurBox('2',
                'Calon peserta didik Mencetak bukti pendaftaran untuk verifikasi berkas'),
            SizedBox(
              height: 20,
            ),
            _alurBox('3',
                'Calon peserta didik datang ke SMKTAG untuk menyerahkan berkas dan formulir data diri'),
            SizedBox(
              height: 20,
            ),
            _alurBox('4',
                'Calon peserta didik melakukan pembayaran daftar ulang untuk pengambilan seragam sekolah'),
            SizedBox(
              height: 20,
            ),
            _alurBox('5',
                'Setelah melakukan proses administrasi, Siswa akan mendapatkan pengumuman pelaksanaan mpls'),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
