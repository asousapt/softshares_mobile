class Notificacao {
  final int notificacaoId;
  final String notificacao;
  bool vista;
  DateTime data;

  Notificacao(
    this.notificacaoId,
    this.notificacao,
    this.vista,
    this.data,
  );

  // Método que converte um json em um objeto Notificacao
  Notificacao.fromJson(Map<String, dynamic> json)
      : notificacaoId = json['notificacaoid'],
        notificacao = json['notificacao'],
        vista = json['vista'],
        data = DateTime.parse(json['datacriacao']);
}
