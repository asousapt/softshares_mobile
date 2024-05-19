import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/l10n/app_localizations_extension.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/pergunta_formulario.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NovaPerguntaScreen extends StatefulWidget {
  const NovaPerguntaScreen({
    super.key,
    required this.onAddPergunta,
    required this.tamanhoLista,
    this.pergunta,
  });

  final void Function(Pergunta pergunta) onAddPergunta;
  final int tamanhoLista;
  final Pergunta? pergunta;

  @override
  State<StatefulWidget> createState() {
    return _NovaPerguntaScreenState();
  }
}

class _NovaPerguntaScreenState extends State<NovaPerguntaScreen> {
  final _perguntaController = TextEditingController();
  final _tamanhoController = TextEditingController();
  final _minController = TextEditingController();
  final _maxController = TextEditingController();
  final _opcaoController = TextEditingController();

  TipoDados tipoDados = TipoDados.textoLivre;
  bool eObrigatorio = false;
  int tamanho = 0;
  List<String> valoresPossiveis = [];

  @override
  void initState() {
    super.initState();
    if (widget.pergunta != null) {
      _perguntaController.text = widget.pergunta!.pergunta;
      tipoDados = widget.pergunta!.tipoDados;
      eObrigatorio = widget.pergunta!.obrigatorio;
      _minController.text = widget.pergunta!.min.toString();
      _maxController.text = widget.pergunta!.max.toString();
      _tamanhoController.text = widget.pergunta!.tamanho.toString();
      valoresPossiveis = List.from(widget.pergunta!.valoresPossiveis);
    }
  }

  // Widget de seleção de opções
  Widget buildSeleccaoWidget(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _opcaoController,
          decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.adicionarOpcao),
          onChanged: (value) {
            ScaffoldMessenger.of(context).clearSnackBars();
          },
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: altura * 0.02),
        FilledButton(
          onPressed: () {
            if (_opcaoController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "${AppLocalizations.of(context)!.porfavorInsiraA}${AppLocalizations.of(context)!.opcao}"),
                ),
              );
            } else {
              setState(() {
                valoresPossiveis.add(_opcaoController.text);
                _opcaoController.clear();
              });
            }
          },
          child: Text(AppLocalizations.of(context)!.adicionarOpcao),
        ),
        SizedBox(height: altura * 0.02),
        Text(AppLocalizations.of(context)!.opcoes),
        SizedBox(height: altura * 0.02),
        Container(
          height: altura * 0.20,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor,
            ),
          ),
          child: ListView.builder(
            itemCount: valoresPossiveis.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(valoresPossiveis[index]),
                trailing: IconButton(
                  icon: const Icon(FontAwesomeIcons.trashCan),
                  onPressed: () {
                    setState(() {
                      valoresPossiveis.removeAt(index);
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget de texto livre
  Widget buildTextoLivreWidget(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: _tamanhoController,
      decoration: InputDecoration(
        label: Text(AppLocalizations.of(context)!.tamanho),
      ),
    );
  }

  Widget buildNumericoWidget(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;

    return Column(
      children: [
        TextFormField(
          controller: _minController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.minimo,
          ),
        ),
        SizedBox(
          height: altura * 0.02,
        ),
        TextFormField(
          controller: _maxController,
          keyboardType: TextInputType.number,
          decoration:
              InputDecoration(labelText: AppLocalizations.of(context)!.maximo),
        )
      ],
    );
  }

  Widget buildLogicoWidget(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    return SizedBox(height: altura * 0.02);
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    Widget? content;

    switch (tipoDados) {
      case TipoDados.logico:
        content = buildLogicoWidget(context);
        break;
      case TipoDados.textoLivre:
        content = buildTextoLivreWidget(context);
        break;
      case TipoDados.numerico:
        content = buildNumericoWidget(context);
        break;
      case TipoDados.seleccao:
        content = buildSeleccaoWidget(context);
        break;
      default:
        content = SizedBox(
          height: altura * 0.02,
        );
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.novaPergunta),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: largura * 0.02, vertical: altura * 0.02),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(20),
            ),
            height: altura * 0.9,
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: altura * 0.02, horizontal: largura * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  TextFormField(
                    maxLength: 140,
                    decoration: InputDecoration(
                        label: Text(AppLocalizations.of(context)!.pergunta)),
                    controller: _perguntaController,
                  ),
                  SizedBox(height: altura * 0.02),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Theme.of(context).primaryColor,
                        value: eObrigatorio,
                        onChanged: (bool? value) {
                          setState(() {
                            eObrigatorio = value!;
                          });
                        },
                      ),
                      SizedBox(
                        width: largura * 0.02,
                      ),
                      Text(AppLocalizations.of(context)!.obrigatorio),
                    ],
                  ),
                  SizedBox(height: altura * 0.02),
                  DropdownButtonFormField<TipoDados>(
                    value: tipoDados,
                    items: TipoDados.values
                        .map((tipo) => DropdownMenuItem(
                            value: tipo,
                            child: Text(
                              AppLocalizations.of(context)!
                                  .getTipoDadosValue(tipo),
                            )))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        tipoDados = value!;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.tipoDados),
                  ),
                  SizedBox(height: altura * 0.02),
                  content ?? SizedBox(height: altura * 0.02),
                  SizedBox(height: altura * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.cancelar),
                      ),
                      SizedBox(width: largura * 0.02),
                      FilledButton(
                        onPressed: () {
                          // validacao dos campos antes de gravar
                          if (_perguntaController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!
                                        .porfavorInsiraA +
                                    AppLocalizations.of(context)!.pergunta),
                              ),
                            );
                            return;
                          }

                          switch (tipoDados) {
                            case TipoDados.textoLivre:
                              if (_tamanhoController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                            .porfavorInsiraA +
                                        AppLocalizations.of(context)!.tamanho),
                                  ),
                                );
                                return;
                              }
                              break;
                            case TipoDados.numerico:
                              if (_minController.text.isEmpty ||
                                  _maxController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "${AppLocalizations.of(context)!.porfavorInsiraO}${AppLocalizations.of(context)!.minimo}/${AppLocalizations.of(context)!.maximo}"),
                                  ),
                                );
                                return;
                              }
                              break;
                            case TipoDados.seleccao:
                              if (valoresPossiveis.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(AppLocalizations.of(context)!
                                        .listaOpcoesVazia),
                                  ),
                                );
                                return;
                              }
                            default:
                              return;
                          }
                          final ordem =
                              widget.pergunta?.ordem ?? widget.tamanhoLista + 1;
                          widget.onAddPergunta(Pergunta(
                            pergunta: _perguntaController.text,
                            tipoDados: tipoDados,
                            obrigatorio: eObrigatorio,
                            min: _minController.text.isEmpty
                                ? 0
                                : int.parse(_minController.text),
                            max: _maxController.text.isEmpty
                                ? 0
                                : int.parse(_maxController.text),
                            tamanho: _tamanhoController.text.isEmpty
                                ? 0
                                : int.parse(_tamanhoController.text),
                            valoresPossiveis: tipoDados == TipoDados.seleccao
                                ? valoresPossiveis
                                : [],
                            ordem: ordem,
                          ));
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.guardar),
                      )
                    ],
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
