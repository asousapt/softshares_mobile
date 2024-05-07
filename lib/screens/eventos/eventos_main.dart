import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/widgets/eventos/event_card_item.dart';
import 'package:softshares_mobile/widgets/eventos/evento_card_eventos.dart';
import 'package:softshares_mobile/widgets/gerais/bottom_navigation.dart';
import 'package:softshares_mobile/widgets/gerais/main_drawer.dart';

class EventosMainScreen extends StatefulWidget {
  const EventosMainScreen({super.key});

  @override
  State<EventosMainScreen> createState() => _EventosMainScreenState();
}

class _EventosMainScreenState extends State<EventosMainScreen> {
  String tituloInscritos = "";
  String tituloTotalEventos = "";

  List<Evento> listaEventos = [
    Evento(
      1,
      "Conferência de Tecnologia 2024",
      1,
      "Junte-se a nós para a maior conferência de tecnologia do ano!",
      1000,
      500,
      "Virtual",
      DateTime(2024, 06, 15, 10, 0), // June 15, 2024, 10:00 AM
      DateTime(2024, 06, 15, 18, 0), // June 17, 2024, 6:00 PM
      "tech_conference_image.jpg",
    ),
    Evento(
      2,
      "Festival de Música 2024",
      2,
      "Viva um fim de semana de música, comida e diversão!",
      5000,
      3000,
      "Central Park, Nova York",
      DateTime(2024, 07, 20, 12, 0), // July 20, 2024, 12:00 PM
      DateTime(2024, 07, 22, 22, 0), // July 22, 2024, 10:00 PM
      "music_festival_image.jpg",
    ),
    Evento(
      3,
      "Cimeira de Startups 2024",
      1,
      "Conecte-se com investidores e empreendedores na Cimeira de Startups!",
      800,
      400,
      "San Francisco, Califórnia",
      DateTime(2024, 08, 10, 9, 0), // August 10, 2024, 9:00 AM
      DateTime(2024, 08, 12, 17, 0), // August 12, 2024, 5:00 PM
      "startup_summit_image.jpg",
    ),
    Evento(
      4,
      "Feira de Livros 2024",
      3,
      "Explore uma variedade de livros de diferentes gêneros na Feira de Livros!",
      500,
      200,
      "Centro de Convenções, São Paulo",
      DateTime(2024, 09, 5, 10, 0), // September 5, 2024, 10:00 AM
      DateTime(2024, 09, 10, 20, 0), // September 10, 2024, 8:00 PM
      "feira_livros_image.jpg",
    ),
    Evento(
      5,
      "Exposição de Arte Contemporânea 2024",
      4,
      "Descubra obras de arte modernas e inovadoras na Exposição de Arte Contemporânea!",
      300,
      150,
      "Galeria de Arte Moderna, Lisboa",
      DateTime(2024, 10, 15, 12, 0), // October 15, 2024, 12:00 PM
      DateTime(2024, 10, 20, 18, 0), // October 20, 2024, 6:00 PM
      "exposicao_arte_image.jpg",
    ),
    Evento(
      6,
      "Conferência de Saúde Mental 2024",
      5,
      "Participe de palestras e workshops sobre saúde mental na Conferência de Saúde Mental!",
      600,
      300,
      "Online",
      DateTime(2024, 11, 8, 9, 0), // November 8, 2024, 9:00 AM
      DateTime(2024, 11, 10, 17, 0), // November 10, 2024, 5:00 PM
      "saude_mental_conferencia_image.jpg",
    ),
  ];

  List<Evento> eventosInscrito = [
    Evento(
      1,
      "Conferência de Tecnologia 2024",
      1,
      "Junte-se a nós para a maior conferência de tecnologia do ano!",
      1000,
      500,
      "Virtual",
      DateTime(2024, 06, 15, 10, 0), // June 15, 2024, 10:00 AM
      DateTime(2024, 06, 15, 18, 0), // June 17, 2024, 6:00 PM
      "tech_conference_image.jpg",
    ),
    Evento(
      2,
      "Festival de Música 2024",
      2,
      "Viva um fim de semana de música, comida e diversão!",
      5000,
      3000,
      "Central Park, Nova York",
      DateTime(2024, 07, 20, 12, 0), // July 20, 2024, 12:00 PM
      DateTime(2024, 07, 22, 22, 0), // July 22, 2024, 10:00 PM
      "music_festival_image.jpg",
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

// Foi necessario adicionar este bloco por causa das dependencias
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tituloInscritos =
        "${eventosInscrito.length.toString()} ${AppLocalizations.of(context)!.eventos}";
    tituloTotalEventos =
        "${listaEventos.length.toString()} ${AppLocalizations.of(context)!.eventos}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(29, 90, 161, 1),
        onPressed: () {
          print("object");
        },
        child: const Icon(
          FontAwesomeIcons.plus,
          color: Color.fromRGBO(217, 215, 215, 1),
        ),
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: const BottomNavigation(seleccao: 3),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.eventos),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.filter),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 15,
                left: 12,
                right: 12,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Eventos Inscritos:",
                    style: const TextStyle(
                      color: Color.fromRGBO(217, 215, 215, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    tituloInscritos,
                    style: const TextStyle(
                      color: Color.fromRGBO(217, 215, 215, 1),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 240,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: eventosInscrito.map((e) {
                        return EventCardItem(evento: e);
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Eventos Futuros:",
                    style: const TextStyle(
                      color: Color.fromRGBO(217, 215, 215, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    tituloTotalEventos,
                    style: const TextStyle(
                      color: Color.fromRGBO(217, 215, 215, 1),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 280,
                    child: ListView(
                      children: listaEventos.map((e) {
                        return EventItemCard(evento: e);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
