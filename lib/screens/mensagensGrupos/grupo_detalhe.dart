import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/grupo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
            horizontal: largura * 0.02, vertical: altura * 0.02),
        child: Container(
          height: altura * 0.8,
          margin: EdgeInsets.symmetric(
              horizontal: largura * 0.02, vertical: altura * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: 250,
                  height: 150,
                  child: grupo.fotourls!.isEmpty
                      ? CircleAvatar(
                          radius: 180,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            grupo.nome[0].toUpperCase(),
                            style: TextStyle(
                              fontSize: 40,
                              color: Theme.of(context).canvasColor,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          radius: 180,
                          backgroundImage: NetworkImage(
                            grupo.fotourls![0],
                          )),
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
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).canvasColor,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: largura * 0.02, vertical: altura * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              grupo.descricao,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: altura * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child:
                                  Text(AppLocalizations.of(context)!.cancelar),
                            ),
                            SizedBox(width: largura * 0.02),
                            FilledButton(
                              onPressed: () {
                                // TODO: Implementar a função de juntar-se ao grupo
                                // falta ir buscar o id da mensagem
                                /*      Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MensagemDetalheScreen(
                                          mensagemId: 0,
                                          nome: "grupo.nome",
                                          imagemUrl: grupo.imagem!,
                                          msgGrupo: true),
                                    ),
                                  );*/
                              },
                              child: Text(
                                  AppLocalizations.of(context)!.juntarGrupo),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
