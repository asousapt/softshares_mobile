import 'dart:async';

import 'package:flutter/material.dart';
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
import 'package:transparent_image/transparent_image.dart';
import 'package:softshares_mobile/widgets/gerais/text_tools.dart';
import 'package:softshares_mobile/widgets/comentarios_section.dart';
import 'package:softshares_mobile/models/comentario.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/widgets/gerais/main_drawer.dart';
import 'package:softshares_mobile/widgets/gerais/bottom_navigation.dart';

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

  List<Widget> rating(double ratingLocal) {
    // Garantir que a classificação esteja dentro do intervalo de 0 a 5
    if (ratingLocal < 0 || ratingLocal > 5) {
      return <Widget>[const Text("Erro nos ratings, valor inválido(<0 ou 5<)")];
    }

    List<Widget> estrelas = [];

    // Número de estrelas cheias
    int estrelasCheias = ratingLocal.floor();
    // Verificar se há meia estrela
    bool temMeiaEstrela = (ratingLocal - estrelasCheias) >= 0.5;

    // Adicionar estrelas cheias
    for (int i = 0; i < estrelasCheias; i++) {
      estrelas.add(const Icon(
        Icons.star,
        size: 30.0,
        color: Colors.amber,
      ));
    }

    // Adicionar meia estrela, se aplicável
    if (temMeiaEstrela) {
      estrelas.add(const Icon(
        Icons.star_half,
        size: 30.0,
        color: Colors.amber,
      ));
    }

    // Adicionar estrelas vazias restantes
    int estrelasVazias = 5 - estrelas.length;
    for (int i = 0; i < estrelasVazias; i++) {
      estrelas.add(const Icon(
        Icons.star_border,
        size: 30.0,
        color: Colors.amber,
      ));
    }

    return estrelas;
  }

  Future<void> carregaCategorias() async {
    final prefs = await SharedPreferences.getInstance();
    final idiomaId = prefs.getInt("idiomaId") ?? 1;

    CategoriaRepository categoriaRepository = CategoriaRepository();
    List<Categoria> categoriasdb =
        await categoriaRepository.fetchCategoriasDB(idiomaId);
    setState(() {
      categorias = categoriasdb;
      _isLoading = false;
    });
  }

  int utilizadorId = 1;

  @override
  void initState() {
    carregaCategorias();
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
                            Row(children: [
                              Text(
                                pontoInteresse!.titulo,
                                style: const TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: rating(
                                      4) //Função que devolve o número de estrelas em forma de icone, depois será substituido pelo valor recebido pela Base de Dados
                                  )
                            ]),
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
                                ElevatedButton(
                                  onPressed: () {
                                    // Define the button action here
                                  },
                                  child: Text(
                                      AppLocalizations.of(context)!.avaliar),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Color.fromRGBO(29, 90, 161, 1),
                            ),
                            const Text("Comentários de outros utilizadores"),
                            SizedBox(
                              height: altura * 0.5,
                              child: SingleChildScrollView(
                                child: CommentSection(
                                  comentarios: [
                                    Commentario(
                                      comentarioid: 1,
                                      comentario: 'This is the first comment.',
                                      autor: Utilizador(
                                          utilizadorId: 3,
                                          pNome: 'Alice',
                                          uNome: 'Johnson',
                                          email: 'alice.johnson@example.com',
                                          sobre: 'Some info',
                                          idiomaId: 1,
                                          departamentoId: 3,
                                          funcaoId: 3,
                                          poloId: 1,
                                          fotoUrl:
                                              "https://via.placeholder.com/150"),
                                      data: DateTime.now()
                                          .subtract(const Duration(days: 1)),
                                    ),
                                    Commentario(
                                      comentarioid: 4,
                                      comentario: 'This is the second comment.',
                                      autor: Utilizador(
                                          utilizadorId: 3,
                                          pNome: 'Alice',
                                          uNome: 'Johnson',
                                          email: 'alice.johnson@example.com',
                                          sobre: 'Some info',
                                          idiomaId: 1,
                                          departamentoId: 3,
                                          funcaoId: 3,
                                          poloId: 1,
                                          fotoUrl:
                                              "https://via.placeholder.com/150"),
                                      data: DateTime.now()
                                          .subtract(Duration(days: 2)),
                                    ),
                                    Commentario(
                                      comentarioid: 6,
                                      comentario:
                                          'This is the third comment with no subcomments.',
                                      autor: Utilizador(
                                          utilizadorId: 3,
                                          pNome: 'Alice',
                                          uNome: 'Johnson',
                                          email: 'alice.johnson@example.com',
                                          sobre: 'Some info',
                                          idiomaId: 1,
                                          departamentoId: 3,
                                          funcaoId: 3,
                                          poloId: 1,
                                          fotoUrl:
                                              "https://via.placeholder.com/150"),
                                      data: DateTime.now()
                                          .subtract(Duration(days: 3)),
                                    ),
                                    Commentario(
                                      comentarioid: 7,
                                      comentario: 'This is the fourth comment.',
                                      autor: Utilizador(
                                          utilizadorId: 3,
                                          pNome: 'Alice',
                                          uNome: 'Johnson',
                                          email: 'alice.johnson@example.com',
                                          sobre: 'Some info',
                                          idiomaId: 1,
                                          departamentoId: 3,
                                          funcaoId: 3,
                                          poloId: 1,
                                          fotoUrl:
                                              "https://via.placeholder.com/150"),
                                      data: DateTime.now()
                                          .subtract(Duration(days: 4)),
                                      subcomentarios: [
                                        Commentario(
                                          comentarioid: 8,
                                          comentario:
                                              'Subcomment to the fourth comment.',
                                          autor: Utilizador(
                                              utilizadorId: 3,
                                              pNome: 'Alice',
                                              uNome: 'Johnson',
                                              email:
                                                  'alice.johnson@example.com',
                                              sobre: 'Some info',
                                              idiomaId: 1,
                                              departamentoId: 3,
                                              funcaoId: 3,
                                              poloId: 1,
                                              fotoUrl:
                                                  "https://via.placeholder.com/150"),
                                          data: DateTime.now().subtract(
                                              Duration(days: 4, hours: 1)),
                                        ),
                                        Commentario(
                                          comentarioid: 9,
                                          comentario:
                                              'Another subcomment to the fourth comment.',
                                          autor: Utilizador(
                                              utilizadorId: 3,
                                              pNome: 'Alice',
                                              uNome: 'Johnson',
                                              email:
                                                  'alice.johnson@example.com',
                                              sobre: 'Some info',
                                              idiomaId: 1,
                                              departamentoId: 3,
                                              funcaoId: 3,
                                              poloId: 1,
                                              fotoUrl:
                                                  "https://via.placeholder.com/150"),
                                          data: DateTime.now().subtract(
                                              Duration(days: 4, hours: 2)),
                                        ),
                                        Commentario(
                                          comentarioid: 10,
                                          comentario:
                                              'Yet another subcomment to the fourth comment.',
                                          autor: Utilizador(
                                              utilizadorId: 3,
                                              pNome: 'Alice',
                                              uNome: 'Johnson',
                                              email:
                                                  'alice.johnson@example.com',
                                              sobre: 'Some info',
                                              idiomaId: 1,
                                              departamentoId: 3,
                                              funcaoId: 3,
                                              poloId: 1,
                                              fotoUrl:
                                                  "https://via.placeholder.com/150"),
                                          data: DateTime.now().subtract(
                                              Duration(days: 4, hours: 3)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
