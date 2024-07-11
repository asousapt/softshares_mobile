import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/categoria_repository.dart';
import 'package:softshares_mobile/Repositories/grupo_repository.dart';
import 'package:softshares_mobile/Repositories/subcategoria_repository.dart';
import 'package:softshares_mobile/Repositories/utilizador_repository.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/grupo.dart';
import 'package:softshares_mobile/models/imagem.dart';
import 'package:softshares_mobile/models/subcategoria.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/utils.dart';
import 'package:softshares_mobile/widgets/gerais/dialog.dart';
import 'package:softshares_mobile/widgets/gerais/foto_picker.dart';

class CriarGrupoScreen extends StatefulWidget {
  const CriarGrupoScreen({
    super.key,
    required this.editar,
    this.existingGroup,
  });

  final bool editar;
  final Grupo? existingGroup;

  @override
  State<CriarGrupoScreen> createState() {
    return _CriarGrupoScreenState();
  }
}

class _CriarGrupoScreenState extends State<CriarGrupoScreen> {
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool publico = false;
  final List<XFile> _selectedImages = [];
  bool _isLoading = false;
  List<Utilizador> listaUtilizadores = [];
  List<Utilizador> listaUtilizadoresSelecionados = [];
  bool editar = false;
  String? _categoriaId;
  String? _subCategoriaId;
  late int utilizadorId;
  late int poloId;
  List<Categoria>? categorias;
  List<Subcategoria>? subcategorias;

  // Carrega as categorias e subcategorias
  Future<void> carregarCategoriasSubcats() async {
    final prefs = await SharedPreferences.getInstance();
    final int idiomaId = prefs.getInt("idiomaId") ?? 1;
    CategoriaRepository categoriaRepository = CategoriaRepository();
    List<Categoria> categoriasL =
        await categoriaRepository.fetchCategoriasDB(idiomaId);
    SubcategoriaRepository subcategoriaRepository = SubcategoriaRepository();
    List<Subcategoria> subcategoriasL =
        await subcategoriaRepository.fetchSubcategoriasDB(idiomaId);

    // Carrega utilizador
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    utilizadorId = utilizador.utilizadorId;
    poloId = utilizador.poloId;

    setState(() {
      categorias = categoriasL;
      subcategorias = subcategoriasL;
      _isLoading = false;
    });
  }

  // Carrega a lista de utilizadores
  Future<void> carregaListaUtils() async {
    UtilizadorRepository utilizadorRepository = UtilizadorRepository();
    List<Utilizador> listaUtils =
        await utilizadorRepository.getUtilizadoresSimplificado();
    setState(() {
      listaUtilizadores = listaUtils;
    });
  }

  @override
  void initState() {
    carregarCategoriasSubcats().then((value) {
      setState(() {
        carregaListaUtils();
        _categoriaId = categorias![0].categoriaId.toString();
        _subCategoriaId = subcategorias![0].subcategoriaId.toString();
        editar = widget.editar;
        if (widget.editar && widget.existingGroup != null) {
          GrupoRepository grupoRepository = GrupoRepository();

          _initializeFormWithExistingData();
        }
        _isLoading = false;
      });
    });

    super.initState();
  }

  // inicializa os dados do formulario do grupo em modo de edição
  void _initializeFormWithExistingData() async {
    GrupoRepository grupoRepository = GrupoRepository();
    Grupo? grupoLocal =
        await grupoRepository.getGrupo(widget.existingGroup!.grupoId!);
    if (grupoLocal != null) {
      _descricaoController.text = grupoLocal.descricao;
      _nomeController.text = grupoLocal.nome;
      publico = grupoLocal.publico;
      _categoriaId = grupoLocal.categoriaId.toString();
      _subCategoriaId = grupoLocal.subcategoriaId.toString();

      listaUtilizadoresSelecionados = grupoLocal.utilizadoresGrupo!;
    }
  }

