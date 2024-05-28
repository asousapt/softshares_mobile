import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/mensagem.dart';

class MensagemItem extends StatelessWidget {
  final Mensagem mensagem;

  const MensagemItem({Key? key, required this.mensagem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(mensagem.mensagemTexto),
      subtitle: Text('From: ${mensagem.remetente.getNomeCompleto()}'),
      trailing: Text(mensagem.dataEnvio.toIso8601String()),
      onTap: () {
        // Handle message tap, e.g., navigate to message details screen
      },
    );
  }
}
