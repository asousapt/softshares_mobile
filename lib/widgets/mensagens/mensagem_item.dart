import 'package:flutter/material.dart';

class MensagemItem extends StatelessWidget {
  const MensagemItem({
    super.key,
    required this.nome,
    required this.mensagemTexto,
    required this.hora,
    required this.imagemUrl,
  });

  final String nome;
  final String mensagemTexto;
  final String hora;

  final String imagemUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Row(
        children: <Widget>[
          imagemUrl.isEmpty
              ? CircleAvatar(
                  maxRadius: 30,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    nome[0].toUpperCase(),
                    style: TextStyle(color: Theme.of(context).canvasColor),
                  ),
                )
              : CircleAvatar(
                  backgroundImage: NetworkImage(imagemUrl),
                  maxRadius: 30,
                ),
          const SizedBox(width: 16),
          Expanded(
            child: Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    nome,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    mensagemTexto,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            hora,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
