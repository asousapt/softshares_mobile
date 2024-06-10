import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/l10n/app_localizations_extension.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/formulario.dart';
import 'package:softshares_mobile/models/subcategoria.dart';
import 'package:softshares_mobile/screens/formularios_dinamicos/formulario_cfg.dart';
import '../../time_utils.dart';
import 'package:softshares_mobile/widgets/gerais/dialog.dart';

class CriarPontoInteresseScreen extends StatefulWidget {
  const CriarPontoInteresseScreen({super.key});

  @override
  State<CriarPontoInteresseScreen> createState() {
    return _CriarPontoInteresseScreen();
  }
}

class _CriarPontoInteresseScreen extends State<CriarPontoInteresseScreen> {
  final _tituloController = TextEditingController();
  final _localizacaoController = TextEditingController();
  final _descricao = TextEditingController();
  String? _categoriaId;
  String? _subCategoriaId;
  String? descricao;
  List<Formulario> forms = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// Lista de categorias a substituir por dados vindos da BD ou chamada API
  List<Categoria> categorias = [
    Categoria(1, "Gastronomia", "cor1", "garfo"),
    Categoria(2, "Desporto", "cor2", "futebol"),
    Categoria(3, "Atividade Ar Livre", "cor3", "arvore"),
    Categoria(4, "Alojamento", "cor3", "casa"),
    Categoria(5, "Saúde", "cor3", "cruz"),
    Categoria(6, "Ensino", "cor3", "escola"),
    Categoria(7, "Infraestruturas", "cor3", "infra"),
  ];

  List<Subcategoria> subcategorias = [
    // Subcategories for "Gastronomia" category
    Subcategoria(1, 1, "Comida italiana"),
    Subcategoria(2, 1, "Comida mexicana"),
    Subcategoria(3, 1, "Comida japonesa"),

    // Subcategories for "Desporto" category
    Subcategoria(4, 2, "Futebol"),
    Subcategoria(5, 2, "Basquetebol"),
    Subcategoria(6, 2, "Ténis"),

    // Subcategories for "Atividade Ar Livre" category
    Subcategoria(7, 3, "Caminhada"),
    Subcategoria(8, 3, "Ciclismo"),

    // Subcategories for "Alojamento" category
    Subcategoria(9, 4, "Hotel"),
    Subcategoria(10, 4, "Hostel"),
    Subcategoria(11, 4, "Apartamento"),

    // Subcategories for "Saúde" category
    Subcategoria(12, 5, "Médico geral"),
    Subcategoria(13, 5, "Dentista"),
    Subcategoria(14, 5, "Fisioterapia"),

    // Subcategories for "Ensino" category
    Subcategoria(15, 6, "Escola primária"),
    Subcategoria(16, 6, "Escola secundária"),
    Subcategoria(17, 6, "Universidade"),

    // Subcategories for "Infraestruturas" category
    Subcategoria(18, 7, "Transporte público"),
    Subcategoria(19, 7, "Estradas"),
    Subcategoria(20, 7, "Rede de água e saneamento"),
  ];

  @override
  void initState() {
    super.initState();
    _categoriaId = categorias[0].categoriaId.toString();
    _subCategoriaId = subcategorias[0].subcategoriaId.toString();
    descricao = "";
    forms = [];
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _localizacaoController.dispose();
    _descricao.dispose();
    super.dispose();
  }

  /* Seçao de adicionar formulario à lista */

