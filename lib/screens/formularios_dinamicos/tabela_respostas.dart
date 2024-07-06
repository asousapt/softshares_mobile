import 'package:flutter/material.dart';
import 'package:softshares_mobile/Repositories/evento_repository.dart';
import 'package:softshares_mobile/Repositories/formulario_repository.dart';
import 'package:softshares_mobile/Repositories/respostadetalhe_repository.dart';
import 'package:softshares_mobile/l10n/app_localizations_extension.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/formulario.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/pergunta_formulario.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/resposta_form.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TabelaRespostasScreen extends StatefulWidget {
  const TabelaRespostasScreen({
    super.key,
    required this.evento,
  });

  final Evento evento;

  @override
  State<StatefulWidget> createState() {
    return _TabelaRespostasScreenState();
  }
}

class _TabelaRespostasScreenState extends State<TabelaRespostasScreen>
    with SingleTickerProviderStateMixin {
  Formulario? formInscr;
  Formulario? formQual;
  String? tituloFormInscr;
  String? tituloFormQual;
  String? tipoFormInscr;
  String? tipoFormQual;
  List<Pergunta> perguntasInscr = [];
  List<Pergunta> perguntasQual = [];
  List<RespostaDetalhe> respostasInscr = [];
  List<RespostaDetalhe> respostasQual = [];
  bool _isLoading = true;
  late TabController _tabController;
  bool _secondTabActivated = false;
  int formInscId = 0;
  int formQualId = 0;
  late Evento evento;

  @override
  void initState() {
    evento = widget.evento;
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchFormularios();
  }

  Future<void> fetchFormularios() async {
    setState(() {
      _isLoading = true;
    });

    try {
      EventoRepository eventoRepository = EventoRepository();
      int formInscIdl = await eventoRepository.getFormId(evento, "INSCR");
      int formQualIdl = await eventoRepository.getFormId(evento, "QUALIDADE");

      setState(() {
        formInscId = formInscIdl;
        formQualId = formQualIdl;
      });

      if (formInscId > 0) {
        FormularioRepository formularioRepository = FormularioRepository();
        Formulario forminscl =
            await formularioRepository.getFormulariobyId(formInscId);
        setState(() {
          formInscr = forminscl;
          perguntasInscr = forminscl.perguntas;
        });
        RespostaDetalheRepository respostaDetalheRepository =
            RespostaDetalheRepository();
        List<RespostaDetalhe> respostasinscL = await respostaDetalheRepository
            .getRespostasTodos(evento.eventoId!, "EVENTO", formInscId);
        setState(() {
          respostasInscr = respostasinscL;
        });
      }

      if (formQualId > 0) {
        FormularioRepository formularioRepository = FormularioRepository();
        Formulario formquall =
            await formularioRepository.getFormulariobyId(formQualId);
        setState(() {
          formQual = formquall;
          perguntasQual = formquall.perguntas;
        });
        RespostaDetalheRepository respostaDetalheRepository =
            RespostaDetalheRepository();
        List<RespostaDetalhe> respostasQualL = await respostaDetalheRepository
            .getRespostasTodos(evento.eventoId!, "EVENTO", formQualId);
        setState(() {
          respostasQual = respostasQualL;
        });
      }
      setState(() {
        tituloFormInscr = formInscr?.titulo;
        tipoFormInscr = AppLocalizations.of(context)!
            .getEnumValue(formInscr!.tipoFormulario!);
        tituloFormQual = formQual?.titulo;
        tipoFormQual = AppLocalizations.of(context)!
            .getEnumValue(formQual!.tipoFormulario!);
      });
    } catch (e) {
      print("Error fetching formularios: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // constroi o conteudo da tabela de respostas
  Widget buildFormContent(
    String? titulo,
    String? tipo,
    List<Pergunta> perguntas,
    List<RespostaDetalhe> respostas,
  ) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    // Collect unique users based on respostas
    Set<int> userIds = {};
    List<Utilizador?> uniqueUsers = [];
    for (var resposta in respostas) {
      if (resposta.utilizador != null &&
          !userIds.contains(resposta.utilizador!.utilizadorId)) {
        userIds.add(resposta.utilizador!.utilizadorId);
        uniqueUsers.add(resposta.utilizador);
      }
    }

    return Container(
      height: altura * 0.9,
      color: Theme.of(context).canvasColor,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: largura * 0.02, horizontal: altura * 0.02),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo ?? '',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              tipo ?? '',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: altura * 0.02),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columns: [
                    DataColumn(
                      label: Text(
                        AppLocalizations.of(context)!.nome,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...perguntas.map(
                      (pergunta) {
                        return DataColumn(
                          label: Text(
                            pergunta.pergunta,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    ).toList(),
                  ],
                  rows: uniqueUsers.map((user) {
                    return DataRow(
                      cells: [
                        DataCell(Text(
                          user?.getNomeCompleto() ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
                        ...perguntas.map(
                          (pergunta) {
                            String? respostaTexto;

                            // Fetch response matching the current user and pergunta
                            var resposta = respostas.firstWhere(
                              (r) =>
                                  r.utilizador?.utilizadorId ==
                                      user?.utilizadorId &&
                                  r.perguntaId == pergunta.detalheId,
                              orElse: () {
                                return RespostaDetalhe(
                                    perguntaId: pergunta.detalheId,
                                    resposta: '',
                                    utilizador: user);
                              },
                            );

                            respostaTexto = resposta.resposta;
                            return DataCell(Text(respostaTexto ?? ''));
                          },
                        ).toList(),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.respostasForm),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: AppLocalizations.of(context)!
                  .getEnumValue(TipoFormulario.inscr),
            ),
            Tab(
              text: AppLocalizations.of(context)!
                  .getEnumValue(TipoFormulario.qualidade),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: altura * 0.02, horizontal: largura * 0.02),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).canvasColor,
              ))
            : TabBarView(
                controller: _tabController,
                children: [
                  buildFormContent(tituloFormInscr, tipoFormInscr,
                      perguntasInscr, respostasInscr),
                  buildFormContent(tituloFormQual, tipoFormQual, perguntasQual,
                      respostasQual),
                ],
              ),
      ),
    );
  }
}

class MultiPage {
  MultiPage({required this.build});

  final List<Widget> Function(BuildContext context) build;

  List<Widget> call(BuildContext context) => build(context);

  static MultiPage fromJson(Map<String, dynamic> json) {
    return MultiPage(
      build: (context) {
        return (json['build'] as List)
            .map((e) => e as Widget)
            .toList(growable: false);
      },
    );
  }
}
