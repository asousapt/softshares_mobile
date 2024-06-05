import 'dart:math';

import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  const DividerWithText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(vertical: altura * 0.01),
      child: Row(
        children: <Widget>[
          const Expanded(
            child: Divider(
              color: const Color.fromRGBO(29, 90, 161, 1),
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: largura * 0.02),
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Expanded(
            child: Divider(
              color: Color.fromRGBO(29, 90, 161, 1),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
