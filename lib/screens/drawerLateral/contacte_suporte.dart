import 'package:flutter/material.dart';
import 'package:softshares_mobile/widgets/gerais/dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactSupport extends StatefulWidget {
  const ContactSupport({super.key});

  @override
  State<ContactSupport> createState() {
    return _ContactSupportState();
  }
}

class _ContactSupportState extends State<ContactSupport> {
  final assuntoController = TextEditingController();
  final mensagemController = TextEditingController();

  String? assunto;
  String? mensagem;

  @override
  void initState() {
    super.initState();
    assuntoController.text = "";
    mensagemController.text = "";
    assunto = "";
    mensagem = "";
  }

  Future<bool> confirmExit(BuildContext context) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        titulo: AppLocalizations.of(context)!.sairSuporte,
        msg: AppLocalizations.of(context)!.msgSairSuporte,
      ),
    );
    return confirm ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          if (assunto!.isEmpty && mensagem!.isEmpty) {
            Navigator.of(context).pop();
          } else {
            Future<bool> confirma = confirmExit(context);

            confirma.then((value) {
              if (value) {
                Navigator.of(context).pop();
              }
            });
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.contacteSuporte),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(right: 12, left: 12, top: 15, bottom: 20),
          child: Container(
            color: Theme.of(context).canvasColor,
            child: Container(
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
                top: 25,
                bottom: 10,
              ),
              child: SingleChildScrollView(
                child: Expanded(
                  child: Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.text,
                        controller: assuntoController,
                        decoration: InputDecoration(
                            label: Text(AppLocalizations.of(context)!.assunto)),
                        onChanged: (value) {
                          setState(() {
                            assunto = assuntoController.text;
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.text,
                        controller: mensagemController,
                        maxLines: 19,
                        decoration: InputDecoration(
                            label:
                                Text(AppLocalizations.of(context)!.mensagem)),
                        onChanged: (value) {
                          setState(() {
                            mensagem = mensagemController.text;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (assunto!.isEmpty && mensagem!.isEmpty) {
                                Navigator.of(context).pop();
                              } else {
                                Future<bool> confirma = confirmExit(context);

                                confirma.then((value) {
                                  if (value) {
                                    Navigator.of(context).pop();
                                  }
                                });
                              }
                            },
                            child: Text(AppLocalizations.of(context)!.cancelar),
                          ),
                          const SizedBox(width: 20),
                          FilledButton(
                            onPressed: () {},
                            child: Text(AppLocalizations.of(context)!.enviar),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
