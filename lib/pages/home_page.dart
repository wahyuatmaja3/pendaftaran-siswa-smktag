import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pendaftaran_siswa_smktag/pages/formDaftar_page.dart';
import 'package:pendaftaran_siswa_smktag/pages/home_screen.dart';
import 'package:pendaftaran_siswa_smktag/pages/login_page.dart';
import 'package:pendaftaran_siswa_smktag/pages/pendaftaran_screen.dart';
import 'package:pendaftaran_siswa_smktag/pages/profile_screen.dart';
import 'package:pendaftaran_siswa_smktag/pages/splash_screen.dart';
import 'package:pendaftaran_siswa_smktag/services/auth_service.dart';
import 'package:pendaftaran_siswa_smktag/widgets/logo_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // return Scaffold(
  //     body: Center(
  //         child: Column(
  //   mainAxisAlignment: MainAxisAlignment.center,
  //   children: [
  //     Text("Signed In"),
  //     Text(FirebaseAuth.instance.currentUser!.displayName != null
  //         ? FirebaseAuth.instance.currentUser!.displayName!
  //         : ""),
  //     Text(FirebaseAuth.instance.currentUser!.email! != null
  //         ? FirebaseAuth.instance.currentUser!.email!
  //         : ""),
  //     MaterialButton(
  //       onPressed: () {
  //         AuthService().signOut();
  //       },
  //       color: Colors.blue,
  //       child: Text(
  //         'Log out',
  //         style: TextStyle(color: Colors.white),
  //       ),
  //     )
  //   ],
  // )));
  // It help us to  make our UI responsive
  List<Widget> _widgetList = [
    HomeScreen(),
    PendaftaranScreen(),
    ProfilePage(),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.black54,
        type: BottomNavigationBarType.shifting,
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list_alt_rounded,
            ),
            label: 'Daftar',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
            ),
            label: 'Profile',
          )
        ],
      ),
      body: _widgetList[_index],
    );
  }
}

PreferredSizeWidget _buildAppBar() {
  return AppBar(
    centerTitle: true,
    elevation: 0,
    backgroundColor: Colors.white,
    automaticallyImplyLeading: false,
    title: Widgetsw().logo(16, Colors.black, Colors.amber),
    actions: <Widget>[
      // Icon(Icons.search, color: Colors.white),
      // SizedBox(
      //   width: 10,
      // ),
      // Icon(Icons.notifications_none, color: Colors.white),
      // SizedBox(
      //   width: 10,
      // ),
    ],
  );
}
