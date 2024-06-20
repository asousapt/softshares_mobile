import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/comentario.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/time_utils.dart';

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
                  children: [
                    Text(comment.autor.getNomeCompleto()),
                    Text(
                      dataFormatada('pt', comment.data),
                    ),
                  ],
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
