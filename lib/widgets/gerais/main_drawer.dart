import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, '/perfil');
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
            onTap: () {},
            contentPadding: const EdgeInsets.only(left: 15, top: 10),
            leading: const Icon(FontAwesomeIcons.headset),
            title: Text(AppLocalizations.of(context)!.suporte),
          ),
          ListTile(
            onTap: () {},
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
            onTap: () {},
            contentPadding: const EdgeInsets.only(left: 15, top: 10),
            leading: const Icon(FontAwesomeIcons.rightFromBracket),
            title: Text(AppLocalizations.of(context)!.logout),
          ),
        ],
      ),
    );
  }
}
