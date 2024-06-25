class Cidade {
  final int cidadeid;
  final String nome;

  Cidade({
    required this.cidadeid,
    required this.nome,
  });

  // constroi uma cidade a partir de um json
  factory Cidade.fromJson(Map<String, dynamic> json) {
    return Cidade(
      cidadeid: json['cidadeid'],
      nome: json['nome'],
    );
  }

  // converte uma cidade para json
  Map<String, dynamic> toJson() {
    return {
      'cidadeid': cidadeid,
      'nome': nome,
    };
  }
}
