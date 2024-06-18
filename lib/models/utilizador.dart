import 'package:softshares_mobile/services/api_service.dart';

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

  Utilizador(
    this.utilizadorId,
    this.pNome,
    this.uNome,
    this.email,
    this.sobre,
    this.poloId,
    this.preferencias,
    this.funcaoId,
    this.departamentoId, [
    this.fotoUrl,
  ]);

  Utilizador.simplificado(
    this.utilizadorId,
    this.pNome,
    this.uNome,
    this.email,
    this.poloId,
    this.fotoUrl,
  );

  /// Returns the full name of the user.
  String getNomeCompleto() {
    return "$pNome $uNome";
  }
}

// List of Utilizador instances
List<Utilizador> utilizadores = [
  Utilizador(
    1,
    'João',
    'Silva',
    'joao.silva@example.com',
    'Developer with a passion for mobile applications.',
    1,
    [1, 2],
    1,
    1,
    "https://via.placeholder.com/150",
  ),
  Utilizador(
    2,
    'Maria',
    'Fernandes',
    'maria.fernandes@example.com',
    'Experienced project manager.',
    1,
    [3, 4],
    2,
    1,
    "https://via.placeholder.com/150",
  ),
  Utilizador(
      3,
      'Carlos',
      'Santos',
      'carlos.santos@example.com',
      'Graphic designer specializing in UI/UX.',
      2,
      [5, 6],
      3,
      2,
      "https://via.placeholder.com/150"),
  Utilizador(
      4,
      'Ana',
      'Costa',
      'ana.costa@example.com',
      'Content writer and SEO expert.',
      2,
      [7, 8],
      4,
      2,
      "https://via.placeholder.com/150"),
];

// Busca um utilizador pelo id
Future<Utilizador> fetchUtilizadorById(int id) async {
  await Future.delayed(Duration(seconds: 2));

  return Utilizador(
    1,
    'João',
    'Silva',
    'joao.silva@example.com',
    'Developer with a passion for mobile applications.',
    1,
    [1, 2],
    1,
    1,
    "https://via.placeholder.com/150",
  );
}

// Funcao que busca a lista de utilizadores
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

// Funcao que transforma um json num Utilizador
Utilizador jsonToUtilizador(Map<String, dynamic> json) {

  final utilizadorId = json['utilizadorid'];
  final pNome = json['pnome'];
  final uNome = json['unome'];
  final email = json['email'];
  final sobre = json['sobre'];
  final poloId = json['poloid'];
  final preferencias = json['preferencias'] != null ? List<int>.from(json['preferencias']) : null;
  final funcaoId = json['funcaoid'];
  final departamentoId = json['departamentoid'];
  final fotoUrl = json['fotoUrl'];


  return Utilizador(
    json['utilizadorid'] as int,
    json['pnome'] as String,
    json['unome'] as String,
    json['email'] as String,
    json['sobre'] as String?,
    json['poloid'] as int,
    json['preferencias'] != null ? List<int>.from(json['preferencias']) : null,
    json['funcaoid'] as int?,
    json['departamentoid'] as int?,
    json['fotourl'] as String?,
  );
}

// Funcao que transforma um utilizador em JSON
Map<String, dynamic> utilizadorToJson(Utilizador utilizador) {
  return {
    'utilizadorId': utilizador.utilizadorId,
    'pNome': utilizador.pNome,
    'uNome': utilizador.uNome,
    'email': utilizador.email,
    'sobre': utilizador.sobre,
    'poloId': utilizador.poloId,
    'preferencias': utilizador.preferencias,
    'funcaoId': utilizador.funcaoId,
    'departamentoId': utilizador.departamentoId,
    'fotoUrl': utilizador.fotoUrl,
  };
}

List<Utilizador> jsonToUtilizadores(List<dynamic> json) {
  List<Utilizador> utilizadores = [];
  for (var utilizador in json) {
    utilizadores.add(jsonToUtilizador(utilizador));
  }
  return utilizadores;
}
