import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventItemCard extends StatelessWidget {
  const EventItemCard({
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

    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: altura * 0.01,
          horizontal: largura * 0.02,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: altura * 0.05,
                  child: Text(
                    evento.titulo,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(0, 11, 35, 1),
                    ),
                  ),
                ),
                SizedBox(height: altura * 0.01),
                Text(
                  evento.localizacao,
                  style: const TextStyle(
                    color: Color.fromRGBO(123, 123, 123, 1),
                  ),
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
                      margin: EdgeInsets.symmetric(horizontal: largura * 0.02),
                      child: Column(
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
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.only(right: largura * 0.02),
                child: categorias
                    .firstWhere(
                      (element) => element.categoriaId == evento.categoria,
                    )
                    .getIcone(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
