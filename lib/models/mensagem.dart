import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/models/grupo.dart';
import 'package:softshares_mobile/models/utilizador.dart';

class Mensagem {
  int? mensagemId;
  String mensagemTexto;
  Utilizador? remetente;
  Utilizador? destinatarioUtil;
  Grupo? destinatarioGrupo;
  DateTime? dataEnvio;
  List<String>? anexos = [];

  Mensagem({
    this.mensagemId,
    required this.mensagemTexto,
    this.remetente,
    this.destinatarioUtil,
    this.destinatarioGrupo,
    this.dataEnvio,
    this.anexos,
  });

  factory Mensagem.fromJson(Map<String, dynamic> json) {
    DateTime parseDate(String dateString) {
      try {
        return DateTime.parse(dateString);
      } catch (e) {
        return DateTime.now();
      }
    }

    return Mensagem(
      mensagemId: json['mensagemid'] ?? 0,
      mensagemTexto: json['mensagem'] ?? '',
      remetente: Utilizador.fromJsonSimplificado(json['remetente']),
      destinatarioUtil: json['destinatarioUtil'] != null
          ? Utilizador.fromJsonSimplificado(json['destinatarioUtil'])
          : null,
      destinatarioGrupo: json['destinatarioGrupo'] != null
          ? Grupo.fromJson(json['destinatarioGrupo'])
          : null,
      dataEnvio: json['datacriacao'] != null
          ? parseDate(json['datacriacao'])
          : DateTime.now(),
      anexos: json['anexos'] != null
          ? (json['anexos'] as List).map((e) => e.toString()).toList()
          : [],
    );
  }

  Future<Map<String, dynamic>> toJson() async {
    final prefs = await SharedPreferences.getInstance();
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    int utilizadorId = utilizador.utilizadorId;

    Map<String, dynamic> teste = {
      "idRemetente": utilizadorId,
      "idDestinatario": destinatarioUtil != null
          ? destinatarioUtil!.utilizadorId
          : destinatarioGrupo!.grupoId,
      "tipoDestinatario": destinatarioUtil != null ? "UT" : "GR",
      "mensagem": mensagemTexto,
      "imagem": []
    };
    print(teste);
    return teste;
  }
}
