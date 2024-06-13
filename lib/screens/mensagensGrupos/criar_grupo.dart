import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:softshares_mobile/models/grupo.dart';
import 'package:softshares_mobile/models/utilizador.dart';
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
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool publico = false;
  List<XFile> _selectedImages = [];
  bool _isLoading = false;
  List<Utilizador> listaUtilizadores = [];
  List<Utilizador> listaUtilizadoresSelecionados = [];

  @override
  void initState() {
    super.initState();
    actualizaDados();
    if (widget.editar && widget.existingGroup != null) {
      _initializeFormWithExistingData(widget.existingGroup!);
    }
  }

  void _initializeFormWithExistingData(Grupo group) {
    _nomeController.text = group.nome;
    _descricaoController.text = group.descricao;
    publico = group.publico;
    if (group.imagem!.isNotEmpty) {
      _selectedImages = [XFile(group.imagem!)];
    }
    listaUtilizadoresSelecionados = group.utilizadores!;
  }

  Future<List<Utilizador>> fetchUtilizadores() async {
    await Future.delayed(Duration(seconds: 2));

    return [
      Utilizador(
          1,
          'João',
          'Silva',
          'joao.silva@example.com',
          'Developer with a passion for mobile applications.',
          1,
          [1, 2],
          1,
          1,
          "https://via.placeholder.com/150"),
      Utilizador(
          2,
          'Maria',
          'Fernandes',
          'maria.fernandes@example.com',
          'Experienced project manager.',
          1,
          [3, 4],
          2,
          1,
          "https://via.placeholder.com/150"),
      Utilizador(
          3,
          'Carlos',
          'Santos',
          'carlos.santos@example.com',
          'Graphic designer specializing in UI/UX.',
          2,
          [5, 6],
          3,
          2,
          "https://via.placeholder.com/150"),
      Utilizador(
        4,
        'Ana',
        'Costa',
        'ana.costa@example.com',
        'Content writer and SEO expert.',
        2,
        [7, 8],
        4,
        2,
        "https://via.placeholder.com/150",
      ),
    ];
  }

  // carrega lista de utilizadores
  Future<void> actualizaDados() async {
    setState(() {
      _isLoading = true;
    });

    List<Utilizador> utilizadores = await fetchUtilizadores();
    setState(() {
      listaUtilizadores = utilizadores;

      _isLoading = false;
    });
  }

  // faz a seleção da imagem para o grupo
  void _onImagesPicked(List<XFile> images) {
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages = [images.first];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (_descricaoController.text.isNotEmpty ||
              _nomeController.text.isNotEmpty) {
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
          title: Text(widget.editar
              ? AppLocalizations.of(context)!.editarGrupo
              : AppLocalizations.of(context)!.createGroup),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: largura * 0.02,
            vertical: altura * 0.02,
          ),
          child: Container(
            height: altura * 0.9,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(10),
            ),
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
                    SizedBox(
                      height: altura * 0.2,
                      width: double.infinity,
                      child: _selectedImages.isNotEmpty
                          ? Image.network(
                              _selectedImages.first.path,
                              height: altura * 0.2,
                              width: largura * 0.4,
                              fit: BoxFit.cover,
                            )
                          : Image.network("https://via.placeholder.com/150"),
                    ),
                    SizedBox(height: altura * 0.02),
                    FotoPicker(onImagesPicked: _onImagesPicked),
                    TextFormField(
                      controller: _nomeController,
                      maxLength: 60,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.nomegrupo,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)!.campoObrigatorio;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: altura * 0.02),
                    TextFormField(
                      controller: _descricaoController,
                      maxLength: 140,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.descricao,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return AppLocalizations.of(context)!.campoObrigatorio;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: altura * 0.02),
                    Row(
                      children: [
                        Checkbox(
                          value: publico,
                          onChanged: (value) {
                            setState(() {
                              publico = value!;
                            });
                          },
                        ),
                        SizedBox(width: largura * 0.02),
                        Text(AppLocalizations.of(context)!.publico),
                      ],
                    ),
                    SizedBox(height: altura * 0.02),
                    SizedBox(
                      height: altura * 0.22,
                      width: double.infinity,
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                              itemCount: listaUtilizadores.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      listaUtilizadores[index].fotoUrl ??
                                          'https://via.placeholder.com/150',
                                    ),
                                  ),
                                  title: Text(
                                    listaUtilizadores[index].getNomeCompleto(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  trailing: Checkbox(
                                    value: listaUtilizadoresSelecionados
                                            .contains(listaUtilizadores[index])
                                        ? true
                                        : false,
                                    onChanged: (value) {
                                      setState(() {
                                        if (value!) {
                                          listaUtilizadoresSelecionados
                                              .add(listaUtilizadores[index]);
                                        } else {
                                          listaUtilizadoresSelecionados
                                              .remove(listaUtilizadores[index]);
                                        }
                                      });
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                    SizedBox(height: altura * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (_descricaoController.text.isNotEmpty ||
                                _nomeController.text.isNotEmpty) {
                              Future<bool> confirma = confirmExit(
                                context,
                                AppLocalizations.of(context)!.sairSemGuardar,
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
                          child: Text(AppLocalizations.of(context)!.cancelar),
                        ),
                        SizedBox(width: largura * 0.02),
                        FilledButton(
                          onPressed: () {
                            // validar se o utilizador selecionou uma imagem
                            if (_selectedImages.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
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
                            if (listaUtilizadoresSelecionados.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
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
                            if (_formKey.currentState!.validate() &&
                                _selectedImages.isNotEmpty &&
                                listaUtilizadoresSelecionados.isNotEmpty) {
                              if (widget.editar) {
                                // Handle the edit case
                                // Update existing group
                              } else {
                                // Handle the create case
                                // Create new group
                              }
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
