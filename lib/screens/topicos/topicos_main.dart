import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/categoria_repository.dart';
import 'package:softshares_mobile/Repositories/topico_repository.dart';
import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/models/topico.dart';
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
  bool _isLoading = true;
  List<Topico> listaEvFiltrada = [];
  List<Topico> listaTopicos = [];
  Color containerColorTopicos = Colors.transparent;
  List<Categoria> categoriasFiltro = [];
  List<Categoria> categorias = [];
  ApiService api = ApiService();
  late String idioma;
  bool _showError = false;

  // Busca as categorias do idioma selecionado
  Future<void> carregaCategorias() async {
    final prefs = await SharedPreferences.getInstance();
    final idiomaId = prefs.getInt("idiomaId") ?? 1;
    idioma = prefs.getString("idioma") ?? "pt";
    print("Idioma: $idioma");
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

  @override
  void initState() {
    super.initState();
    actualizaDados();
  }

  Future<void> actualizaDados() async {
    try {
      await Future.wait([
        carregaCategorias(),
        _fetchTopicosWithTimeout(),
      ]);
      setState(() {
        _isLoading = false;
        _showError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _showError = true;
      });
    }
  }

  Future<void> _fetchTopicosWithTimeout() async {
    TopicoRepository topicoRepository = TopicoRepository();
    listaTopicos = await topicoRepository.getTopicos().timeout(
      const Duration(seconds: 10),
      onTimeout: () {
        throw TimeoutException(
          AppLocalizations.of(context)!.ocorreuErro,
          const Duration(seconds: 5),
        );
      },
    );

    setState(() {
      listaEvFiltrada = listaTopicos;
      if (listaTopicos.isEmpty) {
        containerColorTopicos = Theme.of(context).canvasColor;
      } else {
        containerColorTopicos = Colors.transparent;
      }
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
        onPressed: () async {
          final inseriu = await Navigator.pushNamed(context, '/criarTopico');

          if (inseriu != null && inseriu == true) {
            actualizaDados();
          }
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: containerColorTopicos,
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                              backgroundColor: Theme.of(context).canvasColor))
                      : _showError
                          ? Center(
                              child: Text(
                                  AppLocalizations.of(context)!.ocorreuErro))
                          : listaEvFiltrada.isNotEmpty
                              ? ListView(
                                  children: listaEvFiltrada.map((e) {
                                    return InkWell(
                                      enableFeedback: true,
                                      child: TopicoCardItem(
                                        topico: e,
                                        categorias: categorias,
                                        idioma: idioma,
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
                                )
                              : Center(
                                  child: Text(
                                      AppLocalizations.of(context)!.naoHaDados),
                                ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
