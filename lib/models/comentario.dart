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

  factory Commentario.fromJson(Map<String, dynamic> json) {
    return Commentario(
      comentarioid: json['comentarioid'],
      comentario: json['comentario'],
      autor: Utilizador.fromJson(json['autor']),
      data: DateTime.parse(json['data']),
      subcomentarios: (json['subcomentarios'] as List<dynamic>?)
          ?.map((subjson) => Commentario.fromJson(subjson))
          .toList() ?? [],
    );
  }
}
