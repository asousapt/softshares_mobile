import 'dart:convert';

import 'package:softshares_mobile/models/imagem.dart';

class Utilizador {
  int utilizadorId;
  String pNome;
  String uNome;
  String email;
  String? sobre;
  int poloId;
  List<int>? preferencias;
  int? funcaoId;
  int? departamentoId;
  String? fotoUrl;
  Imagem? fotoEnvio;
  int? idiomaId;

  Utilizador({
    required this.utilizadorId,
    required this.pNome,
    required this.uNome,
    required this.email,
    this.sobre,
    required this.poloId,
    this.preferencias,
    this.funcaoId,
    this.departamentoId,
    this.fotoUrl,
    this.fotoEnvio,
    this.idiomaId,
  });

  // retorna o nome completo do utilizador
  String getNomeCompleto() {
    return "$pNome $uNome";
  }

  // retorna  as iniciais do utilizador
  String getIniciais() {
    return "${pNome[0]} ${uNome[0]}".toUpperCase();
  }

  // Utilizador para JSON
  Map<String, dynamic> toJson() {
    return {
      'utilizadorid': utilizadorId,
      'pnome': pNome,
      'unome': uNome,
      'email': email,
      'sobre': sobre,
      'poloid': poloId,
      'preferencias': preferencias,
      'funcaoid': funcaoId,
      'departamentoid': departamentoId,
      'fotoUrl': fotoUrl,
      'fotoEnvio': fotoEnvio?.toJson(),
      'idiomaid': idiomaId,
    };
  }

  Map<String, dynamic> toJsonGrupo() {
    return {
      'id': utilizadorId,
      'pnome': pNome,
      'unome': uNome,
      'email': email,
      'sobre': sobre,
      'poloid': poloId,
      'preferencias': preferencias,
      'funcaoid': funcaoId,
      'departamentoid': departamentoId,
      'fotoUrl': fotoUrl,
      'fotoEnvio': fotoEnvio?.toJson(),
      'idiomaid': idiomaId,
    };
  }

  Map<String, dynamic> toJsonEnvio() {
    List<Map<String, dynamic>> listaImagens = [];
    if (fotoEnvio != null) {
      listaImagens.add(fotoEnvio!.toJson());
    }

    return {
      'pnome': pNome,
      'unome': uNome,
      'email': email,
      'sobre': sobre,
      'poloid': poloId,
      'preferencias': preferencias,
      'funcaoid': funcaoId,
      'departamentoid': departamentoId,
      'imagem': jsonEncode(listaImagens),
      'idiomaid': idiomaId,
    };
  }

  // Utilizador from JSON
  factory Utilizador.fromJson(Map<String, dynamic> json) {
    return Utilizador(
      utilizadorId: json['utilizadorid'],
      pNome: json['pnome'],
      uNome: json['unome'],
      email: json['email'],
      sobre: json['sobre'],
      poloId: json['poloid'],
      preferencias: json['preferencias'] != null
          ? (json['preferencias'] as List<dynamic>)
              .map((e) => e as int)
              .toList()
          : null,
      funcaoId: json['funcaoid'],
      departamentoId: json['departamentoid'],
      fotoUrl: json['fotoUrl'],
      fotoEnvio: json['imagem'] != null
          ? Imagem.fromJson(json['imagem'])
          : json['fotoEnvio'] != null
              ? Imagem.fromJson(json['fotoEnvio'])
              : null,
      idiomaId: json['idiomaid'],
    );
  }

  factory Utilizador.fromJsonSimplificado(Map<String, dynamic> json) {
    return Utilizador(
      utilizadorId: json['utilizadorid'] ?? 0,
      pNome: json['pnome'] ?? '',
      uNome: json['unome'] ?? '',
      email: json['email'] ?? '',
      poloId: json['poloid'] ?? 0,
      fotoUrl: json['fotoUrl'] ?? '',
    );
  }

  // Simplified constructor for the list example
  Utilizador.simplificado(
    this.utilizadorId,
    this.pNome,
    this.uNome,
    this.email,
    this.poloId,
    this.fotoUrl,
  );
}
