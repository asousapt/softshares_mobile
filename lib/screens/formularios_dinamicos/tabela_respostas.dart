import 'package:flutter/material.dart';
import 'package:softshares_mobile/l10n/app_localizations_extension.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/formulario.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/pergunta_formulario.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/resposta_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/models/utilizador.dart';

class TabelaRespostasScreen extends StatefulWidget {
  const TabelaRespostasScreen({
    super.key,
    required this.formularioId,
  });

  final int formularioId;
  @override
  State<StatefulWidget> createState() {
    return _TabelaRespostasScreenState();
  }
}

class _TabelaRespostasScreenState extends State<TabelaRespostasScreen> {
  Formulario? formulario;
  String? tituloForm;
  String? tipoForm;
  List<Pergunta> perguntas = [];
  List<RespostaDetalhe> respostas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFormulario();
    fetchRespostas();
  }

  // Retorna o formulario da API
  Future<void> fetchFormulario() async {
    await Future.delayed(Duration(seconds: 2));
    Formulario fetchedFormulario = Formulario(
      formId: 1,
      titulo: 'Formulário de Teste',
      tipoFormulario: TipoFormulario.inscr,
      perguntas: [
        Pergunta(
          detalheId: 1,
          pergunta: 'Qual é o seu nome?',
          tipoDados: TipoDados.textoLivre,
          obrigatorio: true,
          min: 0,
          max: 0,
          tamanho: 100,
          valoresPossiveis: [],
          ordem: 1,
        ),
        Pergunta(
          detalheId: 2,
          pergunta: 'Qual é a sua idade?',
          tipoDados: TipoDados.numerico,
          obrigatorio: true,
          min: 1,
          max: 120,
          tamanho: 0,
          valoresPossiveis: [],
          ordem: 2,
        ),
        Pergunta(
          detalheId: 3,
          pergunta: 'É vegetariano?',
          tipoDados: TipoDados.logico,
          obrigatorio: false,
          min: 0,
          max: 0,
          tamanho: 0,
          valoresPossiveis: [],
          ordem: 3,
        ),
        Pergunta(
          detalheId: 4,
          pergunta: 'Escolha um horário',
          tipoDados: TipoDados.seleccao,
          obrigatorio: false,
          min: 0,
          max: 0,
          tamanho: 0,
          valoresPossiveis: ['Manhã', 'Tarde', 'Noite'],
          ordem: 4,
        ),
      ],
    );

    setState(() {
      formulario = fetchedFormulario;
      perguntas = fetchedFormulario.perguntas;
      _isLoading = false;
      tituloForm = fetchedFormulario.titulo;
      tipoForm = AppLocalizations.of(context)!
          .getEnumValue(fetchedFormulario.tipoFormulario);
    });
  }

  // Retorna as respostas ao formulario da API
  Future<void> fetchRespostas() async {
    try {
      List<RespostaDetalhe> fetchedRespostas =
          await RespostaDetalhe.getTodasRespostas(
        respostaFormId: widget.formularioId,
      );
      setState(() {
        respostas = fetchedRespostas;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    // Obtem a lista de utilizadores que responderam ao formulario
    Set<int> userIds = {};
    List<Utilizador?> uniqueUsers = [];

    for (var resposta in respostas) {
      if (resposta.utilizador != null &&
          !userIds.contains(resposta.utilizador!.utilizadorId)) {
        userIds.add(resposta.utilizador!.utilizadorId);
        uniqueUsers.add(resposta.utilizador);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.respostaFormulario),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: altura * 0.02, horizontal: largura * 0.02),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).canvasColor,
              ))
            : Container(
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
                        tituloForm ?? '',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        tipoForm ?? '',
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
                                      AppLocalizations.of(context)!.pergunta)),
                              ...uniqueUsers.map(
                                (user) {
                                  return DataColumn(
                                    label: Text(
                                      user?.getNomeCompleto() ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                },
                              ),
                            ],
                            rows: perguntas.map((pergunta) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(
                                    pergunta.pergunta,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )),
                                  ...uniqueUsers.map(
                                    (user) {
                                      String? respostaTexto;
                                      var resposta = respostas.firstWhere(
                                        (r) =>
                                            r.utilizador?.utilizadorId ==
                                                user?.utilizadorId &&
                                            r.perguntaId == pergunta.detalheId,
                                        orElse: () => RespostaDetalhe(
                                            perguntaId: 0,
                                            resposta: '',
                                            utilizador: null),
                                      );
                                      respostaTexto = resposta.resposta;
                                      return DataCell(
                                          Text(respostaTexto ?? ''));
                                    },
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: altura * 0.02),
                      Center(
                          child: FilledButton(
                              onPressed: () {
                                // TDOD: Exportar respostas
                              },
                              child: Text('Exportar'))),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
