import 'package:softshares_mobile/models/grupo.dart';
import 'package:softshares_mobile/models/utilizador.dart';

class Mensagem {
  int? mensagemId;
  String mensagemTexto;
  Utilizador remetente;
  Utilizador? destinatarioUtil;
  Grupo? destinatarioGrupo;
  DateTime dataEnvio;
  List<String> anexos = [];

  Mensagem({
    this.mensagemId,
    required this.mensagemTexto,
    required this.remetente,
    this.destinatarioUtil,
    this.destinatarioGrupo,
    required this.dataEnvio,
    required this.anexos,
  });

  factory Mensagem.fromJson(Map<String, dynamic> json) {
    return Mensagem(
      mensagemId: json['mensagemid'] ?? 0,
      mensagemTexto: json['mensagem'] ?? '',
      remetente: Utilizador.fromJsonSimplificado(json['remetente']),
      destinatarioUtil: json['destinatarioUtil'] != null
          ? Utilizador.fromJson(json['destinatarioUtil'])
          : null,
      destinatarioGrupo: json['destinatarioGrupo'] != null
          ? Grupo.fromJson(json['destinatarioGrupo'])
          : null,
      dataEnvio: DateTime.parse(json['dataEnvio']),
      anexos: json['anexos'] != null
          ? (json['anexos'] as List).map((e) => e.toString()).toList()
          : [],
    );
  }
}
