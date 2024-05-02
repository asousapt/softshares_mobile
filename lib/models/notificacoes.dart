class Notificacao {
  final int notificacaoId;
  final String notificacao;
  bool vista;

  Notificacao(
    this.notificacaoId,
    this.notificacao,
    this.vista,
  );

  void lerNotificacao() {
    vista = true;
  }
}
