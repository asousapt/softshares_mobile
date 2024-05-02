import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({
    super.key,
    required this.seleccao,
  });

  final int seleccao;

  @override
  State<BottomNavigation> createState() {
    return _BottomNavigationState();
  }
}

class _BottomNavigationState extends State<BottomNavigation> {
  int? selecionado;

  @override
  void initState() {
    super.initState();
    selecionado = widget.seleccao;
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selecionado!,
      destinations: [
        NavigationDestination(
          icon: const FaIcon(FontAwesomeIcons.house),
          label: AppLocalizations.of(context)!.home,
        ),
        NavigationDestination(
            icon: const FaIcon(FontAwesomeIcons.mapLocation),
            label: AppLocalizations.of(context)!.poi),
        NavigationDestination(
            icon: const FaIcon(FontAwesomeIcons.globe),
            label: AppLocalizations.of(context)!.threads),
        NavigationDestination(
            icon: const FaIcon(FontAwesomeIcons.calendar),
            label: AppLocalizations.of(context)!.eventos),
        NavigationDestination(
            icon: Badge(
              label: Text("2"),
              child: const Icon(FontAwesomeIcons.message),
            ),
            label: AppLocalizations.of(context)!.messages),
      ],
    );
  }
}
