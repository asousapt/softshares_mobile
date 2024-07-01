import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/screens/generic/galeria_fotos.dart';

class UtilizadorInfoScreen extends StatefulWidget {
  const UtilizadorInfoScreen({
    super.key,
    required this.utilizadorId,
    required this.mostraGaleria,
  });

  final int utilizadorId;
  final bool mostraGaleria;

  @override
  State<UtilizadorInfoScreen> createState() {
    return _UtilizadorInfoScreenState();
  }
}

class _UtilizadorInfoScreenState extends State<UtilizadorInfoScreen> {
  Utilizador? utilizador;
  bool _isLoading = true;
  late bool mostraGaleria;

  @override
  void initState() {
    super.initState();
    actualizaDados();
  }

  Future<void> actualizaDados() async {
    setState(() {
      mostraGaleria = widget.mostraGaleria;
    });
    try {
      Utilizador fetchUtil = await fetchUtilizadorById(widget.utilizadorId);
      setState(() {
        utilizador = fetchUtil;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching utilizador: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

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
        title: Text(
          utilizador?.getNomeCompleto() ?? '',
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).canvasColor,
              ),
            )
          : utilizador == null
              ? Center(
                  child: Text(
                    'Utilizador not found',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
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
                                  utilizador!.fotoUrl ??
                                      'https://via.placeholder.com/150',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: altura * 0.02),
                      Text(
                        utilizador!.getNomeCompleto(),
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
                                          text: AppLocalizations.of(context)!
                                              .descricao,
                                        ),
                                        Tab(
                                          text: AppLocalizations.of(context)!
                                              .galeria,
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        children: [
                                          // Tab de descricao do utilizador
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: largura * 0.02,
                                                vertical: altura * 0.02),
                                            width: double.infinity,
                                            child: Text(
                                              utilizador!.sobre!,
                                            ),
                                          ),
                                          // Tab de galeria
                                          mostraGaleria
                                              ? FutureBuilder<List<String>>(
                                                  future: fetchGalleryImages(),
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return Center(
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
                                                              .ocorreuErro,
                                                        ),
                                                      );
                                                    } else if (!snapshot
                                                            .hasData ||
                                                        snapshot
                                                            .data!.isEmpty) {
                                                      return Center(
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)!
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
                                                        itemCount:
                                                            imageUrls.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return InkWell(
                                                            onTap: () => {
                                                              Navigator.of(
                                                                      context)
                                                                  .push(
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          PhotoGalleryScreen(
                                                                    imageUrls:
                                                                        imageUrls,
                                                                    initialIndex:
                                                                        index,
                                                                  ),
                                                                ),
                                                              ),
                                                            },
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                                  image:
                                                                      NetworkImage(
                                                                    imageUrls[
                                                                        index],
                                                                  ),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    }
                                                  },
                                                )
                                              : Container()
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
