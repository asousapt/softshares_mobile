import 'package:softshares_mobile/models/formularios_dinamicos/pergunta_formulario.dart';

enum TipoFormulario { inscr, qualidade }

class Formulario {
  final int formId;
  String titulo;
  TipoFormulario? tipoFormulario;
  List<Pergunta> perguntas;

  Formulario({
    required this.formId,
    required this.titulo,
    this.tipoFormulario,
    required this.perguntas,
  });

  factory Formulario.fromJson(Map<String, dynamic> json) {
    List<Pergunta> perguntas = [];
    if (json['perguntas'] != null) {
      json['perguntas'].forEach((v) {
        perguntas.add(Pergunta.fromJson(v));
      });
    }
    return Formulario(
      formId: json['formId'],
      titulo: json['titulo'],
      tipoFormulario: json['tipoFormulario'],
      perguntas: perguntas,
    );
  }

  // prepara o Json para o envio do form
  Map<String, dynamic> toJsonEnvio() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['descForm'] = titulo;
    data['perguntas'] = perguntas.map((v) => v.toJson()).toList();
    return data;
  }
}
