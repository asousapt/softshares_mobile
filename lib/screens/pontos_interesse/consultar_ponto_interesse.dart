import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/categoria_repository.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/ponto_de_interesse.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/screens/formularios_dinamicos/reposta_form.dart';
import 'package:softshares_mobile/screens/formularios_dinamicos/resposta_individual.dart';
import 'package:softshares_mobile/screens/formularios_dinamicos/tabela_respostas.dart';
import 'package:softshares_mobile/widgets/gerais/perfil/custom_tab.dart';
import 'package:softshares_mobile/widgets/pontos__de_interesse/escolherRating.dart';
import 'package:softshares_mobile/widgets/pontos__de_interesse/estrelas.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:softshares_mobile/widgets/gerais/text_tools.dart';
import 'package:softshares_mobile/widgets/comentarios_section.dart';
import 'package:softshares_mobile/models/comentario.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/widgets/gerais/main_drawer.dart';
import 'package:softshares_mobile/widgets/gerais/bottom_navigation.dart';
import 'dart:convert';

class ConsultPontoInteresseScreen extends StatefulWidget {
  const ConsultPontoInteresseScreen({
    super.key,
    required this.pontoInteresse,
  });

  final PontoInteresse pontoInteresse;

  @override
  State<ConsultPontoInteresseScreen> createState() {
    return _ConsultPontoInteresseScreenState();
  }
}

class _ConsultPontoInteresseScreenState
    extends State<ConsultPontoInteresseScreen> {
  PontoInteresse? pontoInteresse;
  List<Categoria> categorias = [];
  bool _isLoading = true;
  String? comentarioAtual;
  int rating = 0;
  bool invalidRating = false;
  Utilizador? user;
  List<Commentario> comentariosTeste = [];

  Future<void> carregaDados() async {
    final prefs = await SharedPreferences.getInstance();
    final idiomaId = prefs.getInt("idiomaId") ?? 1;
    user = jsonDecode(prefs.getString('utilizadorObj')!);

    CategoriaRepository categoriaRepository = CategoriaRepository();
    List<Categoria> categoriasdb =
        await categoriaRepository.fetchCategoriasDB(idiomaId);
    setState(() {
      categorias = categoriasdb;
      _isLoading = false;
    });
  }

  int utilizadorId = 1;

  atualizarRating(int aval) {
    setState(() {
      rating = aval;
    });
  }

  void enviarAvaliacao() {
    if (comentarioAtual == null) {
      //API para enviar comentário atual
    }
    if (rating == 0) {
      invalidRating == true;
    } else {
      //Código para enviar rating
    }
  }

  @override
  void initState() {
    carregaDados();
    pontoInteresse = widget.pontoInteresse;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.pontosInteresse,
        ),
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: BottomNavigation(seleccao: 1),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Container(
          margin: EdgeInsets.only(
            top: altura * 0.01,
            left: largura * 0.01,
            right: largura * 0.01,
            bottom: altura * 0.01,
          ),
          height: altura * 0.9,
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).canvasColor,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: FadeInImage(
                                fit: BoxFit.fill,
                                height: altura * 0.2,
                                width: double.infinity,
                                placeholder:
                                    const AssetImage("Images/Restaurante.jpg"),
                                image:
                                    const AssetImage("Images/Restaurante.jpg"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return const Image(
                                      image:
                                          AssetImage("Images/Restaurante.jpg"));
                                },
                              ),
                            ),
                            SizedBox(height: altura * 0.02),
                            Text(
                              pontoInteresse!.titulo,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            EstrelasRating(rating: pontoInteresse!.avaliacao!),
                            SizedBox(height: altura * 0.02),
                            Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.locationDot,
                                  color: Colors.red,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: largura * 0.02),
                                  child: Text(pontoInteresse!.localizacao),
                                ),
                              ],
                            ),
                            SizedBox(height: altura * 0.02),
                            Center(
                              child: Container(
                                color: Colors.red,
                                height: altura * 0.25,
                                width: largura * 0.85,
                                child: const Center(
                                  child: Text("Mapa"),
                                ),
                              ),
                            ),
                            DividerWithText(
                                text: AppLocalizations.of(context)!.descricao),
                            Text(pontoInteresse!.descricao),
                            DividerWithText(
                                text: AppLocalizations.of(context)!.avaliar),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    maxLines: null,
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)!
                                          .deixaComentario,
                                      border:
                                          InputBorder.none, // Remove the border
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0), // Add padding
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: RatingPicker(
                                      initialRating: 1,
                                      onRatingSelected: atualizarRating),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    enviarAvaliacao();
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.avaliar),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Color.fromRGBO(29, 90, 161, 1),
                            ),
                            Text(AppLocalizations.of(context)!
                                .outrosComentarios),
                            SizedBox(
                              height: altura * 0.5,
                              child: SingleChildScrollView(
                                child: CommentSection(
                                    comentarios: comentariosTeste),
                              ),
                            )
                          ],
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
