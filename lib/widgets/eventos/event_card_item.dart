import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:transparent_image/transparent_image.dart';

class EventCardItem extends StatelessWidget {
  const EventCardItem({
    super.key,
    required this.evento,
  });

  final Evento evento;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(evento.eventoId);
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: 220,
            height: 240,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: Text(
                    evento.titulo,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeInImage(
                  fit: BoxFit.cover,
                  height: 100,
                  width: double.infinity,
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(
                      "https://pplware.sapo.pt/wp-content/uploads/2022/02/s_22_plus_1.jpg "),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.calendar,
                      color: Color.fromRGBO(123, 123, 123, 1),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            evento.dataFormatada("pt"),
                            style: const TextStyle(
                              color: Color.fromRGBO(123, 123, 123, 1),
                            ),
                          ),
                          Text(
                            evento.horaFormatada("pt"),
                            style: const TextStyle(
                              color: Color.fromRGBO(123, 123, 123, 1),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
