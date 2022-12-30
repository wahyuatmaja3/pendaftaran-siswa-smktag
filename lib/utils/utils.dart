import 'package:flutter/material.dart';
import 'package:pendaftaran_siswa_smktag/main.dart';

class Utils {
  // showSnackBar(String? text) {
  //   if (text == null) return;

  //   final snackBar = SnackBar(
  //     content: Text(text),
  //     backgroundColor: Colors.red,
  //   );

  //   messengerKey.currentState!
  //     ..removeCurrentSnackBar()
  //     ..showSnackBar(snackBar);
  // }

  static void showActionSnackBar(BuildContext context, String? text) {
    final snackBar = SnackBar(
      content: Text(text!),
      backgroundColor: Colors.red,
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
