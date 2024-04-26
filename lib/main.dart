import "screens/Login/registo.dart";
import "screens/Login/login.dart";
import "package:flutter/material.dart";
//import 'package:softshares_mobile/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Softshares',
      initialRoute: "/login", // c)
      routes: {
        "/login": (context) => const EcraLogin(),
        "/registar": (context) => const EcraRegistar()
      },
      theme: ThemeData(
        colorSchemeSeed: Color(0xFF0465D9)
      )
    /*return const MaterialApp(
      home: HomeScreen(),*/
    );
  }
}
