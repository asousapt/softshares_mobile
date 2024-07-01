enum TipoDados { logico, textoLivre, numerico, seleccao, multiplaEscolha }

class Pergunta {
  int detalheId;
  String pergunta;
  TipoDados tipoDados;
  bool obrigatorio;
  int min;
  int max;
  int tamanho;
  List<String> valoresPossiveis;
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
      tipoDados: getTipoDadosEnum(json['tipoDados']),
      obrigatorio: json['obrigatorio'],
      min: json['min'],
      max: json['max'],
      tamanho: json['tamanho'],
      valoresPossiveis: List<String>.from(json['valoresPossiveis']),
      ordem: json['ordem'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['detalheId'] = detalheId;
    data['text'] = pergunta;
    data['type'] = getTipoDados();
    data['required'] = obrigatorio;
    data['minValue'] = min;
    data['maxValue'] = max;
    data['tamanho'] = tamanho;
    data['options'] = valoresPossiveis;
    data['order'] = ordem;
    return data;
  }

  String getTipoDados() {
    switch (tipoDados) {
      case TipoDados.logico:
        return 'LOGICO';
      case TipoDados.textoLivre:
        return 'TEXTO';
      case TipoDados.numerico:
        return 'NUMERICO';
      case TipoDados.seleccao:
        return 'SELECAO';
      case TipoDados.multiplaEscolha:
        return 'ESCOLHA_MULTIPLA';
      default:
        return 'TEXTO';
    }
  }

  static TipoDados getTipoDadosEnum(String tipo) {
    switch (tipo) {
      case 'LOGICO':
        return TipoDados.logico;
      case 'TEXTO':
        return TipoDados.textoLivre;
      case 'NUMERICO':
        return TipoDados.numerico;
      case 'SELECAO':
        return TipoDados.seleccao;
      case 'ESCOLHA_MULTIPLA':
        return TipoDados.multiplaEscolha;
      default:
        return TipoDados.textoLivre;
    }
  }
}
