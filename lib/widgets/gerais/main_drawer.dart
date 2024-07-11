import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/notificacao_repository.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:badges/badges.dart' as badges;
import 'package:softshares_mobile/services/google_signin_api.dart';
import 'package:softshares_mobile/widgets/gerais/dialog.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  Utilizador? utilizador;
  String polo_a_ver = "";
  String iniciais = "";
  late final prefs;
  int numeroNotificacoes = 0;

  @override
  void initState() {
    carregaUtilizador();
    super.initState();
  }

  // carrega o utilizador logado e polo que está seleccionado
  void carregaUtilizador() async {
    prefs = await SharedPreferences.getInstance();
    String? util = prefs.getString('utilizadorObj');
    polo_a_ver = prefs.getString('polo') ?? "";
    NotificacaoRepository notificacaoRepository = NotificacaoRepository();
    int nmr = await notificacaoRepository.getNmrNotificacoes();
    setState(() {
      numeroNotificacoes = nmr;
    });

    if (util != null) {
      Map<String, dynamic> user = jsonDecode(util);

      setState(() {
        utilizador = Utilizador.fromJson(user);
        iniciais = utilizador!.getIniciais();
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
                  backgroundImage: (utilizador!.fotoUrl == null ||
                          utilizador!.fotoUrl!.isEmpty)
                      ? null
                      : NetworkImage(utilizador!.fotoUrl!)
                          as ImageProvider<Object>?,
                  backgroundColor: (utilizador!.fotoUrl == null ||
                          utilizador!.fotoUrl!.isEmpty)
                      ? Colors.blue
                      : null,
                  child: (utilizador!.fotoUrl == null ||
                          utilizador!.fotoUrl!.isEmpty)
                      ? Text(
                          iniciais,
                          style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                          ),
                        )
                      : null,
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

// Inside your widget build method
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/notificacoes');
              },
              contentPadding:
                  const EdgeInsets.only(left: 15, top: 10, right: 10),
              leading: const Icon(FontAwesomeIcons.bell),
              title: Text(AppLocalizations.of(context)!.notificacoes),
              trailing: badges.Badge(
                badgeContent: Text(
                  numeroNotificacoes.toString(),
                  style: TextStyle(color: Theme.of(context).canvasColor),
                ),
                badgeStyle: badges.BadgeStyle(
                  shape: badges.BadgeShape.circle,
                  badgeColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.all(8),
                  elevation: 4,
                ),
              ),
            ),

            /* ListTile(
              onTap: () {
                Navigator.pushNamed(context, '/suporte');
              },
              contentPadding: const EdgeInsets.only(left: 15, top: 10),
              leading: const Icon(FontAwesomeIcons.headset),
              title: Text(AppLocalizations.of(context)!.suporte),
            ),*/
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/escolherPolo");
              },
              contentPadding: const EdgeInsets.only(left: 15, top: 10),
              leading: const Icon(FontAwesomeIcons.city),
              title: Text(AppLocalizations.of(context)!.seleccionarPolo),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/definicoes");
              },
              contentPadding: const EdgeInsets.only(left: 15, top: 10),
              leading: const Icon(FontAwesomeIcons.gears),
              title: Text(AppLocalizations.of(context)!.definicoes),
            ),
            ListTile(
              onTap: () async {
                Future<bool> confirma = confirmExit(
                    context,
                    AppLocalizations.of(context)!.confirmarSaida,
                    AppLocalizations.of(context)!.temCerteza);
                confirma.then((value) async {
                  if (value) {
                    prefs.setBool('isChecked', false);
                    await FacebookAuth.instance.logOut();
                    await GoogleSignInApi.logout();
                    Navigator.pushNamed(context, "/login");
                  }
                });
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
