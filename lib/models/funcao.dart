class Funcao {
  final int funcaoId;
  final String descricao;
  final int idiomaId;

  const Funcao(
    this.funcaoId,
    this.descricao,
    this.idiomaId,
  );

  factory Funcao.fromJson(Map<String, dynamic> json) {
    return Funcao(
      json['funcaoId'] as int,
      json['descricao'] as String,
      json['idiomaId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'funcaoId': funcaoId,
      'descricao': descricao,
      'idiomaId': idiomaId,
    };
  }
}
