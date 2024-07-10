import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/comentario.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/time_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/services/api_service.dart';
import 'package:softshares_mobile/widgets/pontos__de_interesse/escolherRating.dart';

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
  Utilizador? util;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    carregaDados();
  }

  Future<int> _fetchRatingData(Commentario comment) async {
    // Replace this with your actual API call logic
    final response = await api.getRequest(
        'avaliacao/comentario/${comment!.comentarioid}/utilizador/${util!.utilizadorId}');
    if (response['data'] == 0) return response['data'];
    return response['data']['avaliacao'];
  }

  void carregaDados() async {
    final prefs = await SharedPreferences.getInstance();
    String? utilJson = prefs.getString("utilizadorObj");
    setState(() {
      util = Utilizador.fromJson(jsonDecode(utilJson!));
      _isLoading = false;
    });
  }

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
                    "comentarioid": commentario.comentarioid,
                    "utilizadorcriou": util.utilizadorId,
                    "texto": _reportController.text,
                  };
                  api.postRequest("denuncia/add", data);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content:
                          Text(AppLocalizations.of(context)!.denunciaEnviada)));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void enviarAvaliacao(int oldRating, int newRating, int idComentario) async {
    String message = '';
    final Map<String, dynamic> criarAvaliacaoJson = {
      "tipo": "COMENTARIO",
      "idRegisto": idComentario,
      "utilizadorid": util!.utilizadorId,
      "avaliacao": newRating,
    };
    final Map<String, dynamic> atualizarAvaliacaoJson = {
      "utilizadorid": util!.utilizadorId,
      "avaliacao": newRating,
    };
    if (oldRating != 0) {
      message += AppLocalizations.of(context)!.avaliacaoAtualizada;
      await api.putRequest(
          "avaliacao/update/COMENTARIO/$idComentario", atualizarAvaliacaoJson);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Update")));
    } else {
      message += AppLocalizations.of(context)!.avaliacaoCriada;
      await api.postRequest("avaliacao/add", criarAvaliacaoJson);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Criar")));
    }
  }

  Widget _buildCommentario(Commentario comment, int rating) {
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
            RatingPicker(
              initialRating: rating,
              onRatingSelected: (newRating) {
                enviarAvaliacao(rating, newRating, comment.comentarioid);
              },
            ),
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
                  child: FutureBuilder<int>(
                    future: _fetchRatingData(subcomment),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final data = snapshot.data!;
                        int subRating = data ?? 0;
                        return _buildCommentario(subcomment, subRating);
                      }
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
            color: Colors.white,
          ))
        : Expanded(
            child: ListView(
              children: widget.comentarios.map((comment) {
                return FutureBuilder<int>(
                  future: _fetchRatingData(comment),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      final data = snapshot.data!;
                      int rating = data ?? 0;
                      return _buildCommentario(comment, rating);
                    }
                  },
                );
              }).toList(),
            ),
          );
  }
}
