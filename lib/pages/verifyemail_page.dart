import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pendaftaran_siswa_smktag/utils/utils.dart';
import 'package:pendaftaran_siswa_smktag/pages/home_page.dart';
import 'dart:async';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // User need to be created before
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      Utils.showActionSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      // ? if verified return homepage, else make new page
      ? HomePage()
      : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black87,
            elevation: 0,
            title: Text("Verify Email"),
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Kami telah mengirimkan email verifikasi ke Email kamu'),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.restart_alt),
                        label: Text('Kirim Ulang'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            shadowColor: Color.fromARGB(255, 2, 2, 2),
                            padding: EdgeInsets.symmetric(
                                horizontal: 35, vertical: 10)),
                      ),
                    )),
                SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: ElevatedButton(
                        onPressed: () => FirebaseAuth.instance.signOut(),
                        child: Text(
                          'batalkan',
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            padding: EdgeInsets.symmetric(
                                horizontal: 35, vertical: 10)),
                      ),
                    ))
              ],
            ),
          ));
}
