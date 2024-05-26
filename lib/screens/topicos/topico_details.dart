import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/topico.dart';
import 'package:softshares_mobile/time_utils.dart';

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
  TextEditingController _respostaController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    final Topico topico = widget.topico!;
    final List<Categoria> categorias = widget.categorias!;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Tópico'),
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
            height: altura * 0.9,
            width: double.infinity,
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: altura * 0.02, horizontal: largura * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // topo do ecra
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
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
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      categorias
                          .firstWhere(
                            (element) =>
                                element.categoriaId == topico.categoria,
                          )
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: altura * 0.02, horizontal: largura * 0.02),
                    margin: EdgeInsets.symmetric(
                        vertical: altura * 0.02, horizontal: largura * 0.02),
                    height: altura * 0.33,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Color.fromRGBO(51, 57, 79, 1),
                    ),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundImage: NetworkImage(
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
                            style:
                                TextStyle(color: Theme.of(context).canvasColor),
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
                            child: Text("Responder"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: altura * 0.02),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
