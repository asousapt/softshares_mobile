import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/widgets/eventos/event_item.dart';

class EventListView extends StatelessWidget {
  final ValueNotifier<List<Evento>> selectedEvents;
  final List<Categoria> categorias;
  final String idioma;

  const EventListView({
    required this.selectedEvents,
    super.key,
    required this.categorias,
    required this.idioma,
  });

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: largura * 0.02,
        vertical: altura * 0.01,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ValueListenableBuilder<List<Evento>>(
        valueListenable: selectedEvents,
        builder: (context, value, _) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: altura * 0.01),
                  child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: EventItem(
                        evento: value[index],
                        categorias: categorias,
                        idioma: idioma,
                      )),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
