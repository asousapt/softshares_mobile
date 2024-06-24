import 'package:softshares_mobile/services/api_service.dart';
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
    return "${pNome[0]}${uNome[0]}".toUpperCase();
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

// List of Utilizador instances
List<Utilizador> utilizadores = [
  Utilizador(
    utilizadorId: 1,
    pNome: 'João',
    uNome: 'Silva',
    email: 'joao.silva@example.com',
    sobre: 'Developer with a passion for mobile applications.',
    poloId: 1,
    preferencias: [1, 2],
    funcaoId: 1,
    departamentoId: 1,
    fotoUrl: "https://via.placeholder.com/150",
  ),
  Utilizador(
    utilizadorId: 2,
    pNome: 'Maria',
    uNome: 'Fernandes',
    email: 'maria.fernandes@example.com',
    sobre: 'Experienced project manager.',
    poloId: 1,
    preferencias: [3, 4],
    funcaoId: 2,
    departamentoId: 1,
    fotoUrl: "https://via.placeholder.com/150",
  ),
  Utilizador(
    utilizadorId: 3,
    pNome: 'Carlos',
    uNome: 'Santos',
    email: 'carlos.santos@example.com',
    sobre: 'Graphic designer specializing in UI/UX.',
    poloId: 2,
    preferencias: [5, 6],
    funcaoId: 3,
    departamentoId: 2,
    fotoUrl: "https://via.placeholder.com/150",
  ),
  Utilizador(
    utilizadorId: 4,
    pNome: 'Ana',
    uNome: 'Costa',
    email: 'ana.costa@example.com',
    sobre: 'Content writer and SEO expert.',
    poloId: 2,
    preferencias: [7, 8],
    funcaoId: 4,
    departamentoId: 2,
    fotoUrl: "https://via.placeholder.com/150",
  ),
];

// Fetch a Utilizador by id
Future<Utilizador> fetchUtilizadorById(int id) async {
  await Future.delayed(Duration(seconds: 2));

  return Utilizador(
    utilizadorId: 1,
    pNome: 'João',
    uNome: 'Silva',
    email: 'joao.silva@example.com',
    sobre: 'Developer with a passion for mobile applications.',
    poloId: 1,
    preferencias: [1, 2],
    funcaoId: 1,
    departamentoId: 1,
    fotoUrl: "https://via.placeholder.com/150",
  );
}

// Function to fetch the list of Utilizadors
Future<List<Utilizador>> fetchUtilizadores() async {
  await Future.delayed(Duration(seconds: 2));

  return [
    Utilizador.simplificado(
      1,
      'João',
      'Silva',
      'joao.silva@example.com',
      1,
      "https://via.placeholder.com/150",
    ),
    Utilizador.simplificado(
      2,
      'Maria',
      'Fernandes',
      'maria.fernandes@example.com',
      1,
      "https://via.placeholder.com/150",
    ),
    Utilizador.simplificado(
      3,
      'Carlos',
      'Santos',
      'carlos.santos@example.com',
      2,
      "https://via.placeholder.com/150",
    ),
    Utilizador.simplificado(
      4,
      'Ana',
      'Costa',
      'ana.costa@example.com',
      2,
      "https://via.placeholder.com/150",
    ),
  ];
}
