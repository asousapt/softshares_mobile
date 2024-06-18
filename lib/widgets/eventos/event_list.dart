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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ValueListenableBuilder<List<Evento>>(
        valueListenable: selectedEvents,
        builder: (context, value, _) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(15)),
                    child: EventItem(
                      evento: value[index],
                      categorias: categorias,
                      idioma: idioma,
                    )),
              );
            },
          );
        },
      ),
    );
  }
}
