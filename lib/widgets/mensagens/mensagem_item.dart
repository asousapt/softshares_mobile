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
          const CircleAvatar(
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
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
                    style: TextStyle(
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
            style: TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
