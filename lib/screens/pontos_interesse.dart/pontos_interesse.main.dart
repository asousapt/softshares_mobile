import 'dart:async';

import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/ponto_de_interesse.dart';
import 'package:softshares_mobile/widgets/gerais/main_drawer.dart';
import 'package:softshares_mobile/widgets/gerais/bottom_navigation.dart';
import '../../widgets/pontos__de_interesse/pontos_de_interesse_card.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../services/api_service.dart';

class PontosDeInteresseMainScreen extends StatefulWidget {
  const PontosDeInteresseMainScreen({Key? key}) : super(key: key);

  @override
  _PontosDeInteresseMainScreenState createState() =>
      _PontosDeInteresseMainScreenState();
}

class _PontosDeInteresseMainScreenState
    extends State<PontosDeInteresseMainScreen> {
  TextEditingController _searchController = TextEditingController();
  List<PontoInteresse> listaPontosDeInteresse = [];
  List<PontoInteresse> listaPontosDeInteresseFiltrados = [];
  bool _isLoading = false;
  bool _isSearching = false;
  Color containerColorPontosDeInteresse = Colors.transparent;
  ApiService api = ApiService();
  bool defaultValues = false;
  List<Categoria> categorias = [];

  @override
  void initState() {
    super.initState();
    api.setAuthToken('tokenFixo');
    //api.fetchAuthToken(endpoint, credentials)

    if (defaultValues) {
      listaPontosDeInteresse = pontosDeInteresseTeste;
      listaPontosDeInteresseFiltrados = pontosDeInteresseTeste;
      categorias = categoriasTeste;
    } else {
      fetchPontosDeInteresse();
      fetchCategorias();
    }
  }

  Future<void> fetchPontosDeInteresse() async {
    try {
      _isLoading = true;
      final lista = await api.getRequest('pontoInteresse/');
      final listaFormatted = lista['data'];

      // Parse the JSON data into a list of PontoInteresse objects
      List<PontoInteresse> listaUpdated = (listaFormatted as List)
          .map((item) => PontoInteresse.fromJson(item))
          .toList();

      setState(() {
        listaPontosDeInteresse = List.from(listaUpdated);
        listaPontosDeInteresseFiltrados = listaPontosDeInteresse;
      });
      print("Agora mostra lista");
      print(lista);
    } catch (e) {
      print("Error fetching data: $e");
      // Handle error appropriately
    }
  }

  Future<void> fetchCategorias() async {
    try {
      final lista = await api.getRequest('categoria/');

      List<Categoria> listaUpdated = (lista as List)
          .map((item) => Categoria.fromJson(item))
          .toList();
    } catch (e) {
      print("Error fetching data: $e");
    }
    _isLoading = false;
  }

  void limparFiltro() {
    setState(() {
      listaPontosDeInteresseFiltrados = listaPontosDeInteresse;
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
              setState(() {
                listaPontosDeInteresseFiltrados = listaPontosDeInteresse;
              });
              containerColorPontosDeInteresse = Colors.transparent;
              print("Mostra lista de pontos de interesse");
              print(listaPontosDeInteresse);
            }
          });
        },
        icon: Icon(_isSearching ? Icons.close : Icons.search),
      ),
      PopupMenuButton<String>(
        icon: const Icon(Icons.filter_list),
        onSelected: (String value) {
          filtraPorTexto(value);
          print("Value is: " + value);
        },
        itemBuilder: (BuildContext context) => getCatLista(categorias),
      ),
    ];
  }

  void filtraPorTexto(String texto) {
    texto = texto.toLowerCase();
    setState(() {
      listaPontosDeInteresseFiltrados = listaPontosDeInteresse.where((element) {
        String descricaoLower = element.descricao.toLowerCase();
        String localizacaoLower = element.localizacao.toLowerCase();
        String tituloLower = element.titulo.toLowerCase();
        return descricaoLower.contains(texto) ||
            localizacaoLower.contains(texto) ||
            tituloLower.contains(texto);
      }).toList();

      if (listaPontosDeInteresseFiltrados.isEmpty) {
        containerColorPontosDeInteresse = Theme.of(context).canvasColor;
      } else {
        containerColorPontosDeInteresse = Colors.transparent;
      }
    });
    print("Value is: " + texto);
    print(listaPontosDeInteresseFiltrados);
  }

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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.pushNamed(context, '/criarPontoInteresse');
        },
        child: const Icon(
          FontAwesomeIcons.plus,
          color: Color.fromRGBO(217, 215, 215, 1),
        ),
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: const BottomNavigation(seleccao: 1),
      appBar: AppBar(
        title: _isSearching
            ? _buildSearchField()
            : Text(AppLocalizations.of(context)!.pontosInteresse),
        actions: _buildAppBarActions(),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator( color: Colors.red,))
          : listaPontosDeInteresseFiltrados.isEmpty
              ? Container(
                  height: altura * 0.8,
                  color: containerColorPontosDeInteresse,
                  child: Center(
                    child: Column(
                      children: [
                        Text(AppLocalizations.of(context)!.naoHaDados),
                      ],
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.all(10),
                  color: containerColorPontosDeInteresse,
                  child: ListView.builder(
                    itemCount: listaPontosDeInteresseFiltrados.length,
                    itemBuilder: (context, index) {
                      final pontoDeInteresse =
                          listaPontosDeInteresseFiltrados[index];
                      return InkWell(
                        enableFeedback: true,
                        child: PontoInteresseCard(
                          pontoInteresse: pontoDeInteresse,
                        ),
                        onTap: () {
                          Navigator.pushNamed(
                              context, '/consultarPontoInteresse',
                              arguments: {'PontoInteresse': pontoDeInteresse});
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
