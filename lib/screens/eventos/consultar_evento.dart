import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/evento_repository.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/screens/formularios_dinamicos/reposta_form.dart';
import 'package:softshares_mobile/screens/formularios_dinamicos/resposta_individual.dart';
import 'package:softshares_mobile/screens/formularios_dinamicos/tabela_respostas.dart';
import 'package:softshares_mobile/widgets/gerais/galeria_widget.dart';
import 'package:softshares_mobile/widgets/gerais/perfil/custom_tab.dart';

class ConsultEventScreen extends StatefulWidget {
  const ConsultEventScreen({
    super.key,
    required this.evento,
    required this.categorias,
  });

  final List<Categoria> categorias;
  final Evento evento;

  @override
  State<ConsultEventScreen> createState() {
    return _ConsultEventScreenState();
  }
}

class _ConsultEventScreenState extends State<ConsultEventScreen> {
  Evento? evento;
  bool isSecondTabEnabled = false;
  String idioma = "";
  bool _isLoading = true;
  late int utilizadorId;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  // Inicializa o estado do ecrã
  Future<void> initialize() async {
    await getIdioma();
    evento = widget.evento;

    isSecondTabEnabled = evento!.utilizadorCriou == utilizadorId;
    setState(() {
      _isLoading = false;
    });
  }

  // Obtem o idioma e o utilizadorId
  Future<void> getIdioma() async {
    final prefs = await SharedPreferences.getInstance();
    idioma = prefs.getString("idioma") ?? "pt";
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    utilizadorId = utilizador.utilizadorId;
  }

