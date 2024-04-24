import 'package:flutter/material.dart';
import 'package:softshares_mobile/screens/home.dart';
import 'package:softshares_mobile/screens/perfil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        '/perfil': (context) => const ProfileScreen(),
      },
    );
  }
}
