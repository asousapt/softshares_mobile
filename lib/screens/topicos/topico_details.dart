import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/comentario_repository.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/comentario.dart';
import 'package:softshares_mobile/models/topico.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/info_utilizador.dart';
import 'package:softshares_mobile/time_utils.dart';
import 'package:softshares_mobile/widgets/comentarios_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/widgets/gerais/galeria_widget.dart';

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
  late String idioma;
  bool isLoading = false;
  late Utilizador user;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String idioma1 = prefs.getString('idioma') ?? 'pt';
    String util = prefs.getString('utilizadorObj') ?? '';
    Utilizador utilizadortmp = Utilizador.fromJson(jsonDecode(util));
    setState(() {
      idioma = idioma1;
      user = utilizadortmp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    final Topico topico = widget.topico!;
    final List<Categoria> categorias = widget.categorias!;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.detalhesTopico),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.shareNodes),
            onPressed: () {
              String partilha =
                  "${AppLocalizations.of(context)!.threads} - ${topico.titulo}";
              Share.share(partilha);
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).canvasColor,
            ))
          : Padding(
              padding: EdgeInsets.symmetric(
                  vertical: altura * 0.02, horizontal: largura * 0.02),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: altura * 0.02,
                              horizontal: largura * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // informacao do utilizador
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: _getUserImage(topico),
                                      backgroundColor: topico
                                              .utilizadorCriou!.fotoUrl!.isEmpty
                                          ? Theme.of(context).primaryColor
                                          : null,
                                      child: topico
                                              .utilizadorCriou!.fotoUrl!.isEmpty
                                          ? Text(
                                              topico.utilizadorCriou!
                                                  .getIniciais(),
                                              style: const TextStyle(
                                                fontSize: 40,
                                                color: Colors.white,
                                              ),
                                            )
                                          : null,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return UtilizadorInfoScreen(
                                              utilizadorId: user.utilizadorId,
                                              mostraGaleria: false,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: largura * 0.02),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        topico.utilizadorCriou!
                                            .getNomeCompleto(),
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        dataFormatada(
                                            idioma, topico.dataCriacao!),
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  categorias
                                      .firstWhere((element) =>
                                          element.categoriaId ==
                                          topico.categoria)
                                      .getIcone(),
                                ],
                              ),
                              SizedBox(height: altura * 0.02),
                              // Topic Title
                              Text(
                                topico.titulo,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(height: altura * 0.02),
                              GaleriaWidget(
                                urls:
                                    topico.imagem != null ? topico.imagem! : [],
                              ),
                              SizedBox(height: altura * 0.02),
                              // Topic Message
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
                                AppLocalizations.of(context)!.comentarios,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              _buildResponseSection(
                                  context, altura, largura, topico),
                              SizedBox(height: altura * 0.02),
                              Divider(
                                thickness: 7,
                                color: Theme.of(context).dividerColor,
                              ),
                              SizedBox(height: altura * 0.02),
                              // Comment Section
                              SizedBox(
                                height:
                                    altura * 0.3, // Adjust the height as needed
                                child: CommentSection(
                                    idRegisto: topico.topicoId!,
                                    tabela: 'THREAD'),
                              ),
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

  ImageProvider<Object>? _getUserImage(Topico topico) {
    if (topico.utilizadorCriou!.fotoUrl!.isEmpty) {
      return null;
    }
    if (topico.utilizadorCriou!.fotoUrl!.startsWith('http') ||
        topico.utilizadorCriou!.fotoUrl!.startsWith('https')) {
      return NetworkImage(topico.utilizadorCriou!.fotoUrl!);
    }
    return FileImage(File(topico.utilizadorCriou!.fotoUrl!));
  }

  Widget _buildResponseSection(
      BuildContext context, double altura, double largura, Topico topico) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: altura * 0.02, horizontal: largura * 0.02),
      margin: EdgeInsets.symmetric(
          vertical: altura * 0.02, horizontal: largura * 0.02),
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
                backgroundImage:
                    user.fotoUrl!.isEmpty ? null : NetworkImage(user.fotoUrl!),
                backgroundColor: user.fotoUrl!.isEmpty
                    ? Theme.of(context).primaryColor
                    : null,
                child: user.fotoUrl!.isEmpty
                    ? Text(
                        user.getIniciais(),
                        style: TextStyle(
                          fontSize: 36,
                          color: Theme.of(context).canvasColor,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: largura * 0.02),
              Text(
                user.getNomeCompleto(),
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
            style: TextStyle(color: Theme.of(context).canvasColor),
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.escreverResposta,
              hintStyle: TextStyle(color: Theme.of(context).canvasColor),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).canvasColor),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).canvasColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).canvasColor),
              ),
            ),
          ),
          SizedBox(height: altura * 0.02),
          ElevatedButton(
            onPressed: () async {
              // faz a inserçao de comentario
              if (_respostaController.text.isNotEmpty) {
                ComentarioRepository comentarioRepository =
                    ComentarioRepository();
                Commentario comentario = Commentario(
                  comentario: _respostaController.text,
                );
                bool result = await comentarioRepository.addComentario(
                    comentario, 'THREAD', topico.topicoId!, 0);
                if (result) {
                  _respostaController.clear();
                  setState(() {});
                }
              }
            },
            child: Text(AppLocalizations.of(context)!.responder),
          ),
        ],
      ),
    );
  }
}
