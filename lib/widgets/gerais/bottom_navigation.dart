import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() {
    return _BottomNavigationState();
  }
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 1,
      destinations: [
        NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.homeAlt), label: "Home"),
        NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.mapLocation), label: "Pontos Int."),
        NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.globe), label: "Fórum"),
        NavigationDestination(
            icon: FaIcon(FontAwesomeIcons.calendar), label: "Eventos"),
        NavigationDestination(
            icon: Badge(
              label: Text("2"),
              child: Icon(
                FontAwesomeIcons.message,
              ),
            ),
            label: "Mensagens"),
      ],
    );
  }
}
