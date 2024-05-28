import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/subcategoria.dart';
import 'package:softshares_mobile/models/topico.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/widgets/gerais/dialog.dart';

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

  @override
  void initState() {
    _categoriaId = categorias[0].categoriaId.toString();
    _subCategoriaId = subcategorias[0].subcategoriaId.toString();
    super.initState();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _mensagemController.dispose();
    super.dispose();
  }

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
            child: SingleChildScrollView(
              child: Container(
                height: altura * 0.85,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: largura * 0.02, vertical: altura * 0.02),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          maxLength: 140,
                          controller: _tituloController,
                          decoration: InputDecoration(
                            label: Text(AppLocalizations.of(context)!.titulo),
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
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          hint: Text(AppLocalizations.of(context)!.categoria),
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
                        DropdownButton(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          borderRadius: BorderRadius.circular(20),
                          hint:
                              Text(AppLocalizations.of(context)!.subCategoria),
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
                            label: Text(AppLocalizations.of(context)!.mensagem),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "${AppLocalizations.of(context)!.porfavorInsiraA} ${AppLocalizations.of(context)!.mensagem}";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: altura * 0.12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (_tituloController.text.isNotEmpty ||
                                    _mensagemController.text.isNotEmpty) {
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
                              child:
                                  Text(AppLocalizations.of(context)!.cancelar),
                            ),
                            SizedBox(width: largura * 0.02),
                            FilledButton(
                              onPressed: () {
                                // TODO: Implementar a lógica de guardar o tópico
                                // Substituir o codigo do idioma,utilizador e anexos
                                Topico topico = Topico(
                                  idiomaId: 1,
                                  imagem: [],
                                  titulo: _tituloController.text,
                                  mensagem: _mensagemController.text,
                                  categoria: int.parse(_categoriaId!),
                                  subcategoria: int.parse(_subCategoriaId!),
                                  utilizadorId: Utilizador(
                                      3,
                                      'Alice',
                                      'Johnson',
                                      'alice.johnson@example.com',
                                      'Some info',
                                      3,
                                      [1, 2],
                                      3,
                                      3),
                                );
                                /* if (_formKey.currentState!.validate()) {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/forum');
                                } */
                              },
                              child:
                                  Text(AppLocalizations.of(context)!.guardar),
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
    );
  }
}
