import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/formulario.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/pergunta_formulario.dart';
import 'package:softshares_mobile/screens/formularios_dinamicos/nova_pergunta.dart';
import 'package:softshares_mobile/widgets/formularios_dinamicos/pergunta_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../l10n/app_localizations_extension.dart';

class ConfiguracaoFormularioScreen extends StatefulWidget {
  const ConfiguracaoFormularioScreen({
    super.key,
    required this.adicionaFormulario,
    this.formulario,
    required this.formId,
  });

  final bool Function(Formulario form) adicionaFormulario;
  final Formulario? formulario;
  final int formId;

  @override
  State<ConfiguracaoFormularioScreen> createState() {
    return _ConfiguracaoFormularioScreenState();
  }
}

class _ConfiguracaoFormularioScreenState
    extends State<ConfiguracaoFormularioScreen> {
  final TextEditingController _tituloController = TextEditingController();
  List<Pergunta> perguntas = [];
  String titulo = '';
  TipoFormulario? tipoFormulario;

  @override
  void initState() {
    super.initState();
    if (widget.formulario != null) {
      // Initialize with existing form data
      _tituloController.text = widget.formulario!.titulo;
      tipoFormulario = widget.formulario!.tipoFormulario;
      perguntas = List<Pergunta>.from(widget.formulario!.perguntas);
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  // adiciona pergunta à lista de perguntas
  void _adicionaPergunta(Pergunta pergunta) {
    setState(() {
      final index = perguntas.indexWhere((p) => p.ordem == pergunta.ordem);
      if (index >= 0) {
        // modo de edição
        perguntas[index] = pergunta;
      } else {
        // modo de adição
        perguntas.add(pergunta);
      }
    });
  }

  // Navega para o ecrã de nova pergunta
  void _navegaParaNovaPerguntaScreen({Pergunta? pergunta}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NovaPerguntaScreen(
          onAddPergunta: _adicionaPergunta,
          tamanhoLista: perguntas.length,
          pergunta: pergunta, // Pass the existing Pergunta for editing, if any
        ),
      ),
    );

    if (result != null && result is Pergunta) {
      _adicionaPergunta(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.configForm),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: largura * 0.02, vertical: altura * 0.05),
          child: Container(
            height: altura * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: altura * 0.02, horizontal: largura * 0.02),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.configForm,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: altura * 0.02),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.titulo),
                      controller: _tituloController,
                    ),
                    SizedBox(height: altura * 0.02),
                    DropdownButtonFormField<TipoFormulario>(
                      value: tipoFormulario,
                      items: TipoFormulario.values
                          .map(
                            (tipo) => DropdownMenuItem(
                              value: tipo,
                              child: Text(AppLocalizations.of(context)!
                                  .getEnumValue(tipo)),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          tipoFormulario = value!;
                        });
                      },
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.tipoForm),
                    ),
                    SizedBox(height: altura * 0.02),
                    Text(
                      AppLocalizations.of(context)!.perguntas,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: altura * 0.02),
                    Container(
                      height: altura * 0.3,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      child: ListView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: largura * 0.01),
                        itemCount: perguntas.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: PerguntaItem(perguntas[index]),
                            onTap: () => _navegaParaNovaPerguntaScreen(
                                pergunta: perguntas[index]),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: altura * 0.01),
                    IconButton(
                      style: ButtonStyle(
                        iconColor: MaterialStateProperty.all(
                            Theme.of(context).canvasColor),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                      ),
                      onPressed: () => _navegaParaNovaPerguntaScreen(),
                      icon: const Icon(FontAwesomeIcons.plus),
                    ),
                    SizedBox(height: altura * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(AppLocalizations.of(context)!.cancelar),
                        ),
                        SizedBox(width: largura * 0.02),
                        FilledButton(
                          onPressed: () {
                            // Guarda o formulário
                            Formulario formulario = Formulario(
                              titulo: _tituloController.text,
                              tipoFormulario: tipoFormulario!,
                              perguntas: perguntas,
                              formId: widget.formId,
                            );

                            // Adiciona o formulário à lista de formulários
                            if (widget.adicionaFormulario(formulario)) {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.guardar),
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
    );
  }
}
