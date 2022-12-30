import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pendaftaran_siswa_smktag/pages/auth_page.dart';
import 'package:pendaftaran_siswa_smktag/pages/login_page.dart';
import 'package:pendaftaran_siswa_smktag/pages/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pendaftaran_siswa_smktag/pages/splash_screen.dart';
import 'package:pendaftaran_siswa_smktag/pages/verifyemail_page.dart';

//Google sign in
class AuthService {
  handleAuthState() {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Cek jika internet loading
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Cek jika terdapat error pada autentikasi
          return Center(child: Text('Something went wrong!'));
        } else if (snapshot.hasData) {
          // Cek jika autentikasi berhasil
          return VerifyEmailPage();
        } else {
          return AuthPage();
        }
      }),
    );
  }

  signInWithGoogle() async {
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>['email']).signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
