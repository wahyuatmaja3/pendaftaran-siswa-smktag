import 'package:flutter/material.dart';

class Widgetsw {
  Widget logo(double fontSize, Color color1, Color color2) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: "PPDB",
          style: TextStyle(
              fontFamily: "Inknut Antiqua",
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: color1),
          children: [
            TextSpan(
              text: 'SMKTAG',
              style: TextStyle(color: color2, fontSize: 15),
            ),
          ]),
    );
  }
}
