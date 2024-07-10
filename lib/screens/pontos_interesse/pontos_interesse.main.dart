import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/categoria_repository.dart';
import 'package:softshares_mobile/models/ponto_de_interesse.dart';
import 'package:softshares_mobile/widgets/gerais/main_drawer.dart';
import 'package:softshares_mobile/widgets/gerais/bottom_navigation.dart';
import 'package:softshares_mobile/widgets/pontos__de_interesse/pontos_de_interesse_card.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/services/api_service.dart';

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
  List<Categoria> categoriasFiltro = [];
  int? _selectedRating;

  @override
  void initState() {
    super.initState();
    api.setAuthToken('tokenFixo');
    //api.fetchAuthToken(endpoint, credentials)
    carregaCategorias();
    fetchPontosDeInteresse();
  }

  // Carrega as categorias da base de dados local
  Future<void> carregaCategorias() async {
    final prefs = await SharedPreferences.getInstance();
    final idiomaId = prefs.getInt("idiomaId") ?? 1;
    CategoriaRepository categoriaRepository = CategoriaRepository();
    List<Categoria> categoriasdb =
        await categoriaRepository.fetchCategoriasDB(idiomaId);
    categoriasFiltro = List.from(categoriasdb);
    Categoria todos = Categoria(
        categoriaId: 0,
        descricao: AppLocalizations.of(context)!.todos,
        icone: "",
        cor: "",
        idiomaId: idiomaId);

    categoriasFiltro.add(todos);
    setState(() {
      categorias = categoriasdb;
    });
  }

  List<DropdownMenuItem<int>> buildRatingDropdownItems() {
    List<DropdownMenuItem<int>> items = [];
    for (int i = 5; i >= 1; i--) {
      items.add(DropdownMenuItem<int>(
        value: i,
        child: Text('$i'),
      ));
    }
    return items;
  }

  Future<void> fetchPontosDeInteresse() async {
    try {
      _isLoading = true;
      final lista = await api.getRequest('pontoInteresse/aprovados');
      final listaFormatted = lista['data'];
      if (listaFormatted is! List) {
        throw Exception("Failed to load data: Expected a list in 'data'");
      }

      // Parse the JSON data into a list of PontoInteresse objects
      List<PontoInteresse> listaUpdated =
          listaFormatted.map<PontoInteresse>((item) {
        try {
          return PontoInteresse.fromJson(item);
        } catch (e) {
          print("Error parsing item: $item");
          print("Error details: $e");
          rethrow;
        }
      }).toList();
      setState(() {
        listaPontosDeInteresse = List.from(listaUpdated);
        listaPontosDeInteresseFiltrados = listaPontosDeInteresse;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching data1: $e");
      // Handle error appropriately
    }
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
            }
          });
        },
        icon: Icon(_isSearching ? Icons.close : Icons.search),
      ),
      PopupMenuButton<String>(
        icon: const Icon(Icons.filter_list),
        onSelected: (String value) {
          filtraPorCategoria(value);
        },
        itemBuilder: (BuildContext context) => getCatLista(categoriasFiltro),
      ),
      IconButton(
      onPressed: () {
        // Reset selected rating when icon is tapped
        setState(() {
          _selectedRating = null;
          listaPontosDeInteresseFiltrados = listaPontosDeInteresse;
        });
      },
      icon: Icon(Icons.star),
    ),
    DropdownButton<int>(
      value: _selectedRating,
      onChanged: (int? newValue) {
        setState(() {
          _selectedRating = newValue;
          // Apply rating filter
          if (_selectedRating != null) {
            listaPontosDeInteresseFiltrados = listaPontosDeInteresse
                .where((element) => element.avaliacao == _selectedRating)
                .toList();
          } else {
            listaPontosDeInteresseFiltrados = listaPontosDeInteresse;
          }
        });
      },
      items: buildRatingDropdownItems(),
    )
    ];
  }

  void filtraPorCategoria(String categoria) {
    int cat = int.parse(categoria);

    setState(() {
      if (cat == 0) {
        listaPontosDeInteresseFiltrados = listaPontosDeInteresse;
      } else {
        listaPontosDeInteresseFiltrados =
            listaPontosDeInteresse.where((element) => element.categoriaId == cat).toList();
      }

      if (listaPontosDeInteresseFiltrados.isEmpty) {
        containerColorPontosDeInteresse = Theme.of(context).canvasColor;
      } else {
        containerColorPontosDeInteresse = Colors.transparent;
      }
    });
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
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).canvasColor,
            ))
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
