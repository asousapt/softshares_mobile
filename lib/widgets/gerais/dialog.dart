import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.titulo,
    required this.msg,
  });

  final String titulo;
  final String msg;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titulo),
      content: Text(msg),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(AppLocalizations.of(context)!.no),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop(true);
          },
          child: Text(AppLocalizations.of(context)!.yes),
        ),
      ],
    );
  }
}

Future<bool> confirmExit(
    BuildContext context, String titulo, String mensagem) async {
  bool? confirm = await showDialog(
    context: context,
    builder: (context) => ConfirmDialog(titulo: titulo, msg: mensagem),
  );
  return confirm ?? false;
}
