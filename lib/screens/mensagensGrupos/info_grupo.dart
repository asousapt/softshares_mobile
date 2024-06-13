import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/grupo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GrupoInfoScreen extends StatefulWidget {
  const GrupoInfoScreen({
    super.key,
    required this.grupoId,
  });

  final int grupoId;

  @override
  State<GrupoInfoScreen> createState() {
    return _GrupoInfoScreenState();
  }
}

class _GrupoInfoScreenState extends State<GrupoInfoScreen> {
  Grupo? grupo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    actualizaDados();
  }

  Future<void> actualizaDados() async {
    Grupo fetchedGrupo = await fetchGrupobyId(widget.grupoId);
    setState(() {
      grupo = fetchedGrupo;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.detalhesGrupo),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).canvasColor,
              ),
            )
          : Padding(
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
                              grupo!.imagem ??
                                  'https://via.placeholder.com/150',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: altura * 0.02),
                  Text(
                    grupo!.nome,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).canvasColor),
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
                        DefaultTabController(
                          length: 2,
                          child: Expanded(
                            child: Column(
                              children: [
                                TabBar(
                                  tabs: [
                                    Tab(
                                      text: "TAB 1",
                                    ),
                                    Tab(
                                      text: "Tab 2",
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      // Content for Tab 1
                                      Center(
                                        child: Text(
                                          "conteudo 1",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      // Content for Tab 2
                                      Center(
                                        child: Text(
                                          "conteudo 2",
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
