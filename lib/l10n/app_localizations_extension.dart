import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/formulario.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/pergunta_formulario.dart';

extension AppLocalizationsExtension on AppLocalizations {
  String getEnumValue(TipoFormulario tipo) {
    switch (tipo) {
      case TipoFormulario.inscr:
        return inscr;
      case TipoFormulario.qualidade:
        return qualidade;
      default:
        return '';
    }
  }

  String getTipoDadosValue(TipoDados tipo) {
    switch (tipo) {
      case TipoDados.textoLivre:
        return textoLivre;
      case TipoDados.numerico:
        return numerico;
      case TipoDados.seleccao:
        return seleccao;
      case TipoDados.logico:
        return logico;
      default:
        return '';
    }
  }
}
