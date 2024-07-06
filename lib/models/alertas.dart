class Alerta {
  final int alertaId;
  final String alerta;
  final DateTime datacriacao;

  Alerta(
    this.alertaId,
    this.alerta,
    this.datacriacao,
  );

  Alerta.fromJson(Map<String, dynamic> json)
      : alertaId = json['alertaid'],
        alerta = json['texto'],
        datacriacao = DateTime.parse(json['datacriacao']);
}
