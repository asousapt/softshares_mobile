import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventItemCard extends StatelessWidget {
  const EventItemCard({
    super.key,
    required this.evento,
  });

  final Evento evento;

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
                const FaIcon(
                  FontAwesomeIcons.utensils,
                  color: Color.fromRGBO(123, 123, 123, 1),
                  size: 24,
                ),
                SizedBox(
                  height: 40,
                  child: Text(
                    evento.titulo,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(0, 11, 35, 1),
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.abc,
                      size: 24,
                    ))
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
                    children: [
                      Text(
                        "linha 1",
                        style: const TextStyle(
                          color: Color.fromRGBO(123, 123, 123, 1),
                        ),
                      ),
                      Text(
                        "linha 2",
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
