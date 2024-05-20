import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/widgets/gerais/perfil/custom_tab.dart';
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
  bool isSecondTabEnabled = false;

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
    isSecondTabEnabled = evento!.utilizadorCriou == utilizadorId;
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
    return false;
  }

  // Verifica se o utilizador pode cancelar a inscricao no evento
  bool podeCancelarInscricao(Evento evento) {
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

    return true;
  }

  // Verifica se o evento pode ser cancelado pelo seu criador
  bool podeCancelarEvento(Evento evento) {
    DateTime hoje = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    if (evento.dataLimiteInsc.isAfter(hoje) &&
        evento.utilizadorCriou == utilizadorId) {
      return true;
    }
    return false;
  }

  Widget? inscreveOuCancela(Evento evento, double altura) {
    bool podeCancelarf = podeCancelarInscricao(evento);
    bool podeInscreverf = podeInscrever(evento);
    bool podeCancelarEventof = podeCancelarEvento(evento);

    if (podeCancelarf == true && podeInscreverf == false) {
      return SizedBox(
        height: altura * 0.065,
        child: FilledButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          onPressed: () {
            // ToDO: cancelar inscricao
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
            // TODO implementar a inscricao no evento
          },
          child: Text(AppLocalizations.of(context)!.inscrever),
        ),
      );
    } else if (podeCancelarEventof) {
      return SizedBox(
        height: altura * 0.065,
        child: FilledButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red)),
          onPressed: () {
            // TODO: Implementar o cancelamento do evento
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
        bottom: true,
        child: Padding(
          padding: EdgeInsets.only(
            top: altura * 0.02,
            left: largura * 0.02,
            right: largura * 0.02,
            bottom: altura * 0.01,
          ),
          child: Container(
            color: Theme.of(context).canvasColor,
            child: DefaultTabController(
              initialIndex: 0,
              length: isSecondTabEnabled ? 2 : 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TabBar(
                    tabs: [
                      CustomTab(
                          icon: FontAwesomeIcons.info,
                          text: AppLocalizations.of(context)!.infoEvento),
                      if (isSecondTabEnabled)
                        CustomTab(
                            icon: FontAwesomeIcons.listCheck,
                            text: AppLocalizations.of(context)!.gestaoEvento),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Container(
                          height: altura * 0.83,
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
                                                  element.categoriaId ==
                                                  evento!.categoria,
                                            )
                                            .getIcone(),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                            FontAwesomeIcons.message),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  Text(
                                    evento!.titulo,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
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
                                      placeholder:
                                          MemoryImage(kTransparentImage),
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
                                        margin: EdgeInsets.only(
                                            left: largura * 0.02),
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
                                        margin: EdgeInsets.only(
                                            left: largura * 0.02),
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
                                        margin: EdgeInsets.only(
                                            left: largura * 0.02),
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
                                        margin: EdgeInsets.only(
                                            left: largura * 0.02),
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
                        // Tab de controlo de inscricoes
                        evento!.utilizadoresInscritos.isEmpty
                            ? Center(
                                child: Text(AppLocalizations.of(context)!
                                    .semInscricoes),
                              )
                            : Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: largura * 0.01,
                                    vertical: altura * 0.02),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .utilizadoresInscritos,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: altura * 0.02),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: evento!
                                            .utilizadoresInscritos.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(
                                              "Utilizador ${evento!.utilizadoresInscritos[index]}",
                                            ),
                                            // TODO: Alterar a imagem do utilizador
                                            leading: CircleAvatar(
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            trailing: IconButton(
                                              icon: const Icon(FontAwesomeIcons
                                                  .chevronRight),
                                              onPressed: () {
                                                // Navega para o ecrã dos detalhes da inscrição do utilizador
                                                //TODO: Implementar a navegação e ecrã de detalhes da inscrição
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
