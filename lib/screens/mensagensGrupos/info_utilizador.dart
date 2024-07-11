import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/Repositories/utilizador_repository.dart';
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
      UtilizadorRepository utilizadorRepository = UtilizadorRepository();
      Utilizador fetchUtil = await utilizadorRepository.getUtilizador(
        widget.utilizadorId.toString(),
      );

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
                    AppLocalizations.of(context)!.ocorreuErro,
                    style: const TextStyle(
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
                              utilizador!.fotoUrl!.isEmpty
                                  ? CircleAvatar(
                                      radius: 180,
                                      child: Text(
                                        utilizador!.getIniciais(),
                                        style: TextStyle(
                                          fontSize: 50,
                                          color: Theme.of(context).canvasColor,
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 180,
                                      backgroundImage: NetworkImage(
                                        utilizador!.fotoUrl!,
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
                                              ? Container()
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
