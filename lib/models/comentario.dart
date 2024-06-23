import 'package:softshares_mobile/models/utilizador.dart';

class Commentario {
  final int comentarioid;
  final String comentario;
  final Utilizador autor;
  final DateTime data;
  final List<Commentario> subcomentarios;

  Commentario({
    required this.comentarioid,
    required this.comentario,
    required this.autor,
    required this.data,
    this.subcomentarios = const [],
  });
}

final List<Commentario> comentariosTeste = [
  Commentario(
    comentarioid: 1,
    comentario: 'This is the first comment.',
    autor: Utilizador(3, 'Alice', 'Johnson', 'alice.johnson@example.com',
        'Some info', 3, [1, 2], 3, 3),
    data: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Commentario(
    comentarioid: 4,
    comentario: 'This is the second comment.',
    autor: Utilizador(3, 'Alice', 'Johnson', 'alice.johnson@example.com',
        'Some info', 3, [1, 2], 3, 3),
    data: DateTime.now().subtract(Duration(days: 2)),
  ),
  Commentario(
    comentarioid: 6,
    comentario: 'This is the third comment with no subcomments.',
    autor: Utilizador(3, 'Alice', 'Johnson', 'alice.johnson@example.com',
        'Some info', 3, [1, 2], 3, 3),
    data: DateTime.now().subtract(Duration(days: 3)),
  ),
  Commentario(
    comentarioid: 7,
    comentario: 'This is the fourth comment.',
    autor: Utilizador(3, 'Alice', 'Johnson', 'alice.johnson@example.com',
        'Some info', 3, [1, 2], 3, 3),
    data: DateTime.now().subtract(Duration(days: 4)),
    subcomentarios: [
      Commentario(
        comentarioid: 8,
        comentario: 'Subcomment to the fourth comment.',
        autor: Utilizador(3, 'Alice', 'Johnson', 'alice.johnson@example.com',
            'Some info', 3, [1, 2], 3, 3),
        data: DateTime.now().subtract(Duration(days: 4, hours: 1)),
      ),
      Commentario(
        comentarioid: 9,
        comentario: 'Another subcomment to the fourth comment.',
        autor: Utilizador(3, 'Alice', 'Johnson', 'alice.johnson@example.com',
            'Some info', 3, [1, 2], 3, 3),
        data: DateTime.now().subtract(Duration(days: 4, hours: 2)),
      ),
      Commentario(
        comentarioid: 10,
        comentario: 'Yet another subcomment to the fourth comment.',
        autor: Utilizador(3, 'Alice', 'Johnson', 'alice.johnson@example.com',
            'Some info', 3, [1, 2], 3, 3),
        data: DateTime.now().subtract(Duration(days: 4, hours: 3)),
      ),
    ],
  ),
];
