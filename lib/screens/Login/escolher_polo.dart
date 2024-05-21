import "package:flutter/material.dart";
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/gerais/logo.dart';

class EcraEscolherPolo extends StatefulWidget {
  const EcraEscolherPolo({
    super.key,
    required this.mudaIdioma,
  });

  final Function(String idioma) mudaIdioma;

  @override
  State<EcraEscolherPolo> createState() {
    return __EcraEscolherPoloState();
  }
}

class __EcraEscolherPoloState extends State<EcraEscolherPolo> {
  String version = 'Loading...';
  String poloEscolhido = '';
  var polos = ['Coimbrões', 'Lisboa', 'Tomar'];
  int itemCount = 0;
  late TextEditingController controlCodigo;
  bool passwordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    itemCount = polos.length;
    return Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.of(context)!.seleccionarPolo)),
        body: Padding(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * 0.01,
              right: MediaQuery.of(context).size.height * 0.01,
              top: MediaQuery.of(context).size.height * 0.01),
          child: SingleChildScrollView(
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.circular(10)),
                  height: (MediaQuery.of(context).size.height) * 0.85,
                  child: Column(
                    children: [
                      Expanded(
                        child: itemCount > 0
                            ? ListView.builder(
                                itemCount: itemCount,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          poloEscolhido = polos[index];
                                          Navigator.pushNamed(context, "/home");
                                        },
                                        title: Text(polos[index]),
                                        trailing:
                                            Icon(Icons.arrow_right_outlined),
                                      ),
                                      Divider(
                                        color: Colors.black,
                                      )
                                    ],
                                  );
                                },
                              )
                            : const Center(child: Text('Não há polos')),
                      ),
                      Container(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).size.height * 0.03),
                          child: Logo())
                    ],
                  ))),
        ));
  }
}
