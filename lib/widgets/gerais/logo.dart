import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  Widget build(context) {
    return RichText(
        text:
            TextSpan(style: TextStyle(fontWeight: FontWeight.w600), children: [
      TextSpan(
          text: 'SOFT',
          style:
              TextStyle(fontSize: 36, color: Color.fromRGBO(29, 90, 161, 1))),
      TextSpan(
          text: 'SHARES', style: TextStyle(fontSize: 36, color: Colors.black)),
    ]));
  }
}
