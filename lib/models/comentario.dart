import 'package:shared_preferences/shared_preferences.dart';

class Commentario {
  final int? comentarioid;
  final String comentario;
  final String? autor;
  final DateTime? data;
  final List<Commentario>? subcomentarios;
  final String? fotoUrl;

  Commentario({
    this.comentarioid,
    required this.comentario,
    this.autor,
    this.data,
    this.subcomentarios = const [],
    this.fotoUrl,
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
      fotoUrl: json['fotoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson(
      String tipo, int comentarioPai, int utilizadoridl, int idRegisto) {
    return {
      'tipo': tipo,
      'comentario': comentario,
      'comentarioPai': comentarioPai,
      'utilizadorid': utilizadoridl,
      'idRegisto': idRegisto,
    };
  }
}
