import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventItem extends StatelessWidget {
  const EventItem({
    Key? key,
    required this.evento,
  }) : super(key: key);

  final Evento evento;

  @override
  Widget build(BuildContext context) {
    String vagas =
        evento.numeroMaxPart == 0 ? "-" : evento.numeroMaxPart.toString();
    String participantes = "${evento.numeroInscritos.toString()}/$vagas";

    return InkWell(
      onTap: () {},
      child: Card(
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
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      evento.titulo,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(0, 11, 35, 1),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: Text(participantes),
                      ),
                      const FaIcon(
                        FontAwesomeIcons.userGroup,
                        color: Color.fromRGBO(123, 123, 123, 1),
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 3),
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
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        evento.dataFormatada('pt'),
                        style: const TextStyle(
                          color: Color.fromRGBO(123, 123, 123, 1),
                        ),
                      ),
                      Text(
                        evento.horaFormatada('pt'),
                        style: const TextStyle(
                          color: Color.fromRGBO(123, 123, 123, 1),
                        ),
                      ),
                    ],
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
