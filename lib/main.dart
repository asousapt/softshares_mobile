import "screens/Login/registo.dart";
import "screens/Login/login.dart";
import "package:flutter/material.dart";
//import 'package:softshares_mobile/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:softshares_mobile/screens/home.dart';
import 'package:softshares_mobile/screens/perfil.dart';
import 'package:softshares_mobile/models/utilizador.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Utilizador utilizador = Utilizador(
      1, // utilizadorId
      'John', // pNome
      'Doe', // uNome
      'john.doe@example.com', // email
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.', // sobre
      1, // poloId
      [1, 2, 3], // preferencias
      1, // funcaoId
      1, // departamentoId
    );

    return MaterialApp(
      title: 'Softshares',
      initialRoute: "/login",
      routes: {
        "/login": (context) => const EcraLogin(),
        "/registar": (context) => const EcraRegistar()
      },
      //home: HomeScreen(),
      theme: ThemeData(
        colorSchemeSeed: Color(0xFF0465D9)
      )
    );
  }
}
