import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventItemCard extends StatelessWidget {
  const EventItemCard(
      {super.key, required this.evento, required this.categorias});

  final Evento evento;
  final List<Categoria> categorias;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: SizedBox(
                    height: 50,
                    child: Text(
                      evento.titulo,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(0, 11, 35, 1),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: categorias
                      .firstWhere(
                        (element) => element.categoriaId == evento.categoria,
                      )
                      .getIcone(),
                ),
              ],
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              evento.localizacao,
              style: const TextStyle(color: Color.fromRGBO(123, 123, 123, 1)),
            ),
            const Divider(
              indent: 15,
              endIndent: 15,
              color: Color.fromRGBO(223, 223, 223, 1),
              thickness: 2,
            ),
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
                        evento.dataFormatada('pt'),
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
    );
  }
}
