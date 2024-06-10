import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:softshares_mobile/models/grupo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListarGrupoScreen extends StatefulWidget {
  const ListarGrupoScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ListarGrupoScreenState();
  }
}

class _ListarGrupoScreenState extends State<ListarGrupoScreen> {
  TextEditingController _searchController = TextEditingController();
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

    grupos = await fetchGrupos();

    setState(() {
      listaGruposFiltrada = grupos;
      _isLoading = false;
    });
  }

  // Função que filtra a lista de grupos
  void filtraPorTexto(String texto) {
    texto = texto.toLowerCase();
    setState(() {
      listaGruposFiltrada = grupos.where((element) {
        String descricaolower = element.descricao.toLowerCase();

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
        title: _isSearching ? _buildSearchField() : Text("Lista de Grupos"),
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
                          onTap: () {},
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                listaGruposFiltrada[index].imagem ??
                                    'https://via.placeholder.com/150',
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
