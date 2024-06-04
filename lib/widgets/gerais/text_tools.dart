import 'dart:math';

import 'package:flutter/material.dart';

class DividerWithText extends StatelessWidget {
  final String text;

  DividerWithText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              color: const Color.fromRGBO(29, 90, 161, 1),
              thickness: 1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              text,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Divider(
              color: const Color.fromRGBO(29, 90, 161, 1),
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
