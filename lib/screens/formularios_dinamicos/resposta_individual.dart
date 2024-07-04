import 'package:flutter/material.dart';
import 'package:softshares_mobile/l10n/app_localizations_extension.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/pergunta_formulario.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/formulario.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/resposta_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RespostaIndividualScreen extends StatefulWidget {
  const RespostaIndividualScreen({
    super.key,
    required this.formularioId,
    required this.utilizador,
  });

  final int formularioId;
  final int utilizador;

  @override
  State<StatefulWidget> createState() {
    return _RespostaIndividualScreenState();
  }
}

class _RespostaIndividualScreenState extends State<RespostaIndividualScreen> {
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
          .getEnumValue(fetchedFormulario.tipoFormulario!);
    });
  }

  // Retorna as respostas ao formulario da API
  Future<void> fetchRespostas() async {
    try {
      List<RespostaDetalhe> fetchedRespostas =
          await RespostaDetalhe.getRespostasDetalhe(
        utilizadorId: widget.utilizador,
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

    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.respostaFormulario)),
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
                      vertical: altura * 0.02, horizontal: largura * 0.02),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tituloForm ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(tipoForm ?? ''),
                      SizedBox(height: altura * 0.02),
                      Expanded(
                        child: ListView.builder(
                          itemCount: respostas.length,
                          itemBuilder: (context, index) {
                            RespostaDetalhe resposta = respostas[index];
                            return ListTile(
                              title: Text(
                                resposta.pergunta?.pergunta ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(resposta.resposta),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