  // renderiza o botao de inscrever, cancelar inscricao ou cancelar evento
  Widget? inscreveOuCancela(Evento evento, double altura) {
    EventoRepository eventoRepository = EventoRepository();
    bool podeCancelarf =
        eventoRepository.podeCancelarInscricao(evento, utilizadorId);
    bool podeInscreverf = eventoRepository.podeInscrever(evento, utilizadorId);
    bool podeCancelarEventof =
        eventoRepository.podeCancelarEvento(evento, utilizadorId);

    if (podeCancelarf == true && podeInscreverf == false) {
      return SizedBox(
        height: altura * 0.065,
        child: FilledButton(
          style:
              ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),
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
          onPressed: () async {
            // faz o processo de inscrição do evento
            setState(() {
              isSaving = true;
            });
            EventoRepository eventoRepository = EventoRepository();
            final int formularioId =
                await eventoRepository.getFormId(evento, "INSCR");
            setState(() {
              isSaving = false;
            });

            if (formularioId != 0) {
              bool inscreveu = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RespostaFormScreen(
                    formularioId: formularioId,
                    evento: evento,
                    tipo: "INSCR",
                  ),
                ),
              );

              if (inscreveu) {
                setState(() {
                  evento.numeroInscritos = evento.numeroInscritos + 1;
                  evento.utilizadoresInscritos!.add(utilizadorId);
                });
              }
            } else {
              setState(() {
                isSaving = true;
              });
              EventoRepository eventoRepository = EventoRepository();
              bool sucesso = await eventoRepository.inscreverEvento(
                  evento, [], utilizadorId, 0);
              setState(() {
                isSaving = false;
              });
              if (sucesso) {
                setState(() {
                  evento.numeroInscritos = evento.numeroInscritos + 1;
                  evento.utilizadoresInscritos!.add(utilizadorId);
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.ocorreuErro,
                    ),
                  ),
                );
              }
            }
          },
          child: Text(AppLocalizations.of(context)!.inscrever),
        ),
      );
    } else if (podeCancelarEventof) {
      return SizedBox(
        height: altura * 0.065,
        child: FilledButton(
          style:
              ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),
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

  Future<List<int>> getUtilizadoresInscritos() async {
    return evento!.utilizadoresInscritos!;
  }

  @override
  Widget build(BuildContext context) {
    List<Categoria> categorias = widget.categorias;
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.evento,
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            top: true,
            bottom: true,
            child: Padding(
              padding: EdgeInsets.only(
                top: altura * 0.02,
                left: largura * 0.02,
                right: largura * 0.02,
                bottom: altura * 0.01,
              ),
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).canvasColor,
                      ),
                    )
                  : Container(
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
                                    text: AppLocalizations.of(context)!
                                        .infoEvento),
                                if (isSecondTabEnabled)
                                  CustomTab(
                                      icon: FontAwesomeIcons.listCheck,
                                      text: AppLocalizations.of(context)!
                                          .gestaoEvento),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: categorias
                                                      .firstWhere(
                                                        (element) =>
                                                            element
                                                                .categoriaId ==
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
                                                  color: Color.fromRGBO(
                                                      143, 143, 143, 1),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: altura * 0.02),
                                            GaleriaWidget(
                                              urls: evento!.imagem != null
                                                  ? evento!.imagem!
                                                  : [],
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
                                                    evento!
                                                        .dataFormatada(idioma),
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
                                                    evento!
                                                        .horaFormatada(idioma),
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
                                                  child:
                                                      evento!.numeroMaxPart == 0
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
                                                  child:
                                                      Text(evento!.localizacao),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: altura * 0.02),
                                            Center(
                                              child: SizedBox(
                                                height: altura * 0.25,
                                                width: largura * 0.85,
                                                child: GoogleMap(
                                                  markers: {
                                                    Marker(
                                                      markerId:
                                                          const MarkerId("1"),
                                                      position: LatLng(
                                                        double.parse(
                                                            evento!.latitude),
                                                        double.parse(
                                                            evento!.longitude),
                                                      ),
                                                    ),
                                                  },
                                                  initialCameraPosition:
                                                      CameraPosition(
                                                    target: LatLng(
                                                      double.parse(
                                                          evento!.latitude),
                                                      double.parse(
                                                          evento!.longitude),
                                                    ),
                                                    zoom: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: altura * 0.02),
                                            // Botao de inscrever no evento
                                            EventoRepository().podeInscrever(
                                                    evento!, utilizadorId)
                                                ? TextFormField(
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .numeroConvidados,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                  )
                                                : const SizedBox(),
                                            SizedBox(height: altura * 0.02),
                                            SizedBox(
                                              height: altura * 0.065,
                                              width: double.infinity,
                                              child: inscreveOuCancela(
                                                  evento!, altura),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Tab de controlo de inscricoes
                                  evento!.utilizadoresInscritos!.isEmpty
                                      ? Center(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .semInscricoes),
                                        )
                                      : Container(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: largura * 0.01,
                                              vertical: altura * 0.02),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                AppLocalizations.of(context)!
                                                    .utilizadoresInscritos,
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(height: altura * 0.02),
                                              Expanded(
                                                child: FutureBuilder(
                                                  future:
                                                      getUtilizadoresInscritos(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Center(
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .ocorreuErro,
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                        .data!.isEmpty) {
                                                      return Center(
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .semInscricoes,
                                                        ),
                                                      );
                                                    } else {
                                                      return ListView.builder(
                                                        itemCount: evento!
                                                            .utilizadoresInscritos!
                                                            .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return ListTile(
                                                            title: Text(
                                                              "Utilizador ${evento!.utilizadoresInscritos![index]}",
                                                            ),
                                                            // TODO: Alterar a imagem do utilizador
                                                            leading:
                                                                CircleAvatar(
                                                              child: Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image:
                                                                      DecorationImage(
                                                                    image: NetworkImage(
                                                                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            trailing:
                                                                IconButton(
                                                              onPressed: () {
                                                                // TODO: Fazer navagacao paraa pagina da resposta deste utilizador

                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            RespostaIndividualScreen(
                                                                      formularioId:
                                                                          1,
                                                                      utilizador:
                                                                          index,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              icon: Icon(
                                                                color: Theme.of(
                                                                        context)
                                                                    .canvasColor,
                                                                FontAwesomeIcons
                                                                    .clipboard,
                                                              ),
                                                              style:
                                                                  ButtonStyle(
                                                                backgroundColor:
                                                                    WidgetStateProperty
                                                                        .all(
                                                                  Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                              Center(
                                                child: FilledButton(
                                                  child: Text(
                                                      "Ver todas as respostas"),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            TabelaRespostasScreen(
                                                          formularioId: 1,
                                                        ),
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
          if (isSaving)
            Opacity(
              opacity: 0.5,
              child: ModalBarrier(
                dismissible: false,
                color: Theme.of(context).canvasColor,
              ),
            ),
          if (isSaving)
            Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
