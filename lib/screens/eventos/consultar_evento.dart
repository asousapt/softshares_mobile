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

    print(evento.dataLimiteInsc);

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
      print("passei aqui");
      if (evento.numeroMaxPart == 0) {
        return true;
      } else if (evento.numeroInscritos < evento.numeroMaxPart) {
        return true;
      } else {
        print("Evento cheio");
        return false;
      }
    }
    return false;
  }

  // Verifica se o utilizador pode cancelar a inscricao no evento
  bool podeCancelar(Evento evento) {
    DateTime hoje = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // utilizador nao pode cancelar se foi o criador do evento
    if (evento.utilizadorCriou == utilizadorId) {
      return false;
    }

    // o evento ja aconteceu
    if (evento.dataLimiteInsc.isBefore(hoje)) {
      return false;
    }

    if (evento.dataLimiteInsc.isAtSameMomentAs(hoje)) {
      return false;
    }

    if (evento.dataLimiteInsc.isAfter(hoje) &&
        !evento.utilizadoresInscritos.contains(utilizadorId)) {
      return false;
    }

    return false;
  }

  Widget? inscreveOuCancela(Evento evento, double altura) {
    bool podeCancelarf = podeCancelar(evento);
    bool podeInscreverf = podeInscrever(evento);
    DateTime hoje = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (podeCancelarf == true && podeInscreverf == false) {
      return SizedBox(
        height: altura * 0.065,
        child: FilledButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          onPressed: () {
            // ToDO: cancelar inscricao
            print("Cancelar inscricao");
          },
          child: Text(
            AppLocalizations.of(context)!.cancelarInscriao,
            style: TextStyle(
              color: Theme.of(context).canvasColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else if (podeInscreverf == true && podeCancelarf == false) {
      return SizedBox(
        height: altura * 0.065,
        child: FilledButton(
          onPressed: () {
            print("inscrever-me");
          },
          child: Text(AppLocalizations.of(context)!.inscrever),
        ),
      );
    } else if (evento.dataLimiteInsc.isAfter(hoje) &&
        evento.utilizadorCriou == utilizadorId) {
      return SizedBox(
        height: altura * 0.065,
        child: FilledButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          onPressed: () {
            print("Cancelar evento");
          },
          child: Text(
              "${AppLocalizations.of(context)!.cancelar} ${AppLocalizations.of(context)!.evento}"),
        ),
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.evento,
        ),
      ),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: EdgeInsets.only(
            top: altura * 0.02,
            left: largura * 0.02,
            right: largura * 0.02,
            bottom: altura * 0.02,
          ),
          child: Container(
            height: altura * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              margin: const EdgeInsets.all(15),
              child: SingleChildScrollView(
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
                    SizedBox(height: altura * 0.02),
                    Text(
                      evento!.titulo,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: altura * 0.02),
                    SizedBox(
                      height: altura * 0.08,
                      child: Text(
                        evento!.descricao,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(143, 143, 143, 1),
                        ),
                      ),
                    ),
                    SizedBox(height: altura * 0.02),
                    Center(
                      child: FadeInImage(
                        fit: BoxFit.cover,
                        height: altura * 0.2,
                        width: largura * 0.85,
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(
                            "https://pplware.sapo.pt/wp-content/uploads/2022/02/s_22_plus_1.jpg "),
                      ),
                    ),
                    SizedBox(height: altura * 0.02),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.calendar,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: largura * 0.02),
                          child: Text(
                            evento!.dataFormatada("pt"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: altura * 0.02),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.clock,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: largura * 0.02),
                          child: Text(
                            evento!.horaFormatada("pt"),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: altura * 0.02),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.userGroup,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: largura * 0.02),
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
                    SizedBox(height: altura * 0.02),
                    Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.locationDot,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: largura * 0.02),
                          child: Text(evento!.localizacao),
                        ),
                      ],
                    ),
                    SizedBox(height: altura * 0.02),
                    Center(
                      child: Container(
                        color: Colors.red,
                        height: altura * 0.25,
                        width: largura * 0.85,
                        child: const Center(
                          child: Text("Mapa"),
                        ),
                      ),
                    ),
                    SizedBox(height: altura * 0.02),
                    // Botao de inscrever no evento
                    SizedBox(
                      height: altura * 0.065,
                      width: double.infinity,
                      child: inscreveOuCancela(evento!, altura),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
