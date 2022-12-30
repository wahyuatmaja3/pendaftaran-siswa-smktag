import 'package:flutter/material.dart';
import 'package:pendaftaran_siswa_smktag/pages/alur_page.dart';
import 'package:pendaftaran_siswa_smktag/pages/forgotpass_page.dart';
import 'package:pendaftaran_siswa_smktag/pages/jadwal_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    Widget _card(
        Color color, String title, IconData icon, Widget page, String size) {
      final isLarge = size == 'large';
      return GestureDetector(
        child: Container(
          padding: EdgeInsets.all(15),
          width: size == 'large' ? _width - 40 : _width / 2 - 25,
          height: 120,
          decoration: BoxDecoration(
            // border: Border.all(color: Colors.black54, width: 1),
            color: color, border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: isLarge
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 60,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    )
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      icon,
                      size: 40,
                    ),
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
        ),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => page));
        },
      );
    }

    return Scaffold(
      body: Container(
          child: SingleChildScrollView(
              child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: _width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black, width: 2)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  //make border radius more than 50% of square height & width
                  child: Image.asset(
                    "assets/img/banner.png",
                    width: double.infinity,
                    fit: BoxFit.cover, //change image fill type
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _card(Colors.red[300]!, "Aturan & Prosedur", Icons.sync,
                    AlurPage(), "small"),
                _card(Colors.amber[300]!, "Jadwal", Icons.date_range_rounded,
                    JadwalPage(), "small")
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     _card(Colors.blue[300]!, "Cetak", Icons.print_outlined,
            //         ForgotPasswordPage(), 'large')
            //   ],
            // )
          ],
        ),
      ))),
    );
  }
}
