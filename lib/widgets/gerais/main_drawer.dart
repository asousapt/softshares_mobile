import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/models/utilizador.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  Utilizador? utilizador;
  String polo_a_ver = "";

  @override
  void initState() {
    carregaUtilizador();
    super.initState();
  }

  // carrega o utilizador logado e polo que está seleccionado
  void carregaUtilizador() async {
    final prefs = await SharedPreferences.getInstance();
    String? util = prefs.getString('utilizadorObj');
    polo_a_ver = prefs.getString('polo') ?? "";
    print("user   " + util.toString());
    if (util != null) {
      Map<String, dynamic> user = jsonDecode(util);
      setState(() {
        utilizador = Utilizador.fromJson(user);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Drawer(
        child: ListView(
          children: [
            if (utilizador != null)
              UserAccountsDrawerHeader(
                accountName: Text(
                  utilizador!.getNomeCompleto(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                    "${AppLocalizations.of(context)!.poloSeleccionado}: $polo_a_ver"),
                currentAccountPicture: CircleAvatar(
                  radius: 180,
                  backgroundImage: NetworkImage(utilizador!
                      .fotoUrl!), // Replace with your actual image URL
                ),
              ),
            ListTile(
              onTap: () {
                if (utilizador != null) {
                  Navigator.pushNamed(context, '/perfil',
                      arguments: utilizador!);
                }
              },
              contentPadding: const EdgeInsets.only(top: 15, left: 15),
              leading: const Icon(FontAwesomeIcons.user),
              title: Text(AppLocalizations.of(context)!.perfil),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/notificacoes');
              },
              contentPadding: const EdgeInsets.only(left: 15, top: 10),
              leading: const Icon(FontAwesomeIcons.bell),
              title: Text(AppLocalizations.of(context)!.notificacoes),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/suporte');
              },
              contentPadding: const EdgeInsets.only(left: 15, top: 10),
              leading: const Icon(FontAwesomeIcons.headset),
              title: Text(AppLocalizations.of(context)!.suporte),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/escolherPolo");
              },
              contentPadding: const EdgeInsets.only(left: 15, top: 10),
              leading: const Icon(FontAwesomeIcons.city),
              title: Text(AppLocalizations.of(context)!.seleccionarPolo),
            ),
            ListTile(
              onTap: () {},
              contentPadding: const EdgeInsets.only(left: 15, top: 10),
              leading: const Icon(FontAwesomeIcons.gears),
              title: Text(AppLocalizations.of(context)!.definicoes),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/login");
              },
              contentPadding: const EdgeInsets.only(left: 15, top: 10),
              leading: const Icon(FontAwesomeIcons.rightFromBracket),
              title: Text(AppLocalizations.of(context)!.logout),
            ),
          ],
        ),
      ),
    );
  }
}