  bool _adicionaFormulario(Formulario formulario) {
    // verifica se o formulário já existe na lista
    final index = forms.indexWhere((form) => form.formId == formulario.formId);
    print(index);

    if (index != -1) {
      // A editar um formulário existente
      setState(() {
        forms[index] = formulario;
      });
      return true;
    } else {
      // Adicionar um novo formulário
      if (forms.isEmpty) {
        setState(() {
          forms.add(formulario);
        });
        return true;
      } else if (forms.length == 1) {
        // Verifica se o formulário a adicionar é do mesmo tipo que o existente
        if (forms[0].tipoFormulario == formulario.tipoFormulario) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.naoPodeAdicionarForm),
            ),
          );
          return false;
        } else {
          setState(() {
            forms.add(formulario);
          });
          return true;
        }
      }
      return true;
    }
  }

  /* Fim Seçao de adicionar formulario à lista */

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (_tituloController.text.isNotEmpty ||
              _localizacaoController.text.isNotEmpty ||
              _categoriaId!.isNotEmpty ||
              _subCategoriaId!.isNotEmpty ||
              _descricao.text.isNotEmpty) {
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
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.criarPontoInteresse,
          ),
        ),
        body: SafeArea(
          top: true,
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: largura * 0.02, vertical: altura * 0.02),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    margin: const EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!
                                  .inputPontosInteresse,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: altura * 0.02),
                            TextFormField(
                              maxLength: 160,
                              controller: _tituloController,
                              decoration: InputDecoration(
                                label:
                                    Text(AppLocalizations.of(context)!.titulo),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "${AppLocalizations.of(context)!.porfavorInsiraO} ${AppLocalizations.of(context)!.titulo}";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              maxLength: 160,
                              controller: _localizacaoController,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    //TODO: Implementar a selecção de localização do mapa
                                  },
                                  icon:
                                      const Icon(FontAwesomeIcons.locationDot),
                                ),
                                label: Text(
                                    AppLocalizations.of(context)!.localizacao),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "${AppLocalizations.of(context)!.porfavorInsiraA} ${AppLocalizations.of(context)!.localizacao}";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: altura * 0.02),
                            // Selecção de categoria
                            DropdownButtonFormField(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              hint:
                                  Text(AppLocalizations.of(context)!.categoria),
                              isExpanded: true,
                              value: _categoriaId.toString(),
                              items: getListaCatDropdown(categorias),
                              onChanged: (value) {
                                setState(
                                  () {
                                    _categoriaId = value;
                                    _subCategoriaId = subcategorias
                                        .where((e) =>
                                            e.categoriaId == int.parse(value))
                                        .first
                                        .subcategoriaId
                                        .toString();
                                  },
                                );
                              },
                            ),
                            SizedBox(height: altura * 0.02),
                            //selecção de subcategoria
                            DropdownButton(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              borderRadius: BorderRadius.circular(20),
                              hint: Text(
                                  AppLocalizations.of(context)!.subCategoria),
                              isExpanded: true,
                              value: _subCategoriaId.toString(),
                              items: getListaSubCatDropdown(
                                  subcategorias, int.parse(_categoriaId!)),
                              onChanged: (value) {
                                setState(
                                  () {
                                    _subCategoriaId = value;
                                  },
                                );
                              },
                            ),
                            SizedBox(height: altura * 0.02),
                            TextFormField(
                              controller: _descricao,
                              decoration: InputDecoration(
                                label: Text(
                                    AppLocalizations.of(context)!.descricao),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  descricao = value;
                                });
                              },
                              validator: (value) => value!.isEmpty
                                  ? "${AppLocalizations.of(context)!.porfavorInsiraA}${AppLocalizations.of(context)!.descricao}"
                                  : null,
                            ),
                            SizedBox(height: altura * 0.02),
                            // LISTA DE FORMULARIOS
                            forms.isNotEmpty
                                ? Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        for (var form in forms)
                                          ListTile(
                                            title: Text(form.titulo),
                                            trailing: IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                setState(() {
                                                  forms.remove(form);
                                                });
                                              },
                                            ),
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ConfiguracaoFormularioScreen(
                                                    adicionaFormulario:
                                                        _adicionaFormulario,
                                                    formulario: form,
                                                    formId: form.formId,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(height: 0),
                            SizedBox(height: altura * 0.02),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    if (_tituloController.text.isNotEmpty ||
                                        _localizacaoController
                                            .text.isNotEmpty ||
                                        _categoriaId!.isNotEmpty ||
                                        _subCategoriaId!.isNotEmpty ||
                                        _descricao.text.isNotEmpty) {
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
                                    String mensagem = "";

                                    if (forms.isEmpty) {
                                      mensagem = AppLocalizations.of(context)!
                                          .criarEventoSemForms;
                                    } else if (forms.length == 1) {
                                      mensagem = AppLocalizations.of(context)!
                                          .maisForms;
                                    }

                                    if (forms.isEmpty || forms.length == 1) {
                                      Future<bool> confirma = confirmExit(
                                        context,
                                        AppLocalizations.of(context)!
                                            .criarPontoInteresse,
                                        mensagem,
                                      );

                                      confirma.then((value) => {
                                            if (value)
                                              {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ConfiguracaoFormularioScreen(
                                                      adicionaFormulario:
                                                          _adicionaFormulario,
                                                      formId: forms.isEmpty
                                                          ? 1
                                                          : forms.last.formId +
                                                              1,
                                                    ),
                                                  ),
                                                )
                                              }
                                            else
                                              {
                                                // TODO: IMPLEMENTAR ENVIO
                                              }
                                          });
                                    } else {
                                      // TODO: IMPLEMENTAR ENVIO
                                      for (var form in forms) {
                                        print(form.titulo);
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
