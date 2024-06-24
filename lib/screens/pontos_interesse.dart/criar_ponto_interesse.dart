/*import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/categoria_repository.dart';
import 'package:softshares_mobile/Repositories/subcategoria_repository.dart';
import 'package:softshares_mobile/l10n/app_localizations_extension.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/formulario.dart';
import 'package:softshares_mobile/models/ponto_de_interesse.dart';
import 'package:softshares_mobile/models/subcategoria.dart';
import 'package:softshares_mobile/screens/formularios_dinamicos/formulario_cfg.dart';
import 'package:softshares_mobile/time_utils.dart';
import 'package:softshares_mobile/widgets/gerais/dialog.dart';
import 'package:softshares_mobile/services/api_service.dart';

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
  bool defaultValues = false;
  List<Categoria> categorias = [];
  List<Subcategoria> subcategorias = [];
  ApiService api = ApiService();
  bool _isLoading = true;
  late PontoInteresse novoPonto;
  

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// Lista de categorias a substituir por dados vindos da BD ou chamada API

  @override
  void initState() {
    super.initState();
    api.setAuthToken('tokenFixo');
    if (defaultValues) {
      categorias = categoriasTeste;
      _categoriaId = categorias[0].categoriaId.toString();
      subcategorias = subcategoriasTeste;
    } else {
      _initializeData();
    }
    descricao = "";
    forms = [];
  }

  void _initializeData() async {
    _isLoading = true;
    await fetchCategorias();
    await fetchSubCategorias();
    if (mounted) {
      setState(() {
        _categoriaId =
            categorias.isNotEmpty ? categorias[0].categoriaId.toString() : '';
        _subCategoriaId = subcategorias.isNotEmpty
            ? subcategorias[0].subcategoriaId.toString()
            : '';
      });
    }
    _isLoading = false;
  }

  Future<void> fetchCategorias() async {
    try {
      final lista = await api.getRequest('categoria/');

      List<Categoria> listaUpdated =
          (lista as List).map((item) => Categoria.fromJson(item)).toList();

      setState(() {
        categorias = List.from(listaUpdated);
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  Future<void> fetchSubCategorias() async {
    try {
      final lista = await api.getRequest('subcategoria/');

      List<Subcategoria> listaUpdated =
          (lista as List).map((item) => Subcategoria.fromJson(item)).toList();

      setState(() {
        subcategorias = List.from(listaUpdated);
      });
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  String createMensagem(BuildContext context) {
    final String titulo = _tituloController.text;
    final String descricao = _descricao.text;
    final String local = _localizacaoController.text;
    final String? cat = _categoriaId;
    final String? sub = _subCategoriaId;

    String mensagem = "${AppLocalizations.of(context)!.titulo} : $titulo \n"
        "${AppLocalizations.of(context)!.localizacao} : $local \n"
        "${AppLocalizations.of(context)!.descricao} : $descricao \n"
        "${AppLocalizations.of(context)!.categoria} : $cat\n"
        "${AppLocalizations.of(context)!.subCategoria} : $sub\n";

    return mensagem;
  }

  Map<String, dynamic> createJson() {
    final String titulo = _tituloController.text;
    final String descricao = _descricao.text;
    final String local = _localizacaoController.text;
    final int cat = int.parse(_categoriaId!);
    final int sub = int.parse(_subCategoriaId!);
    final Map<String, dynamic> data = {
      "subcategoriaid": sub,
      "titulo": titulo,
      "descricao": descricao,
      "localizacao": local,
      "latitude": "0",
      "longitude": "0",
      "idiomaid": 1,
      "cidadeid": 299,
      "utilizadorcriou": 14,
      "imagens": []
    };

    return data;
  }

  void sendData() {
    String mensagem = createMensagem(context);

    Map<String, dynamic> json = createJson();

    if (forms.isEmpty || forms.length == 1) {
      Future<bool> confirma = confirmExit(
        context,
        AppLocalizations.of(context)!.criarPontoInteresse,
        mensagem,
      );

      confirma.then((value) => {
            if (value)
              {api.postRequest('pontoInteresse/add', json)}
          });
    } else {
      // TODO: IMPLEMENTAR ENVIO
      for (var form in forms) {
        print(form.titulo);
      }
    }
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
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : categorias.isEmpty
                ? Container(
                    height: altura * 0.8,
                    color: Colors.transparent,
                    child: Center(
                      child: Column(
                        children: [
                          Text(AppLocalizations.of(context)!.naoHaDados),
                        ],
                      ),
                    ),
                  )
                : SafeArea(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .inputPontosInteresse,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: altura * 0.02),
                                      TextFormField(
                                        maxLength: 160,
                                        controller: _tituloController,
                                        decoration: InputDecoration(
                                          label: Text(
                                              AppLocalizations.of(context)!
                                                  .titulo),
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
                                            icon: const Icon(
                                                FontAwesomeIcons.locationDot),
                                          ),
                                          label: Text(
                                              AppLocalizations.of(context)!
                                                  .localizacao),
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
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        hint: Text(AppLocalizations.of(context)!
                                            .categoria),
                                        isExpanded: true,
                                        value: _categoriaId.toString(),
                                        items: getListaCatDropdown(categorias),
                                        onChanged: (value) {
                                          setState(
                                            () {
                                              _categoriaId = value;
                                              _subCategoriaId = subcategorias
                                                  .where((e) =>
                                                      e.categoriaId ==
                                                      int.parse(value))
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
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        borderRadius: BorderRadius.circular(20),
                                        hint: Text(AppLocalizations.of(context)!
                                            .subCategoria),
                                        isExpanded: true,
                                        value: _subCategoriaId.toString(),
                                        items: getListaSubCatDropdown(
                                            subcategorias,
                                            int.parse(_categoriaId!)),
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
                                              AppLocalizations.of(context)!
                                                  .descricao),
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
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                              child: ListView(
                                                shrinkWrap: true,
                                                children: [
                                                  for (var form in forms)
                                                    ListTile(
                                                      title: Text(form.titulo),
                                                      trailing: IconButton(
                                                        icon: const Icon(
                                                            Icons.delete),
                                                        onPressed: () {
                                                          setState(() {
                                                            forms.remove(form);
                                                          });
                                                        },
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                ConfiguracaoFormularioScreen(
                                                              adicionaFormulario:
                                                                  _adicionaFormulario,
                                                              formulario: form,
                                                              formId:
                                                                  form.formId,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              if (_tituloController
                                                      .text.isNotEmpty ||
                                                  _localizacaoController
                                                      .text.isNotEmpty ||
                                                  _categoriaId!.isNotEmpty ||
                                                  _subCategoriaId!.isNotEmpty ||
                                                  _descricao.text.isNotEmpty) {
                                                Future<bool> confirma =
                                                    confirmExit(
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
                                                AppLocalizations.of(context)!
                                                    .cancelar),
                                          ),
                                          SizedBox(width: largura * 0.02),
                                          FilledButton(
                                            onPressed: ()=>sendData(),
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .guardar),
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
<<<<<<< HEAD
}*/
=======
}
>>>>>>> 56fa83a87cdbb689c85554cb7231d020707dd69a
