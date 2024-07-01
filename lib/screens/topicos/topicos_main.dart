import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/categoria_repository.dart';
import 'package:softshares_mobile/Repositories/topico_repository.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/topico.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/screens/topicos/topico_details.dart';
import 'package:softshares_mobile/widgets/gerais/bottom_navigation.dart';
import 'package:softshares_mobile/widgets/gerais/main_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:softshares_mobile/widgets/topico/topico_item.dart';
import 'package:softshares_mobile/services/api_service.dart';

class TopicosListaScreen extends StatefulWidget {
  const TopicosListaScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _TopicosListaScreenState();
  }
}

class _TopicosListaScreenState extends State<TopicosListaScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isLoading = false;
  List<Topico> listaEvFiltrada = [];
  List<Topico> listaTopicos = [];
  Color containerColorTopicos = Colors.transparent;
  List<Categoria> categoriasFiltro = [];
  List<Categoria> categorias = [];
  ApiService api = ApiService();

  // Busca as categorias do idioma selecionado
  Future<void> carregaCategorias() async {
    final prefs = await SharedPreferences.getInstance();
    final idiomaId = prefs.getInt("idiomaId") ?? 1;
    CategoriaRepository categoriaRepository = CategoriaRepository();
    categorias = await categoriaRepository.fetchCategoriasDB(idiomaId);
    categoriasFiltro = List.from(categorias);
    Categoria todos = Categoria(
        categoriaId: 0,
        descricao: AppLocalizations.of(context)!.todos,
        icone: "",
        cor: "",
        idiomaId: idiomaId);

    categoriasFiltro.add(todos);
  }

  Future<List<Topico>> fetchTopicos() async {

    List<Topico> topicos = [];
    try {
      _isLoading = true;
      final lista = await api.getRequest('thread/');
      final listaFormatted = lista['data'];
      if (listaFormatted is! List) {
        throw Exception("Failed to load data: Expected a list in 'data'");
      }

      // Parse the JSON data into a list of PontoInteresse objects
      List<Topico> listaUpdated =
          listaFormatted.map<Topico>((item) {
        try {
          return Topico.fromJson(item);
        } catch (e) {
          print("Error parsing item: $item");
          print("Error details: $e");
          rethrow;
        }
      }).toList();
      setState(() {
        listaTopicos = List.from(listaUpdated);
        listaEvFiltrada = listaTopicos;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching data1: $e");
      // Handle error appropriately
    }
    return topicos;
  }

  @override
  void initState() {
    super.initState();
    api.setAuthToken("tokenFixo");
    actualizaDados();
  }

  Future<void> actualizaDados() async {
    carregaCategorias();
    setState(() {
      _isLoading = true;
    });

    listaTopicos = await fetchTopicos();
    setState(() {
      listaEvFiltrada = listaTopicos;

      if (listaTopicos.isEmpty) {
        containerColorTopicos = Theme.of(context).canvasColor;
      } else {
        containerColorTopicos = Colors.transparent;
      }

      _isLoading = false;
    });
  }

  // Constroi a barra de pesquisa
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
      PopupMenuButton<String>(
        icon: const Icon(Icons.filter_list),
        onSelected: (String value) {
          filtraPorCategoria(value);
        },
        itemBuilder: (BuildContext context) => getCatLista(categoriasFiltro),
      ),
    ];
  }

  // Efectua filtro por categoria
  void filtraPorCategoria(String categoria) {
    int cat = int.parse(categoria);

    setState(() {
      if (cat == 0) {
        listaEvFiltrada = listaTopicos;
      } else {
        listaEvFiltrada =
            listaTopicos.where((element) => element.categoria == cat).toList();
      }

      if (listaEvFiltrada.isEmpty) {
        containerColorTopicos = Theme.of(context).canvasColor;
      } else {
        containerColorTopicos = Colors.transparent;
      }
    });
  }

  // faz filtro por texto
  void filtraPorTexto(String texto) {
    texto = texto.toLowerCase();
    setState(() {
      listaEvFiltrada = listaTopicos.where((element) {
        String tituloLower = element.titulo.toLowerCase();
        String mensagemLower = element.mensagem.toLowerCase();

        return mensagemLower.contains(texto) || tituloLower.contains(texto);
      }).toList();

      if (listaEvFiltrada.isEmpty) {
        containerColorTopicos = Theme.of(context).canvasColor;
      } else {
        containerColorTopicos = Colors.transparent;
      }
    });
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
          Navigator.pushNamed(context, '/criarTopico');
        },
        child: const Icon(
          FontAwesomeIcons.plus,
          color: Color.fromRGBO(217, 215, 215, 1),
        ),
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: const BottomNavigation(seleccao: 2),
      appBar: AppBar(
        title: _isSearching
            ? _buildSearchField()
            : Text(AppLocalizations.of(context)!.threads),
        actions: _buildAppBarActions(),
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: largura * 0.02, vertical: altura * 0.02),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                //  color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(20),
              ),
              height: altura * 0.9,
              child: Container(
                margin: EdgeInsets.symmetric(
                    horizontal: largura * 0.01, vertical: altura * 0.02),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: containerColorTopicos,
                      height: altura * 0.8,
                      child: listaEvFiltrada.isEmpty
                          ? _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                      backgroundColor:
                                          Theme.of(context).canvasColor),
                                )
                              : Center(
                                  child: Text(
                                      AppLocalizations.of(context)!.naoHaDados),
                                )
                          : Expanded(
                              child: ListView(
                                children: listaEvFiltrada.map((e) {
                                  return InkWell(
                                    enableFeedback: true,
                                    child: TopicoCardItem(
                                      topico: e,
                                      categorias: categorias,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              TopicoDetailsScreen(
                                            topico: e,
                                            categorias: categorias,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
