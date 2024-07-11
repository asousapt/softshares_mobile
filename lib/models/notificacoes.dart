class Notificacao {
  final int notificacaoId;
  final String notificacao;
  bool vista;
  DateTime data;
  String tipo;
  int idregisto;

  Notificacao(
    this.notificacaoId,
    this.notificacao,
    this.vista,
    this.data,
    this.tipo,
    this.idregisto,
  );

  // Método que converte um json em um objeto Notificacao
  Notificacao.fromJson(Map<String, dynamic> json)
      : notificacaoId = json['notificacaoid'],
        notificacao = json['notificacao'],
        vista = json['vista'],
        data = DateTime.parse(json['datacriacao']),
        tipo = json['tipo'],
        idregisto = json['idregisto'];
}
