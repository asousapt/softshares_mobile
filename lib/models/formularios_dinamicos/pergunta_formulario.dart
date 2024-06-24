enum TipoDados { logico, textoLivre, numerico, seleccao }

class Pergunta {
  int detalheId = 0;
  String pergunta;
  TipoDados tipoDados;
  bool obrigatorio = false;
  int min = 0;
  int max = 0;
  int tamanho;
  List<String> valoresPossiveis = [];
  int ordem;

  Pergunta({
    this.detalheId = 0,
    required this.pergunta,
    required this.tipoDados,
    required this.obrigatorio,
    required this.min,
    required this.max,
    required this.tamanho,
    required this.valoresPossiveis,
    required this.ordem,
  });

  factory Pergunta.fromJson(Map<String, dynamic> json) {
    return Pergunta(
      detalheId: json['detalheId'],
      pergunta: json['pergunta'],
      tipoDados: json['tipoDados'],
      obrigatorio: json['obrigatorio'],
      min: json['min'],
      max: json['max'],
      tamanho: json['tamanho'],
      valoresPossiveis: json['valoresPossiveis'].cast<String>(),
      ordem: json['ordem'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['detalheId'] = detalheId;
    data['pergunta'] = pergunta;
    data['tipoDados'] = tipoDados;
    data['obrigatorio'] = obrigatorio;
    data['min'] = min;
    data['max'] = max;
    data['tamanho'] = tamanho;
    data['valoresPossiveis'] = valoresPossiveis;
    data['ordem'] = ordem;
    return data;
  }
}
