import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import 'package:softshares_mobile/models/topico.dart';
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

  List<Categoria> categorias = [
    const Categoria(1, "Gastronomia", "cor1", "garfo"),
    const Categoria(2, "Desporto", "cor2", "futebol"),
    const Categoria(3, "Atividade Ar Livre", "cor3", "arvore"),
    const Categoria(4, "Alojamento", "cor3", "casa"),
    const Categoria(5, "Saúde", "cor3", "cruz"),
    const Categoria(6, "Ensino", "cor3", "escola"),
    const Categoria(7, "Infraestruturas", "cor3", "infra"),
  ];

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

  int utilizadorId = 1;

  @override
  void initState() {
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
        child: Padding(
          padding: EdgeInsets.only(
            top: altura * 0.01,
            left: largura * 0.02,
            right: largura * 0.02,
            bottom: altura * 0.01,
          ),
          child: Container(
            color: Theme.of(context).canvasColor,
            height: altura * 0.9,
            child: SingleChildScrollView(
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
                            fit: BoxFit.cover,
                            height: altura * 0.2,
                            width: double.infinity,
                            placeholder: MemoryImage(kTransparentImage),
                            image: const NetworkImage(
                                "https://pplware.sapo.pt/wp-content/uploads/2022/02/s_22_plus_1.jpg "),
                          ),
                        ),
                        SizedBox(height: altura * 0.02),
                        Row(children: [
                          Text(
                            pontoInteresse!.titulo,
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
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
                        DividerWithText(text: "Descrição"),
                        Text(pontoInteresse!.descricao),
                        DividerWithText(text: "Avaliação"),
                        const Row(
                          children: [],
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
                                      3,
                                      'Alice',
                                      'Johnson',
                                      'alice.johnson@example.com',
                                      'Some info',
                                      3,
                                      [1, 2],
                                      3,
                                      3),
                                  data: DateTime.now()
                                      .subtract(const Duration(days: 1)),
                                ),
                                Commentario(
                                  comentarioid: 4,
                                  comentario: 'This is the second comment.',
                                  autor: Utilizador(
                                      3,
                                      'Alice',
                                      'Johnson',
                                      'alice.johnson@example.com',
                                      'Some info',
                                      3,
                                      [1, 2],
                                      3,
                                      3),
                                  data: DateTime.now()
                                      .subtract(Duration(days: 2)),
                                ),
                                Commentario(
                                  comentarioid: 6,
                                  comentario:
                                      'This is the third comment with no subcomments.',
                                  autor: Utilizador(
                                      3,
                                      'Alice',
                                      'Johnson',
                                      'alice.johnson@example.com',
                                      'Some info',
                                      3,
                                      [1, 2],
                                      3,
                                      3),
                                  data: DateTime.now()
                                      .subtract(Duration(days: 3)),
                                ),
                                Commentario(
                                  comentarioid: 7,
                                  comentario: 'This is the fourth comment.',
                                  autor: Utilizador(
                                      3,
                                      'Alice',
                                      'Johnson',
                                      'alice.johnson@example.com',
                                      'Some info',
                                      3,
                                      [1, 2],
                                      3,
                                      3),
                                  data: DateTime.now()
                                      .subtract(Duration(days: 4)),
                                  subcomentarios: [
                                    Commentario(
                                      comentarioid: 8,
                                      comentario:
                                          'Subcomment to the fourth comment.',
                                      autor: Utilizador(
                                          3,
                                          'Alice',
                                          'Johnson',
                                          'alice.johnson@example.com',
                                          'Some info',
                                          3,
                                          [1, 2],
                                          3,
                                          3),
                                      data: DateTime.now().subtract(
                                          Duration(days: 4, hours: 1)),
                                    ),
                                    Commentario(
                                      comentarioid: 9,
                                      comentario:
                                          'Another subcomment to the fourth comment.',
                                      autor: Utilizador(
                                          3,
                                          'Alice',
                                          'Johnson',
                                          'alice.johnson@example.com',
                                          'Some info',
                                          3,
                                          [1, 2],
                                          3,
                                          3),
                                      data: DateTime.now().subtract(
                                          Duration(days: 4, hours: 2)),
                                    ),
                                    Commentario(
                                      comentarioid: 10,
                                      comentario:
                                          'Yet another subcomment to the fourth comment.',
                                      autor: Utilizador(
                                          3,
                                          'Alice',
                                          'Johnson',
                                          'alice.johnson@example.com',
                                          'Some info',
                                          3,
                                          [1, 2],
                                          3,
                                          3),
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
      ),
    );
  }
}
