import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/models/eventoTC.dart';

class EventListView extends StatelessWidget {
  final ValueNotifier<List<EventTC>> selectedEvents;

  const EventListView({
    required this.selectedEvents,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ValueListenableBuilder<List<EventTC>>(
        valueListenable: selectedEvents,
        builder: (context, value, _) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              String vagas = value[index].numeroMaxPart == 0
                  ? "-"
                  : value[index].numeroMaxPart.toString();
              String participantes =
                  "${value[index].numeroInscritos.toString()}/$vagas";

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
                      color: const Color.fromRGBO(217, 215, 215, 1),
                      borderRadius: BorderRadius.circular(15)),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const FaIcon(
                                FontAwesomeIcons.cutlery,
                                color: Color.fromRGBO(123, 123, 123, 1),
                                size: 24,
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 12),
                                child: Text(
                                  value[index].titulo,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromRGBO(0, 11, 35, 1),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Row(
                                children: [
                                  Container(
                                      margin: const EdgeInsets.only(right: 5),
                                      child: Text(participantes)),
                                  const FaIcon(
                                    FontAwesomeIcons.userGroup,
                                    color: Color.fromRGBO(123, 123, 123, 1),
                                    size: 24,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            value[index].localizacao,
                            style: const TextStyle(
                                color: Color.fromRGBO(123, 123, 123, 1)),
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
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
