import 'package:softshares_mobile/models/utilizador.dart';

class Commentario {
  final int comentarioid;
  final String comentario;
  final String autor;
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
      comentarioid: json['comentarioid'] ?? 0,
      comentario: json['comentario'] ?? '',
      autor: json['utilizador_nome'] ?? '',
      data: json.containsKey('data') && json['data'] != null
          ? DateTime.parse(json['data'])
          : DateTime.now(),
      subcomentarios: json['respostas'] != null
          ? (json['respostas'] as List<dynamic>)
              .map((subjson) => Commentario.fromJson(subjson))
              .toList()
          : [],
    );
  }
}
