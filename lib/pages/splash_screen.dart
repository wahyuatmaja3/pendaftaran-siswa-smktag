import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pendaftaran_siswa_smktag/pages/auth_page.dart';
import 'package:pendaftaran_siswa_smktag/services/auth_service.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => AuthService().handleAuthState()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Color(0xFFFED049),
        backgroundColor: Color(0xFFFED049),
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/img/logo.png',
                  height: 120,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "PPDB",
                      style: TextStyle(
                          fontFamily: "Inknut Antiqua",
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                      children: [
                        TextSpan(
                          text: 'SMKTAG',
                          style: TextStyle(color: Colors.black87, fontSize: 25),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ));
  }
}
