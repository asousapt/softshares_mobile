import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:transparent_image/transparent_image.dart';

class ConsultEventScreen extends StatefulWidget {
  const ConsultEventScreen({
    super.key,
    required this.evento,
  });

  final Evento evento;

  @override
  State<ConsultEventScreen> createState() {
    return _ConsultEventScreenState();
  }
}

class _ConsultEventScreenState extends State<ConsultEventScreen> {
  Evento? evento;
  List<Categoria> categorias = [
    Categoria(1, "Gastronomia", "cor1", "garfo"),
    Categoria(2, "Desporto", "cor2", "futebol"),
    Categoria(3, "Atividade Ar Livre", "cor3", "arvore"),
    Categoria(4, "Alojamento", "cor3", "casa"),
    Categoria(5, "Saúde", "cor3", "cruz"),
    Categoria(6, "Ensino", "cor3", "escola"),
    Categoria(7, "Infraestruturas", "cor3", "infra"),
  ];

  int utilizadorId = 1;

  @override
  void initState() {
    evento = widget.evento;
    super.initState();
  }

  // funcao que verifica se o utilizador pode inscrever-se no evento
  bool podeInscrever(Evento evento) {
    DateTime hoje = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (evento.utilizadorCriou == utilizadorId) {
      return false;
    }

    if (evento.utilizadoresInscritos.contains(utilizadorId)) {
      return false;
    }

    if (evento.dataLimiteInsc.isBefore(hoje)) {
      return false;
    }

    if ((evento.dataLimiteInsc.isAfter(hoje) ||
        evento.dataLimiteInsc.isAtSameMomentAs(hoje))) {
      if (evento.numeroMaxPart == 0) {
        return true;
      } else if (evento.numeroInscritos < evento.numeroMaxPart) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  bool podeCancelar(Evento evento) {
    DateTime hoje = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (evento.utilizadorCriou == utilizadorId) {
      return false;
    }

    if (evento.dataLimiteInsc.isBefore(hoje)) {
      return false;
    }

    if ((evento.dataLimiteInsc.isAfter(hoje) ||
        evento.dataLimiteInsc.isAtSameMomentAs(hoje))) {
      if (evento.numeroMaxPart == 0) {
        return true;
      } else if (evento.numeroInscritos < evento.numeroMaxPart) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }
  //Widget inscreveOuCancela() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.evento,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 15,
          left: 12,
          right: 12,
          bottom: 20,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: categorias
                          .firstWhere(
                            (element) =>
                                element.categoriaId == evento!.categoria,
                          )
                          .getIcone(),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(FontAwesomeIcons.message),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  evento!.titulo,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 75,
                  child: Text(
                    evento!.descricao,
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromRGBO(143, 143, 143, 1)),
                  ),
                ),
                const SizedBox(height: 10),
                FadeInImage(
                  fit: BoxFit.cover,
                  height: 200,
                  width: double.infinity,
                  placeholder: MemoryImage(kTransparentImage),
                  image: NetworkImage(
                      "https://pplware.sapo.pt/wp-content/uploads/2022/02/s_22_plus_1.jpg "),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.calendar,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: Text(
                        evento!.dataFormatada("pt"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.clock,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: Text(
                        evento!.horaFormatada("pt"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.userGroup,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: evento!.numeroMaxPart == 0
                          ? Text(
                              "${evento!.numeroInscritos.toString()}/-",
                            )
                          : Text(
                              "${evento!.numeroInscritos.toString()}/${evento!.numeroMaxPart.toString()}",
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.locationDot,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 12),
                      child: Text(evento!.localizacao),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Botao de inscrever no evento
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: podeInscrever(evento!)
                        ? () {
                            print("inscrever");
                          }
                        : null,
                    child: Text(AppLocalizations.of(context)!.inscrever),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {},
                        child: Text("X onvidados"),
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(FontAwesomeIcons.plus),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(FontAwesomeIcons.minus),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
