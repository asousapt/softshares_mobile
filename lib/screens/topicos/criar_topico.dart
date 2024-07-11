import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/categoria_repository.dart';
import 'package:softshares_mobile/Repositories/subcategoria_repository.dart';
import 'package:softshares_mobile/Repositories/topico_repository.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/imagem.dart';
import 'package:softshares_mobile/models/subcategoria.dart';
import 'package:softshares_mobile/models/topico.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/utils.dart';
import 'package:softshares_mobile/widgets/gerais/dialog.dart';
import 'package:softshares_mobile/widgets/gerais/foto_picker.dart';

class CriarTopicoScreen extends StatefulWidget {
  const CriarTopicoScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return CriarTopicoScreenState();
  }
}

class CriarTopicoScreenState extends State<CriarTopicoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _mensagemController = TextEditingController();
  String? _categoriaId;
  String? _subCategoriaId;
  bool _isLoading = true;
  List<Categoria> categorias = [];
  List<Subcategoria> subcategorias = [];
  List<XFile> images = [];

  // carrega categorias e subcategorias da base de dados local
  Future<void> carregarCategoriasSubcats() async {
    final prefs = await SharedPreferences.getInstance();
    final int idiomaId = prefs.getInt("idiomaId") ?? 1;
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

  @override
  void initState() {
    carregarCategoriasSubcats().then((value) {
      setState(() {
        _categoriaId = categorias![0].categoriaId.toString();
        _subCategoriaId = subcategorias![0].subcategoriaId.toString();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _mensagemController.dispose();
    super.dispose();
  }

  void _updateImages(List<XFile> newImages) {
    setState(() {
      images = newImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (_tituloController.text.isNotEmpty ||
              _mensagemController.text.isNotEmpty) {
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
            AppLocalizations.of(context)!.novoTopico,
          ),
        ),
        body: SafeArea(
          top: true,
          bottom: true,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: largura * 0.02, vertical: altura * 0.02),
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                        color: Theme.of(context).canvasColor),
                  )
                : SingleChildScrollView(
                    child: Container(
                      height: altura * 0.85,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: largura * 0.02,
                            vertical: altura * 0.02),
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FotoPicker(
                                  pickedImages: images,
                                  onImagesPicked: _updateImages,
                                ),
                                TextFormField(
                                  maxLength: 140,
                                  controller: _tituloController,
                                  decoration: InputDecoration(
                                    label: Text(
                                        AppLocalizations.of(context)!.titulo),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "${AppLocalizations.of(context)!.porfavorInsiraO} ${AppLocalizations.of(context)!.titulo}";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: altura * 0.02),
                                DropdownButtonFormField(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  hint: Text(
                                      AppLocalizations.of(context)!.categoria),
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
                                DropdownButton(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  borderRadius: BorderRadius.circular(20),
                                  hint: Text(AppLocalizations.of(context)!
                                      .subCategoria),
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
                                  maxLines: 10,
                                  controller: _mensagemController,
                                  decoration: InputDecoration(
                                    label: Text(
                                        AppLocalizations.of(context)!.mensagem),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "${AppLocalizations.of(context)!.porfavorInsiraA} ${AppLocalizations.of(context)!.mensagem}";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: altura * 0.02),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        if (_tituloController.text.isNotEmpty ||
                                            _mensagemController
                                                .text.isNotEmpty) {
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
                                      child: Text(AppLocalizations.of(context)!
                                          .cancelar),
                                    ),
                                    SizedBox(width: largura * 0.02),
                                    FilledButton(
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate() &&
                                            images.isNotEmpty) {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          //carrega idiomaId
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          final int idiomaId =
                                              prefs.getInt("idiomaId") ?? 1;
                                          // Convert as imagens para o tipo Imagem
                                          List<Imagem> imagens = [];
                                          imagens =
                                              await convertListXfiletoImagem(
                                                  images);
                                          String util = prefs
                                                  .getString('utilizadorObj') ??
                                              '';
                                          Utilizador utilizadortmp =
                                              Utilizador.fromJson(
                                                  jsonDecode(util));
                                          Topico topicoCriar = Topico(
                                            subcategoria:
                                                int.parse(_subCategoriaId!),
                                            titulo: _tituloController.text,
                                            mensagem: _mensagemController.text,
                                            idiomaId: idiomaId,
                                            imagens: imagens,
                                            utilizadorId:
                                                utilizadortmp.utilizadorId,
                                          );
                                          TopicoRepository topicoRepository =
                                              TopicoRepository();
                                          await topicoRepository
                                              .criarTopico(topicoCriar);
                                          setState(() {
                                            _isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                  AppLocalizations.of(context)!
                                                      .dadosGravados),
                                            ),
                                          );
                                          Navigator.of(context).pop(true);
                                        }
                                      },
                                      child: Text(AppLocalizations.of(context)!
                                          .guardar),
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
        ),
      ),
    );
  }
}
