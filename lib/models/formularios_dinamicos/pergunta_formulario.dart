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

  Pergunta.json(Map<String, dynamic> json)
      : detalheId = json['detalheId'],
        pergunta = json['pergunta'],
        tipoDados = json['tipoDados'],
        obrigatorio = json['obrigatorio'],
        min = json['min'],
        max = json['max'],
        tamanho = json['tamanho'],
        valoresPossiveis = json['valoresPossiveis'],
        ordem = json['ordem'];

  Map<String, dynamic> toJson() {
    return {
      'detalheId': detalheId,
      'pergunta': pergunta,
      'tipoDados': tipoDados,
      'obrigatorio': obrigatorio,
      'min': min,
      'max': max,
      'tamanho': tamanho,
      'valoresPossiveis': valoresPossiveis,
      'ordem': ordem,
    };
  }
}