  // faz a seleção da imagem para o grupo
  void _updateImages(List<XFile> newImages) {
    setState(() {
      _selectedImages[0] = newImages[0];
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
          if (_descricaoController.text.isNotEmpty) {
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
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.editar
                ? AppLocalizations.of(context)!.editarGrupo
                : AppLocalizations.of(context)!.createGroup),
            bottom: TabBar(
              tabs: [
                Tab(text: AppLocalizations.of(context)!.detalhesGrupo),
                Tab(text: AppLocalizations.of(context)!.membros),
              ],
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: largura * 0.02,
              vertical: altura * 0.02,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TabBarView(
                      children: [
                        // Primeeira tab - Formulário
                        SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                              horizontal: largura * 0.02,
                              vertical: altura * 0.02,
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FotoPicker(
                                    pickedImages: _selectedImages,
                                    onImagesPicked: _updateImages,
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  TextFormField(
                                    maxLength: 80,
                                    controller: _nomeController,
                                    decoration: InputDecoration(
                                      labelText:
                                          AppLocalizations.of(context)!.nome,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return AppLocalizations.of(context)!
                                            .campoObrigatorio;
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  TextFormField(
                                    controller: _descricaoController,
                                    maxLength: 140,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      labelText: AppLocalizations.of(context)!
                                          .descricao,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return AppLocalizations.of(context)!
                                            .campoObrigatorio;
                                      }
                                      return null;
                                    },
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: publico,
                                        onChanged: (value) {
                                          setState(() {
                                            publico = value!;
                                          });
                                          if (!publico) {
                                            setState(() {});
                                          }
                                        },
                                      ),
                                      SizedBox(width: largura * 0.02),
                                      Text(AppLocalizations.of(context)!
                                          .publico),
                                    ],
                                  ),
                                  // Selecção de categoria
                                  DropdownButtonFormField(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    hint: Text(AppLocalizations.of(context)!
                                        .categoria),
                                    isExpanded: true,
                                    value: _categoriaId.toString(),
                                    items: categorias!.map((e) {
                                      return DropdownMenuItem(
                                        value: e.categoriaId.toString(),
                                        child: Row(
                                          children: [
                                            e.getIcone(),
                                            const SizedBox(width: 10),
                                            Text(e.descricao),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: publico
                                        ? (value) {
                                            setState(() {
                                              _categoriaId = value! as String;
                                              _subCategoriaId = subcategorias!
                                                  .where((e) =>
                                                      e.categoriaId ==
                                                      int.parse(
                                                          value as String))
                                                  .first
                                                  .subcategoriaId
                                                  .toString();
                                            });
                                          }
                                        : null,
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
                                        subcategorias!,
                                        int.parse(_categoriaId!)),
                                    onChanged: publico
                                        ? (value) {
                                            setState(() {
                                              _subCategoriaId =
                                                  value! as String;
                                            });
                                          }
                                        : null,
                                  ),
                                  SizedBox(height: altura * 0.02),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_descricaoController
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
                                        child: Text(
                                            AppLocalizations.of(context)!
                                                .cancelar),
                                      ),
                                      SizedBox(width: largura * 0.02),
                                      FilledButton(
                                        onPressed: () async {
                                          // validar se o utilizador selecionou uma imagem
                                          if (_selectedImages.isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  AppLocalizations.of(context)!
                                                      .selecioneUmaImagem,
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          // validar se o utilizador selecionou pelo menos um utilizador
                                          if (listaUtilizadoresSelecionados
                                              .isEmpty) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  AppLocalizations.of(context)!
                                                      .selecionePeloMenosUmUtilizador,
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          // validar se o formulário é válido e insere
                                          if (_formKey.currentState!
                                                  .validate() &&
                                              _selectedImages.isNotEmpty &&
                                              listaUtilizadoresSelecionados
                                                  .isNotEmpty) {
                                            if (widget.editar) {
                                              // Handle the edit case
                                              // Update existing group
                                            } else {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              // Vamos fazer a criação do novo grupo
                                              List<Imagem> imagens = [];
                                              imagens =
                                                  await convertListXfiletoImagem(
                                                      _selectedImages);
                                              Grupo grupoCriar = Grupo(
                                                descricao:
                                                    _descricaoController.text,
                                                nome: _nomeController.text,
                                                publico: publico,
                                                utilizadoresGrupo:
                                                    listaUtilizadoresSelecionados,
                                                categoriaId: publico
                                                    ? int.parse(_categoriaId!)
                                                    : null,
                                                subcategoriaId: publico
                                                    ? int.parse(
                                                        _subCategoriaId!)
                                                    : null,
                                                imagem: imagens,
                                                utilizadorCriouId: utilizadorId,
                                              );
                                              GrupoRepository grupoRepository =
                                                  GrupoRepository();
                                              bool sucesso =
                                                  await grupoRepository
                                                      .createGrupo(grupoCriar);
                                              if (sucesso) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .dadosGravados,
                                                    ),
                                                  ),
                                                );
                                                Navigator.of(context).pop();
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .ocorreuErro,
                                                    ),
                                                  ),
                                                );
                                              }
                                            }
                                          }
                                        },
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

                        // Second tab - List view
                        Container(
                          height: altura * 0.16,
                          width: double.infinity,
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                  itemCount: listaUtilizadores.length,
                                  itemBuilder: (context, index) {
                                    final currentUser =
                                        listaUtilizadores[index];

                                    final isSelected =
                                        listaUtilizadoresSelecionados
                                            .where(
                                              (element) =>
                                                  element.utilizadorId ==
                                                  currentUser.utilizadorId,
                                            )
                                            .isNotEmpty;
                                    return ListTile(
                                      leading: currentUser.fotoUrl!.isEmpty
                                          ? CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .primaryColor,
                                              child: Text(
                                                currentUser.getIniciais(),
                                                style: TextStyle(
                                                    color: Theme.of(context)!
                                                        .canvasColor),
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  currentUser.fotoUrl!),
                                            ),
                                      title: Text(
                                        currentUser.getNomeCompleto(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: Checkbox(
                                        value: isSelected,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value!) {
                                              listaUtilizadoresSelecionados
                                                  .add(currentUser);
                                            } else {
                                              listaUtilizadoresSelecionados
                                                  .remove(currentUser);
                                            }
                                          });
                                        },
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
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
