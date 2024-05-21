import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/formulario.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/pergunta_formulario.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/models/resposta_form.dart';
import 'package:softshares_mobile/widgets/gerais/dialog.dart';

class RespostaFormScreen extends StatefulWidget {
  const RespostaFormScreen({
    super.key,
    required this.formularioId,
    this.evento,
  });

  final int formularioId;
  final Evento? evento;

  @override
  State<StatefulWidget> createState() {
    return _RespostaFormScreenState();
  }
}

class _RespostaFormScreenState extends State<RespostaFormScreen> {
  Formulario? formulario;
  List<Pergunta> perguntas = [];
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final Map<int, TextEditingController> _controllers = {};
  final Map<int, bool> _booleanValues = {};
  final Map<int, String?> _dropdownValues = {};

  // Funcao para buscar o formulario
  Future<void> fetchFormulario() async {
    // Simulate a network call
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

      for (int i = 0; i < perguntas.length; i++) {
        if (perguntas[i].tipoDados == TipoDados.textoLivre ||
            perguntas[i].tipoDados == TipoDados.numerico) {
          _controllers[i] = TextEditingController();
        }
        if (perguntas[i].tipoDados == TipoDados.logico) {
          _booleanValues[i] = false;
        }
        if (perguntas[i].tipoDados == TipoDados.seleccao) {
          _dropdownValues[i] = null;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchFormulario();
  }

  // Faz o build das perguntas do formulário
  List<Widget> _buildPerguntas(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    List<Widget> widgets = [];

    for (int index = 0; index < perguntas.length; index++) {
      Pergunta pergunta = perguntas[index];

      Widget field;

      switch (pergunta.tipoDados) {
        case TipoDados.logico:
          field = SwitchListTile(
            title: Text(pergunta.pergunta),
            value: _booleanValues[index]!,
            onChanged: (bool value) {
              setState(() {
                _booleanValues[index] = value;
              });
            },
          );
          break;

        case TipoDados.textoLivre:
          field = TextFormField(
            decoration: InputDecoration(labelText: pergunta.pergunta),
            controller: _controllers[index],
            maxLength: pergunta.tamanho,
            validator: (value) {
              if (pergunta.obrigatorio && (value == null || value.isEmpty)) {
                return AppLocalizations.of(context)!.campoObrigatorio;
              }
              return null;
            },
          );
          break;

        case TipoDados.numerico:
          field = TextFormField(
            decoration: InputDecoration(labelText: pergunta.pergunta),
            keyboardType: TextInputType.number,
            controller: _controllers[index],
            validator: (value) {
              if (pergunta.obrigatorio && (value == null || value.isEmpty)) {
                return AppLocalizations.of(context)!.campoObrigatorio;
              }
              if (value != null) {
                final numValue = double.tryParse(value);
                if (numValue == null) {
                  return 'Valor inválido';
                }
                if (numValue < pergunta.min || numValue > pergunta.max) {
                  return 'Valor deve estar entre ${pergunta.min} e ${pergunta.max}';
                }
              }
              return null;
            },
          );
          break;

        case TipoDados.seleccao:
          field = DropdownButtonFormField<String>(
            decoration: InputDecoration(labelText: pergunta.pergunta),
            value: _dropdownValues[index],
            items: pergunta.valoresPossiveis.map((valor) {
              return DropdownMenuItem<String>(
                value: valor,
                child: Text(valor),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _dropdownValues[index] = value;
              });
            },
            validator: (value) {
              if (pergunta.obrigatorio && (value == null || value.isEmpty)) {
                return AppLocalizations.of(context)!.campoObrigatorio;
              }
              return null;
            },
          );
          break;

        default:
          field = Container();
      }

      widgets.add(field);

      // Aiciona um espaço a seguir a cada campo, exceto o último
      if (index < perguntas.length - 1) {
        widgets.add(SizedBox(height: altura * 0.02));
      }
    }

    return widgets;
  }

  // funcao que faz a leitara das respostas do formulario
  List<RespostaDetalhe> getRespostas() {
    List<RespostaDetalhe> respostas = [];

    for (int index = 0; index < perguntas.length; index++) {
      Pergunta pergunta = perguntas[index];

      switch (pergunta.tipoDados) {
        case TipoDados.logico:
          respostas.add(RespostaDetalhe(
            perguntaId: pergunta.detalheId,
            resposta: _booleanValues[index]!
                ? AppLocalizations.of(context)!.yes
                : AppLocalizations.of(context)!.no,
          ));
          break;

        case TipoDados.textoLivre:
        case TipoDados.numerico:
          respostas.add(RespostaDetalhe(
            perguntaId: pergunta.detalheId,
            resposta: _controllers[index]!.text,
          ));
          break;

        case TipoDados.seleccao:
          respostas.add(RespostaDetalhe(
            perguntaId: pergunta.detalheId,
            resposta: _dropdownValues[index]!,
          ));
          break;

        default:
      }
    }
    return respostas;
  }

  bool validaFormsTemDados() {
    for (int index = 0; index < perguntas.length; index++) {
      Pergunta pergunta = perguntas[index];

      switch (pergunta.tipoDados) {
        case TipoDados.logico:
          if (_booleanValues[index] != null) {
            return true;
          }
          break;

        case TipoDados.textoLivre:
        case TipoDados.numerico:
          if (_controllers[index]!.text.isNotEmpty) {
            return true;
          }
          break;
        case TipoDados.seleccao:
          if (_dropdownValues[index] != null) {
            return true;
          }
          break;

        default:
          return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (validaFormsTemDados()) {
            Future<bool> confirma = confirmExit(
              context,
              AppLocalizations.of(context)!.sairSemGuardar,
              AppLocalizations.of(context)!.dadosSeraoPerdidos,
            );

            confirma.then((value) {
              if (value) {
                Navigator.of(context).pop();
              }
            });
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Resposta')),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: largura * 0.02, vertical: altura * 0.02),
          child: _isLoading
              ? Container(
                  height: altura * 0.9,
                  color: Theme.of(context).canvasColor,
                  child: const Center(child: CircularProgressIndicator()))
              : Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Container(
                      color: Theme.of(context).canvasColor,
                      height: altura * 0.9,
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: largura * 0.02,
                            vertical: altura * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              formulario!.titulo,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: altura * 0.02),
                            ..._buildPerguntas(context),
                            SizedBox(height: altura * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (validaFormsTemDados()) {
                                      Future<bool> confirma = confirmExit(
                                        context,
                                        AppLocalizations.of(context)!
                                            .sairSemGuardar,
                                        AppLocalizations.of(context)!
                                            .dadosSeraoPerdidos,
                                      );

                                      confirma.then((value) {
                                        if (value) {
                                          Navigator.of(context).pop();
                                        }
                                      });
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.cancelar),
                                ),
                                SizedBox(width: largura * 0.02),
                                FilledButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      // formulario foi validado
                                      // TODO: fazer o envio dos dados para a API e sair para outro ecra
                                      List<RespostaDetalhe> respostaF =
                                          getRespostas();

                                      if (widget.evento != null) {
                                        // Se o evento for fornecido, então estamos a responder a um formulário de evento
                                        Navigator.pushReplacementNamed(
                                            context, '/eventos');
                                      }
                                    }
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.guardar),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
