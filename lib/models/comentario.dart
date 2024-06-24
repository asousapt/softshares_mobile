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
