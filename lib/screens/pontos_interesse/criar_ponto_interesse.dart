import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/categoria_repository.dart';
import 'package:softshares_mobile/Repositories/subcategoria_repository.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/formulario.dart';
import 'package:softshares_mobile/models/ponto_de_interesse.dart';
import 'package:softshares_mobile/models/subcategoria.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/widgets/gerais/dialog.dart';
import 'package:softshares_mobile/services/api_service.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/pergunta_formulario.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/resposta_form.dart';
import 'package:softshares_mobile/Repositories/cidade_repository.dart';
import 'package:softshares_mobile/screens/generic/location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:camera/camera.dart';
import 'package:softshares_mobile/widgets/gerais/foto_picker.dart';
import 'package:softshares_mobile/utils.dart';
import 'package:softshares_mobile/models/imagem.dart';

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
  int idiomaId = 0, cidadeId = 0, poloId = 0;
  double latitude = 0.0, longitude = 0.0;
  Formulario? form;
  bool defaultValues = false;
  List<Categoria> categorias = [];
  List<Subcategoria> subcategorias = [];
  ApiService api = ApiService();
  bool _isLoading = true;
  late PontoInteresse novoPonto;
  final Map<int, TextEditingController> _controllers = {};
  final Map<int, bool> _booleanValues = {};
  final Map<int, String?> _dropdownValues = {};
  Utilizador? user;
  List<XFile> images = [];
  List<Imagem> imagens = [];

  void _updateImages(List<XFile> newImages) {
    setState(() {
      images = newImages;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> carregarDados() async {
    final prefs = await SharedPreferences.getInstance();
    idiomaId = prefs.getInt("idiomaId") ?? 1;
    poloId = prefs.getInt("poloId") ?? 1;
    user = Utilizador.fromJson(jsonDecode(prefs.getString('utilizadorObj')!));
    CategoriaRepository categoriaRepository = CategoriaRepository();
    List<Categoria> categoriasL =
        await categoriaRepository.fetchCategoriasDB(idiomaId);
    SubcategoriaRepository subcategoriaRepository = SubcategoriaRepository();
    List<Subcategoria> subcategoriasL =
        await subcategoriaRepository.fetchSubcategoriasDB(idiomaId);

    setState(() {
      categorias = categoriasL;
      subcategorias = subcategoriasL;
      _isLoading = false;
    });
  }

  void setForm() async {
    print("A subcategoria escolhida foi: ${_subCategoriaId}");
    final json1 = await api.getRequest("formulario/subcatm/${_subCategoriaId}");
    if (json1['data'] != 0) {
      int idform = json1['data'];
      final json2 = await api.getRequest("formulario//idformm/${idform}");
      setState(() {
        form = Formulario.fromJson(json2['data']);
        for (int i = 0; i < form!.perguntas.length; i++) {
          if (form!.perguntas[i].tipoDados == TipoDados.textoLivre ||
              form!.perguntas[i].tipoDados == TipoDados.numerico) {
            _controllers[i] = TextEditingController();
          }
          if (form!.perguntas[i].tipoDados == TipoDados.logico) {
            _booleanValues[i] = false;
          }
          if (form!.perguntas[i].tipoDados == TipoDados.seleccao) {
            _dropdownValues[i] = null;
          }
        }
      });
    } else {
      setState(() {
        form = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    api.setAuthToken('tokenFixo');
    carregarDados().then((value) {
      setState(() {
        _categoriaId = categorias![0].categoriaId.toString();
        _subCategoriaId = subcategorias![0].subcategoriaId.toString();
      });
    });
    descricao = "";
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _localizacaoController.dispose();
    _descricao.dispose();
    super.dispose();
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
        "${AppLocalizations.of(context)!.categoria} : ${categorias.firstWhere((element) => element.categoriaId == int.parse(cat!)).descricao}\n"
        "${AppLocalizations.of(context)!.subCategoria} : ${subcategorias.firstWhere((element) => element.subcategoriaId == int.parse(sub!)).descricao}\n";

    if (form != null) {
      for (int i = 0; i < form!.perguntas.length; i++) {
        mensagem += form!.perguntas[i].pergunta;
        if (form!.perguntas[i].tipoDados == TipoDados.textoLivre ||
            form!.perguntas[i].tipoDados == TipoDados.numerico) {
          mensagem += ": ${_controllers[i]!.text}\n";
        }
        if (form!.perguntas[i].tipoDados == TipoDados.logico) {
          mensagem += ": ${_booleanValues[i]}\n";
        }
        if (form!.perguntas[i].tipoDados == TipoDados.seleccao) {
          mensagem += ": ${_dropdownValues[i]}\n";
        }
      }
    }
    return mensagem;
  }

  Future<void> converterImagens() async {
    List<Imagem> imagensconvert = await convertListXfiletoImagem(images);
    setState(() {
      imagens = imagensconvert;
    });
  }

  Map<String, dynamic> createJson() {
    final String titulo = _tituloController.text;
    final String descricao = _descricao.text;
    final String local = _localizacaoController.text;
    final int cat = int.parse(_categoriaId!);
    final int sub = int.parse(_subCategoriaId!);
    final uti = user!.utilizadorId;

    List<Map<String, dynamic>> listaImagens =
        toJsonList(imagens, (Imagem img) => img.toJson());

    if (imagens.isEmpty) print("Lista de imagens vazia");

    if (images.isEmpty) print("Lista de xfiles vazia");

    if (listaImagens.isEmpty) print("Lista que vai ser enviada vazia");

    final Map<String, dynamic> data = {
      "subcategoriaid": sub,
      "titulo": titulo,
      "descricao": descricao,
      "localizacao": local,
      "latitude": latitude,
      "longitude": longitude,
      "idiomaid": idiomaId,
      "cidadeid": cidadeId,
      "utilizadorcriou": uti,
      "poloid": poloId,
      "imagens": listaImagens,
      "formRespostas": form != null
          ? getRespostas().map((resposta) => resposta.toJsonCriar()).toList()
          : [],
    };
    print("This is the data: $data");
    return data;
  }

  void sendData() async {
    if (_formKey.currentState!.validate()) {
      String mensagem = createMensagem(context);
      CidadeRepository cidadeRepository = CidadeRepository();
      int cidadeIdValue =
          await cidadeRepository.obtemCidadeId(latitude, longitude);

      // Update the state synchronously
      setState(() {
        cidadeId = cidadeIdValue;
      });

      await converterImagens();

      Map<String, dynamic> json = createJson();
      // Perform the asynchronous operation

      Future<bool> confirma = confirmExit(
        context,
        AppLocalizations.of(context)!.criarPontoInteresse,
        mensagem,
      );

      confirma.then((value) async => {
            if (value)
              {
                await api.postRequest('pontoInteresse/addMobile', json),
                Navigator.pushNamed(context, '/pontosInteresse'),
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.pontoInteresseCriado)))
              }
          });
    }
  }

  List<Widget> _buildPerguntas(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    List<Widget> widgets = [];
    print("gonna build questions");

    for (int index = 0; index < form!.perguntas.length; index++) {
      Pergunta pergunta = form!.perguntas[index];
      print("O index é: $index");
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
      if (index < form!.perguntas.length - 1) {
        widgets.add(SizedBox(height: altura * 0.02));
      }
    }

    return widgets;
  }

  // funcao que faz a leitara das respostas do formulario
  List<RespostaDetalhe> getRespostas() {
    List<RespostaDetalhe> respostas = [];

    for (int index = 0; index < form!.perguntas.length; index++) {
      Pergunta pergunta = form!.perguntas[index];

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
    for (int index = 0; index < form!.perguntas.length; index++) {
      Pergunta pergunta = form!.perguntas[index];

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
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.white,
              ))
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
                                            onPressed: () async {
                                              LatLng? localizacao =
                                                  await Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    const LocationPicker(),
                                              ));
                                              if (localizacao != null) {
                                                latitude = localizacao.latitude;
                                                longitude =
                                                    localizacao.longitude;
                                              }
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
                                              setForm();
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
                                      FotoPicker(
                                        pickedImages: images,
                                        onImagesPicked: _updateImages,
                                      ),
                                      // LISTA DE FORMULARIOS
                                      form != null
                                          ? Column(
                                              children:
                                                  _buildPerguntas(context),
                                            )
                                          : const SizedBox(height: 0),
                                      SizedBox(height: altura * 0.02),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              if ((_tituloController
                                                          .text.isNotEmpty ||
                                                      _localizacaoController
                                                          .text.isNotEmpty ||
                                                      _categoriaId!
                                                          .isNotEmpty ||
                                                      _subCategoriaId!
                                                          .isNotEmpty ||
                                                      _descricao
                                                          .text.isNotEmpty) &&
                                                  (form == null ||
                                                      validaFormsTemDados())) {
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
                                            onPressed: () => sendData(),
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
}
