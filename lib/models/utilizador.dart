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

  Utilizador(this.utilizadorId, this.pNome, this.uNome, this.email, this.sobre,
      this.poloId, this.preferencias, this.funcaoId, this.departamentoId,
      [this.fotoUrl]);

  /// Returns the full name of the user.
  String getNomeCompleto() {
    return "$pNome $uNome";
  }
}

// List of Utilizador instances
final List<Utilizador> utilizadores = [
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
  ),
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
  ),
];
