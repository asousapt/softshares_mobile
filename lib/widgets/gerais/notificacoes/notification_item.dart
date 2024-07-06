import 'package:flutter/material.dart';
import 'package:softshares_mobile/time_utils.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard(
      {super.key,
      required this.texto,
      required this.icone,
      required this.data,
      required this.idioma});

  final String texto;
  final Icon icone;
  final DateTime data;
  final String idioma;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(188, 206, 235, 1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(backgroundColor: Colors.black, child: icone),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  texto,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            dataFormatada(idioma, data),
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
