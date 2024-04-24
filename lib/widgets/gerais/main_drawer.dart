import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            contentPadding: EdgeInsets.only(top: 15, left: 15),
            leading: Icon(FontAwesomeIcons.user),
            title: Text("Perfil"),
          ),
          ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.only(left: 15, top: 10),
            leading: Icon(FontAwesomeIcons.bell),
            title: Text("Notificações"),
          ),
          ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.only(left: 15, top: 10),
            leading: Icon(FontAwesomeIcons.headset),
            title: Text("Suporte"),
          ),
          ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.only(left: 15, top: 10),
            leading: Icon(FontAwesomeIcons.city),
            title: Text("Escolher Polo"),
          ),
          ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.only(left: 15, top: 10),
            leading: Icon(FontAwesomeIcons.gears),
            title: Text("Definições"),
          ),
          ListTile(
            onTap: () {},
            contentPadding: EdgeInsets.only(left: 15, top: 10),
            leading: Icon(FontAwesomeIcons.rightFromBracket),
            title: Text("Desconectar"),
          ),
        ],
      ),
    );
  }
}
