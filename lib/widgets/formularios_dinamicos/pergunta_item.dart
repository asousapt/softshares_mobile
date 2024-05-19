import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/formularios_dinamicos/pergunta_formulario.dart';
import 'package:softshares_mobile/l10n/app_localizations_extension.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PerguntaItem extends StatelessWidget {
  const PerguntaItem(this.pergunta, {super.key});

  final Pergunta pergunta;

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pergunta.pergunta,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: altura * 0.01),
            Row(
              children: [
                Text(AppLocalizations.of(context)!
                    .getTipoDadosValue(pergunta.tipoDados)),
                const Spacer(),
                Row(
                  children: [
                    Text(
                        "${AppLocalizations.of(context)!.posicao}: ${pergunta.ordem.toString()}"),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
