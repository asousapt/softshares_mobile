import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/models/grupo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/mensagem_detalhe.dart';

class GrupoDetalheScreen extends StatelessWidget {
  const GrupoDetalheScreen({
    super.key,
    required this.grupo,
  });

  final Grupo grupo;

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.detalhesGrupo),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: largura * 0.02, vertical: altura * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                width: 250,
                height: 150,
                child: Stack(
                  children: [
                    CircleAvatar(
                        radius: 180,
                        backgroundImage: NetworkImage(
                          grupo.imagem ?? 'https://via.placeholder.com/150',
                        )),
                    Positioned(
                      bottom: 0,
                      left: 150,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(217, 215, 215, 1),
                        ),
                        padding: const EdgeInsets.all(3),
                        child: IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.penToSquare,
                            size: 16,
                            color: Color.fromRGBO(29, 90, 161, 1),
                          ),
                          onPressed: () {
                            // TODO: Implementar a função de mudar a imagem
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: altura * 0.02),
            Text(
              grupo.nome,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: altura * 0.02),
            Container(
              width: double.infinity,
              height: altura * 0.6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).canvasColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    height: altura * 0.5,
                    margin: EdgeInsets.symmetric(
                        horizontal: largura * 0.02, vertical: altura * 0.02),
                    child: Text(
                      grupo.descricao,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        right: largura * 0.02, bottom: altura * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(AppLocalizations.of(context)!.cancelar),
                        ),
                        SizedBox(width: largura * 0.02),
                        FilledButton(
                          onPressed: () {
                            // TODO: Implementar a função de juntar-se ao grupo
                            // falta ir buscar o id da mensagem
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MensagemDetalheScreen(
                                    mensagemId: 0,
                                    nome: grupo.nome,
                                    imagemUrl: grupo.imagem!,
                                    msgGrupo: true),
                              ),
                            );
                          },
                          child:
                              Text(AppLocalizations.of(context)!.juntarGrupo),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
