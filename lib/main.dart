import "Login/registo.dart";
import "Login/login.dart";
import "package:flutter/material.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/login", // c)
      routes: {
        "/login": (context) => const EcraLogin(),
        "/registar": (context) => const EcraRegistar()
      },
      theme: ThemeData(
        colorSchemeSeed: Color(0xFF0465D9)
      ),
    );
  }
}
