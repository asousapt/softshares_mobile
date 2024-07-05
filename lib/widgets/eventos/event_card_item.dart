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
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: SizedBox(
          width: largura * 0.45,
          height: altura * 0.3,
          child: Column(
            children: [
              SizedBox(
                height: altura * 0.05,
                child: Text(
                  evento.titulo,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: altura * 0.012,
              ),
              FadeInImage(
                fit: BoxFit.cover,
                height: altura * 0.1,
                width: double.infinity,
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(
                    evento.imagem != null ? evento.imagem![0] : ""),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.calendar,
                    color: Color.fromRGBO(123, 123, 123, 1),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: largura * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          evento.dataFormatada("pt"),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(123, 123, 123, 1),
                          ),
                        ),
                        Text(
                          evento.horaFormatada("pt"),
                          style: const TextStyle(
                            fontSize: 11,
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
    );
  }
}
