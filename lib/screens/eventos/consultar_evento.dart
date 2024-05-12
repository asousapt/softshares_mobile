import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConsultEventScreen extends StatelessWidget {
  const ConsultEventScreen({
    super.key,
    required this.evento,
  });

  final Evento evento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.evento,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          left: 12,
          right: 12,
          bottom: 20,
        ),
        child: Container(
          color: Theme.of(context).canvasColor,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
