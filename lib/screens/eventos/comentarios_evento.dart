import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/comentario_repository.dart';
import 'package:softshares_mobile/models/comentario.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/widgets/comentarios_section.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ComentariosScreen extends StatefulWidget {
  final Evento evento;
  const ComentariosScreen({
    super.key,
    required this.evento,
  });

  @override
  _ComentariosScreenState createState() => _ComentariosScreenState();
}

class _ComentariosScreenState extends State<ComentariosScreen> {
  bool isLoading = true;
  late Evento evento;
  late Utilizador user;
  final _respostaController = TextEditingController();

  @override
  void initState() {
    initializa();
    super.initState();
  }

  void dispose() {
    _respostaController.dispose();
    super.dispose();
  }

  void actualizar() {
    setState(() {});
  }

  Widget _buildResponseSection(
      BuildContext context, double altura, double largura, Evento evento) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: altura * 0.02, horizontal: largura * 0.02),
      margin: EdgeInsets.symmetric(
          vertical: altura * 0.02, horizontal: largura * 0.02),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Color.fromRGBO(51, 57, 79, 1),
      ),
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: user.fotoUrl!.isEmpty
                      ? null
                      : NetworkImage(user.fotoUrl!),
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
                      comentario, 'EVENTO', evento.eventoId!, 0);
                  if (result) {
                    _respostaController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content:
                            Text(AppLocalizations.of(context)!.dadosGravados),
                      ),
                    );
                  }
                }
              },
              child: Text(AppLocalizations.of(context)!.responder),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> initializa() async {
    final prefs = await SharedPreferences.getInstance();

    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    setState(() {
      user = utilizador;
      evento = widget.evento;
    });
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.comentarios),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: altura * 0.02, horizontal: largura * 0.02),
        child: Container(
          width: double.infinity,
          height: altura * 0.9,
          decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              _buildResponseSection(context, altura, largura, evento),
              SizedBox(height: altura * 0.02),
              CommentSection(tabela: "EVENTO", idRegisto: evento.eventoId!)
            ],
          ),
        ),
      ),
    );
  }
}
