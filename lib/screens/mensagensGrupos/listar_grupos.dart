import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/Repositories/grupo_repository.dart';
import 'package:softshares_mobile/models/grupo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/screens/mensagensGrupos/grupo_detalhe.dart';

class ListarGrupoScreen extends StatefulWidget {
  const ListarGrupoScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ListarGrupoScreenState();
  }
}

class _ListarGrupoScreenState extends State<ListarGrupoScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  bool _isSearching = false;
  List<Grupo> grupos = [];
  List<Grupo> listaGruposFiltrada = [];

  @override
  void initState() {
    super.initState();
    actualizaDados();
  }

  // Função que simula a obtenção de dados de grupos
  Future<void> actualizaDados() async {
    setState(() {
      _isLoading = true;
    });

    GrupoRepository grupoRepository = GrupoRepository();
    List<Grupo> gruposl = await grupoRepository.getGrupos();

    setState(() {
      listaGruposFiltrada = gruposl;
      grupos = gruposl;
      _isLoading = false;
    });
  }

  // Função que filtra a lista de grupos
  void filtraPorTexto(String texto) {
    listaGruposFiltrada = grupos;
    texto = texto.toLowerCase();
    setState(() {
      listaGruposFiltrada = grupos.where((element) {
        String descricaolower = element.nome.toLowerCase();

        return descricaolower.contains(texto);
      }).toList();
    });
  }

  List<Widget> _buildAppBarActions() {
    return [
      IconButton(
        onPressed: () {
          setState(() {
            _isSearching = !_isSearching;
            if (!_isSearching) {
              _searchController.clear();
            }
          });
        },
        icon: Icon(_isSearching ? Icons.close : Icons.search),
      ),
    ];
  }

  // constroi o widget de pesquisa
  Widget _buildSearchField() {
    return TextField(
      onChanged: (value) {
        filtraPorTexto(value);
      },
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "${AppLocalizations.of(context)!.procurar}...",
        border: InputBorder.none,
        suffixIcon: IconButton(
          icon: const Icon(FontAwesomeIcons.eraser),
          onPressed: () {
            setState(() {
              listaGruposFiltrada = grupos;
              _searchController.clear();
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.of(context).size.height;
    double largura = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? _buildSearchField()
            : Text(
                AppLocalizations.of(context)!.groups,
              ),
        actions: _buildAppBarActions(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: largura * 0.02, vertical: altura * 0.02),
        child: Container(
          height: altura * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).canvasColor,
          ),
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: largura * 0.02, vertical: altura * 0.02),
            child: Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: listaGruposFiltrada.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            bool sucesso = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GrupoDetalheScreen(
                                  grupo: listaGruposFiltrada[index],
                                ),
                              ),
                            );
                            if (sucesso) {
                              setState(() {
                                _isLoading = true;
                              });
                              GrupoRepository grupoRepository =
                                  GrupoRepository();

                              await grupoRepository.aderirGrupo(
                                  listaGruposFiltrada[index].grupoId!);
                              setState(() {
                                _isLoading = false;
                              });
                              actualizaDados();
                            }
                          },
                          child: ListTile(
                            leading: listaGruposFiltrada[index]
                                    .fotourls!
                                    .isEmpty
                                ? CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    child: Text(
                                      listaGruposFiltrada[index]
                                          .nome[0]
                                          .toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)!.canvasColor,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      listaGruposFiltrada[index].fotourls![0],
                                    ),
                                  ),
                            title: Text(
                              listaGruposFiltrada[index].descricao,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
