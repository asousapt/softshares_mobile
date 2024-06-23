import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/models/categoria.dart';

class EventItem extends StatelessWidget {
  const EventItem({
    super.key,
    required this.evento,
    required this.categorias,
    required this.idioma,
  });

  final Evento evento;
  final List<Categoria> categorias;
  final String idioma;

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    String vagas =
        evento.numeroMaxPart == 0 ? "-" : evento.numeroMaxPart.toString();
    print(evento.numeroInscritos);
    String participantes = "${evento.numeroInscritos.toString()}/$vagas";

    return InkWell(
      onTap: () {
        //prepara argumentos para a rota
        Map<String, dynamic> args = {
          "evento": evento,
          "categorias": categorias,
        };
        Navigator.of(context).pushNamed(
          "/consultarEvento",
          arguments: args,
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  categorias
                      .firstWhere(
                        (element) => element.categoriaId == evento.categoria,
                      )
                      .getIcone(),
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
                        evento.dataFormatada(idioma),
                        style: const TextStyle(
                          color: Color.fromRGBO(123, 123, 123, 1),
                        ),
                      ),
                      Text(
                        evento.horaFormatada(idioma),
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
