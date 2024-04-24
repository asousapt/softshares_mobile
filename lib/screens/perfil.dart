import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/widgets/gerais/tab_perfil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [FaIcon(FontAwesomeIcons.save)],
        title: const Text("Perfil"),
      ),
      backgroundColor: const Color.fromRGBO(29, 90, 161, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [TabPerfil()],
      ),
    );
  }
}
