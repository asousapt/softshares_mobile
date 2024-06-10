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
}
