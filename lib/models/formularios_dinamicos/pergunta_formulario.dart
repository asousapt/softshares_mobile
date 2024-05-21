enum TipoDados { logico, textoLivre, numerico, seleccao }

class Pergunta {
  String pergunta;
  TipoDados tipoDados;
  bool obrigatorio = false;
  int min = 0;
  int max = 0;
  int tamanho;
  List<String> valoresPossiveis = [];
  int ordem;

  Pergunta({
    required this.pergunta,
    required this.tipoDados,
    required this.obrigatorio,
    required this.min,
    required this.max,
    required this.tamanho,
    required this.valoresPossiveis,
    required this.ordem,
  });
}
