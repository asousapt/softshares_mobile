class Utilizador {
  int utilizadorId;
  String pNome;
  String uNome;
  String email;
  String sobre;
  int poloId;
  List<int> preferencias;
  int funcaoId;
  int departamentoId;

  Utilizador(
    this.utilizadorId,
    this.pNome,
    this.uNome,
    this.email,
    this.sobre,
    this.poloId,
    this.preferencias,
    this.funcaoId,
    this.departamentoId,
  );

  /// Returns the full name of the user.
  String getNomeCompleto() {
    return "$pNome $uNome";
  }
}
