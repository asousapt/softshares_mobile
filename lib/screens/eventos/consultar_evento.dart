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
  bool temFormularios = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  // Inicializa o estado do ecrã
  Future<void> initialize() async {
    await getIdioma();
    evento = widget.evento;
    temFormularios = await temFormularios1();
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

  Future<Widget>? inscreveOuCancela(Evento evento, double altura) async {
    EventoRepository eventoRepository = EventoRepository();

    bool respondeFormQualidade = await eventoRepository
        .podeResponderQuestQualidade(evento, utilizadorId);

    bool podeCancelarf =
        await eventoRepository.podeCancelarInscricao(evento, utilizadorId);

    bool podeInscreverf =
        await eventoRepository.podeInscrever(evento, utilizadorId);

    bool podeCancelarEventof =
        await eventoRepository.podeCancelarEvento(evento, utilizadorId);

    if (podeCancelarf == true &&
        podeInscreverf == false &&
        respondeFormQualidade == false) {
      return SizedBox(
        height: altura * 0.065,
        child: FilledButton(
          style:
              ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),
          onPressed: () async {
            // cancelar inscricao
            EventoRepository eventoRepository = EventoRepository();
            await eventoRepository.cancelarInscricao(
                evento.eventoId!, utilizadorId);
            setState(() {
              evento.numeroInscritos = evento.numeroInscritos - 1;
              evento.utilizadoresInscritos!.remove(utilizadorId);
            });
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
    } else if (podeInscreverf == true &&
        podeCancelarf == false &&
        respondeFormQualidade == false) {
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
    } else if (podeCancelarEventof && evento.cancelado == false) {
      return SizedBox(
        height: altura * 0.065,
        child: FilledButton(
          style:
              ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.red)),
          onPressed: () async {
            // Cancelamento do evento pelo owner
            setState(() {
              isSaving = true;
            });
            EventoRepository eventoRepository = EventoRepository();
            await eventoRepository.cancelarEvento(evento.eventoId!);
            setState(() {
              isSaving = false;
              evento.cancelado = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.eventoCancelado,
                ),
              ),
            );
          },
          child: Text(
              "${AppLocalizations.of(context)!.cancelar} ${AppLocalizations.of(context)!.evento}"),
        ),
      );
    } else if (evento.cancelado == false &&
        podeInscreverf == false &&
        podeCancelarf == false &&
        respondeFormQualidade == true) {
      return SizedBox(
        height: altura * 0.065,
        child: FilledButton(
          onPressed: () async {
            // navega para o ecrã de resposta ao form de qualidade caso exista
            setState(() {
              isSaving = true;
            });
            EventoRepository eventoRepository = EventoRepository();
            final int formularioId =
                await eventoRepository.getFormId(evento, "QUALIDADE");
            setState(() {
              isSaving = false;
            });
            bool respondeu = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RespostaFormScreen(
                    formularioId: formularioId,
                    evento: evento,
                    tipo: "QUALIDADE"),
              ),
            );
            print("respondeu: $respondeu");
            if (respondeu) {
              setState(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.dadosGravados,
                    ),
                  ),
                );
              });
            }
          },
          child: Text(AppLocalizations.of(context)!.questionarioQualidade),
        ),
      );
    } else if (evento.cancelado == true) {
      return SizedBox(
        height: altura * 0.065,
        child: FilledButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.eventoCancelado,
                ),
              ),
            );
          },
          child: Text(AppLocalizations.of(context)!.eventoCancelado),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Future<List<Utilizador>> getUtilizadoresInscritos(int eventoId) async {
    EventoRepository eventoRepository = EventoRepository();
    return eventoRepository.getUtilizadoresInscritos(eventoId);
  }

  // verifica se tem formularios de inscricao e qualidade
  Future<bool> temFormularios1() async {
    EventoRepository eventoRepository = EventoRepository();
    int inscricao = await eventoRepository.getFormId(evento!, "INSCR");
    int qualidade = await eventoRepository.getFormId(evento!, "QUALIDADE");
    return inscricao != 0 || qualidade != 0;
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
                                              child: FutureBuilder(
                                                  future: inscreveOuCancela(
                                                      evento!, altura),
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
                                                    } else {
                                                      return snapshot.data
                                                          as Widget;
                                                    }
                                                  }),
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
                                                      getUtilizadoresInscritos(
                                                          evento!.eventoId!),
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
                                                              snapshot
                                                                  .data![index]
                                                                  .getNomeCompleto(),
                                                            ),
                                                            leading: snapshot
                                                                        .data![
                                                                            index]
                                                                        .fotoUrl ==
                                                                    null
                                                                ? CircleAvatar(
                                                                    backgroundColor:
                                                                        Theme.of(context)
                                                                            .secondaryHeaderColor,
                                                                    child:
                                                                        Center(
                                                                      child: Text(snapshot
                                                                          .data![
                                                                              index]
                                                                          .getIniciais()),
                                                                    ),
                                                                  )
                                                                : CircleAvatar(
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        image:
                                                                            DecorationImage(
                                                                          image:
                                                                              NetworkImage(snapshot.data![index].fotoUrl ?? ""),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                            trailing: temFormularios
                                                                ? IconButton(
                                                                    onPressed:
                                                                        () {
                                                                      // navega para o ecrã de respostas individuais
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              RespostaIndividualScreen(
                                                                            evento:
                                                                                evento!,
                                                                            utilizador:
                                                                                snapshot.data![index].utilizadorId,
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
                                                                        Theme.of(context)
                                                                            .primaryColor,
                                                                      ),
                                                                    ),
                                                                  )
                                                                : const SizedBox(),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                              temFormularios
                                                  ? Center(
                                                      child: FilledButton(
                                                        child: Text(
                                                            AppLocalizations.of(
                                                                    context)!
                                                                .verTodasRespostas),
                                                        onPressed: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TabelaRespostasScreen(
                                                                evento: evento!,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : const SizedBox(),
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
