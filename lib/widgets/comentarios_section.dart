import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/comentario.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/time_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/services/api_service.dart';

class CommentSection extends StatefulWidget {
  const CommentSection({
    Key? key,
    required this.comentarios,
  }) : super(key: key);

  final List<Commentario> comentarios;

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ApiService api = ApiService();
  
  void _adicionaSubcomentario(Commentario commentario, String texto) {
    setState(() {
      /*commentario.subcomentarios.add(Commentario(
        comentarioid: 0,
        comentario: texto,
        autor: Utilizador(1, 'User', 'Surname', 'email@example.com',
            'some info', 1, [], 1, 1), // Replace with actual user
        data: DateTime.now(),
      ));*/
    });
  }

  void _reportComment(Commentario commentario) async {
    api.setAuthToken("tokenFixo");
    final prefs = await SharedPreferences.getInstance();
    String? utilJson = prefs.getString("utilizadorObj");
    Utilizador util = Utilizador.fromJson(jsonDecode(utilJson!));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController _reportController = TextEditingController();
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.denuciarComentario),
          content: SizedBox(
            width: double.maxFinite,
            child: Form(
              key: _formKey,
              child: TextFormField(
                  controller: _reportController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.colocarRazao,
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.campoObrigatorio;
                    }
                    return null;
                  }),
            ),
          ),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancelar),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.enviar),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Map<String, dynamic> data = {
                    "comentarioid" : commentario.comentarioid,
                    "utilizadorcriou" : util.utilizadorId,
                    "texto" : _reportController.text,
                  };
                  api.postRequest("denuncia/add", data);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.denunciaEnviada)));
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCommentario(Commentario comment) {
    TextEditingController _controller = TextEditingController();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(comment.autor),
                    Text(
                      dataFormatada('pt', comment.data),
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.flag),
                  onPressed: () => _reportComment(comment),
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(comment.comentario),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Add a comment...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _adicionaSubcomentario(comment, _controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
            ...comment.subcomentarios.map((subcomment) => Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: _buildCommentario(subcomment),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: widget.comentarios.map(_buildCommentario).toList(),
      ),
    );
  }
}
