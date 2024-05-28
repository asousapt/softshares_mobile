import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/comentario.dart';
import 'package:softshares_mobile/models/topico.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/time_utils.dart';
import 'package:softshares_mobile/widgets/comentarios_section.dart';

class TopicoDetailsScreen extends StatefulWidget {
  const TopicoDetailsScreen({
    super.key,
    this.topico,
    this.categorias,
  });

  final Topico? topico;
  final List<Categoria>? categorias;

  @override
  State<TopicoDetailsScreen> createState() {
    return _TopicoDetailsScreenState();
  }
}

class _TopicoDetailsScreenState extends State<TopicoDetailsScreen> {
  final TextEditingController _respostaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    final Topico topico = widget.topico!;
    final List<Categoria> categorias = widget.categorias!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Tópico'),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: altura * 0.02, horizontal: largura * 0.02),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: altura * 0.02, horizontal: largura * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // topo do ecra
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: const NetworkImage(
                              'https://picsum.photos/250?image=9',
                            ),
                          ),
                          SizedBox(width: largura * 0.02),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topico.utilizadorId.getNomeCompleto(),
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                dataFormatada('pt', topico.dataCriacao!),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const Spacer(),
                          categorias
                              .firstWhere((element) =>
                                  element.categoriaId == topico.categoria)
                              .getIcone(),
                        ],
                      ),
                      SizedBox(height: altura * 0.02),
                      Text(
                        topico.titulo,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: altura * 0.02),
                      Text(
                        topico.mensagem,
                        style: const TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: altura * 0.02),
                      Divider(
                        thickness: 7,
                        color: Theme.of(context).dividerColor,
                      ),
                      SizedBox(height: altura * 0.02),
                      Text(
                        "Respostas",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: altura * 0.02,
                            horizontal: largura * 0.02),
                        margin: EdgeInsets.symmetric(
                            vertical: altura * 0.02,
                            horizontal: largura * 0.02),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color.fromRGBO(51, 57, 79, 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundImage: const NetworkImage(
                                    'https://picsum.photos/250?image=9',
                                  ),
                                ),
                                SizedBox(width: largura * 0.02),
                                Text(
                                  "Nome do Utilizador",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).canvasColor),
                                ),
                              ],
                            ),
                            SizedBox(height: altura * 0.02),
                            TextFormField(
                              maxLines: 3,
                              controller: _respostaController,
                              style: TextStyle(
                                  color: Theme.of(context).canvasColor),
                              decoration: InputDecoration(
                                hintText: "Escreva a sua resposta",
                                hintStyle: TextStyle(
                                    color: Theme.of(context).canvasColor),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).canvasColor),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).canvasColor),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).canvasColor),
                                ),
                              ),
                            ),
                            SizedBox(height: altura * 0.02),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text("Responder"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: altura * 0.02),
                      Divider(
                        thickness: 7,
                        color: Theme.of(context).dividerColor,
                      ),
                      SizedBox(height: altura * 0.02),
                      // Scrollable TextFormField Container
                      SizedBox(
                        height: altura * 0.3, // Adjust the height as needed
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
                              data: DateTime.now().subtract(Duration(days: 1)),
                              subcomentarios: [
                                Commentario(
                                  comentarioid: 2,
                                  comentario:
                                      'This is a subcomment to the first comment.',
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
                                      .subtract(Duration(hours: 20)),
                                ),
                                Commentario(
                                  comentarioid: 3,
                                  comentario:
                                      'Another subcomment to the first comment.',
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
                                      .subtract(Duration(hours: 18)),
                                ),
                              ],
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
                              data: DateTime.now().subtract(Duration(days: 2)),
                              subcomentarios: [
                                Commentario(
                                  comentarioid: 5,
                                  comentario:
                                      'Subcomment to the second comment.',
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
                                      .subtract(Duration(days: 1, hours: 12)),
                                ),
                              ],
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
                              data: DateTime.now().subtract(Duration(days: 3)),
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
                              data: DateTime.now().subtract(Duration(days: 4)),
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
                                  data: DateTime.now()
                                      .subtract(Duration(days: 4, hours: 1)),
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
                                  data: DateTime.now()
                                      .subtract(Duration(days: 4, hours: 2)),
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
                                  data: DateTime.now()
                                      .subtract(Duration(days: 4, hours: 3)),
                                ),
                              ],
                            ),
                          ],
                        )),
                      ),
                    ],
                  ),
                ),
                // Add your comment section widget here if needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
