import 'package:softshares_mobile/services/api_service.dart';
import 'package:softshares_mobile/services/database_service.dart';

class Idioma {
  final int? idiomaid;
  final String descricao;
  final String icone;

  Idioma({
    this.idiomaid,
    required this.descricao,
    required this.icone,
  });

  static Idioma idiomafromJson(Map<String, Object?> json) => Idioma(
        idiomaid: json['idiomaid'] as int?,
        descricao: json['descricao'] as String,
        icone: json['icone'] as String,
      );

  Map<String, Object?> idiomatoJson() => {
        'idiomaid': idiomaid,
        'descricao': descricao,
        'icone': icone,
      };
}
