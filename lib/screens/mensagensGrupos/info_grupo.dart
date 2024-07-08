import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/grupo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/screens/generic/galeria_fotos.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/criar_grupo.dart';

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
  int utilizadorId = 1;

  @override
  void initState() {
    super.initState();
    actualizaDados();
  }

  Future<void> actualizaDados() async {
    // Grupo fetchedGrupo = await fetchGrupobyId(widget.grupoId);
    setState(() {
      //grupo = fetchedGrupo;
      _isLoading = false;
    });
  }

  // Funcao para buscar o grupo pelo id
  Future<List<String>> fetchGalleryImages() async {
    await Future.delayed(Duration(seconds: 2));

    // Dummy list de imagens
    return List.generate(
      12,
      (index) => 'https://via.placeholder.com/150?text=Image+$index',
    );
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
                          /*
                          CircleAvatar(
                            radius: 180,
                            backgroundImage: NetworkImage(
                              grupo!.imagem ??
                                  'https://via.placeholder.com/150',
                            ),
                          ),
                       */
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: altura * 0.02),
                  Text(
                    "grupo!.nome",
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
                          length: 3,
                          child: Expanded(
                            child: Column(
                              children: [
                                TabBar(
                                  tabs: [
                                    Tab(
                                      text: AppLocalizations.of(context)!
                                          .descricao,
                                    ),
                                    Tab(
                                      text:
                                          AppLocalizations.of(context)!.membros,
                                    ),
                                    Tab(
                                      text:
                                          AppLocalizations.of(context)!.galeria,
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      // Tab de descricao do grupo
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: largura * 0.02,
                                            vertical: altura * 0.02),
                                        width: double.infinity,
                                        child: Text(grupo!.descricao),
                                      ),
                                      // Tab de membros do grupo
                                      Column(
                                        children: [
                                          Expanded(
                                            child: ListView(
                                              children: grupo!.utilizadores!
                                                  .map(
                                                    (utilizador) => ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                          utilizador.fotoUrl ??
                                                              'https://via.placeholder.com/150',
                                                        ),
                                                      ),
                                                      title: Text(
                                                        utilizador
                                                            .getNomeCompleto(),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Tab de galeria
                                      FutureBuilder<List<String>>(
                                        future: fetchGalleryImages(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Center(
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .ocorreuErro,
                                              ),
                                            );
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return Center(
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .galeriaVazia,
                                              ),
                                            );
                                          } else {
                                            List<String> imageUrls =
                                                snapshot.data!;
                                            return GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 4.0,
                                                mainAxisSpacing: 4.0,
                                              ),
                                              itemCount: imageUrls.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () => {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PhotoGalleryScreen(
                                                          imageUrls: imageUrls,
                                                          initialIndex: index,
                                                        ),
                                                      ),
                                                    ),
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          imageUrls[index],
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: altura * 0.02),
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: largura * 0.02),
                          width: double.infinity,
                          child: grupo!.utilizadorCriouId == utilizadorId
                              ? FilledButton(
                                  onPressed: () {
                                    if (grupo != null) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CriarGrupoScreen(
                                            editar: true,
                                            existingGroup: grupo!,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: Text(AppLocalizations.of(context)!
                                      .editarGrupo),
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.red, // Button background color
                                  ),
                                  onPressed: () {},
                                  child: Text(
                                    AppLocalizations.of(context)!.sairGrupo,
                                    style: TextStyle(
                                        color: Theme.of(context).canvasColor),
                                  ),
                                ),
                        ),
                        SizedBox(height: altura * 0.02),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
