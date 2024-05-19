import 'package:softshares_mobile/models/formularios_dinamicos/pergunta_formulario.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum TipoFormulario { inscr, qualidade }

class Formulario {
  String titulo;
  TipoFormulario tipoFormulario;
  List<Pergunta> perguntas;

  Formulario({
    required this.titulo,
    required this.tipoFormulario,
    required this.perguntas,
  });
}
