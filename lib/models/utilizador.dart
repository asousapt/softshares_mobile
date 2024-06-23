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

  // Utilizador para JSON
  Map<String, dynamic> toJson() {
    return {
      'utilizadorId': utilizadorId,
      'pNome': pNome,
      'uNome': uNome,
      'email': email,
      'sobre': sobre,
      'poloId': poloId,
      'preferencias': preferencias,
      'funcaoId': funcaoId,
      'departamentoId': departamentoId,
      'fotoUrl': fotoUrl,
    };
  }

  // Utilizador from JSON
  factory Utilizador.fromJson(Map<String, dynamic> json) {
    return Utilizador(
      json['utilizadorId'] ?? 0,
      json['pNome'] ?? '',
      json['uNome'] ?? '',
      json['email'] ?? '',
      json['sobre'],
      json['poloId'] ?? 0,
      json['preferencias'] != null ? List<int>.from(json['preferencias']) : null,
      json['funcaoId'],
      json['departamentoId'],
      json['fotoUrl'],
    );
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
