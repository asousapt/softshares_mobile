import 'dart:convert';

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
      routes: {
        '/perfil': (context) => ProfileScreen(
              utilizador: utilizador,
            ),
      },
      home: HomeScreen(),
    );
  }
}
