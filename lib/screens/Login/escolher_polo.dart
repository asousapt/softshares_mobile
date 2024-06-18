import "package:flutter/material.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/polo_repository.dart';
import 'package:softshares_mobile/models/polo.dart';
import '../../widgets/gerais/logo.dart';

class EcraEscolherPolo extends StatefulWidget {
  const EcraEscolherPolo({
    super.key,
  });

  @override
  State<EcraEscolherPolo> createState() {
    return __EcraEscolherPoloState();
  }
}

class __EcraEscolherPoloState extends State<EcraEscolherPolo> {
  PoloRepository poloRepository = PoloRepository();
  List<Polo> polos = [];
  bool isLoading = true;
  bool hasError = false;

  void atualizarDados() async {
    try {
      List<Polo> polosDB = await poloRepository.fetchPolosFromDb();
      setState(() {
        polos = polosDB;
        isLoading = false;
        hasError = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    atualizarDados();
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar:
          AppBar(title: Text(AppLocalizations.of(context)!.seleccionarPolo)),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: largura * 0.01, vertical: altura * 0.01),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(10)),
            height: altura * 0.85,
            child: Column(
              children: [
                Expanded(
                  child: isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : hasError
                          ? Center(
                              child: Text(
                                  AppLocalizations.of(context)!.ocorreuErro),
                            )
                          : ListView.builder(
                              itemCount: polos.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      onTap: () async {
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        await prefs.setInt(
                                            "poloId", polos[index].poloid);
                                        await prefs.setString(
                                            "polo", polos[index].descricao);
                                        Navigator.pushNamed(context, "/home");
                                      },
                                      title: Text(polos[index].descricao),
                                      trailing: const Icon(
                                          Icons.arrow_right_outlined),
                                    ),
                                    const Divider(
                                      color: Colors.black,
                                    )
                                  ],
                                );
                              },
                            ),
                ),
                Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * 0.03),
                    child: Logo())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
