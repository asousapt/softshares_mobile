import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/categoria_repository.dart';
import 'package:softshares_mobile/Repositories/evento_repository.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/widgets/eventos/event_card_item.dart';
import 'package:softshares_mobile/widgets/eventos/evento_card_eventos.dart';
import 'package:softshares_mobile/widgets/gerais/bottom_navigation.dart';
import 'package:softshares_mobile/widgets/gerais/main_drawer.dart';
import 'package:softshares_mobile/models/categoria.dart';

class EventosMainScreen extends StatefulWidget {
  const EventosMainScreen({super.key});

  @override
  State<EventosMainScreen> createState() => _EventosMainScreenState();
}

class _EventosMainScreenState extends State<EventosMainScreen> {
  String tituloInscritos = "";
  String tituloTotalEventos = "";
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<Evento> listaEvFiltrada = [];
  List<Evento> eventosInscrito = [];
  List<Evento> listaEventos = [];
  Color containerColorEventos = Colors.transparent;
  Color containerColorInscritos = Colors.transparent;
  bool _isLoading = false;
  List<Categoria> categorias = [];
  List<Categoria> categoriasFiltro = [];
  late String idioma;

  // Busca as categorias do idioma selecionado
  Future<void> carregaCategorias() async {
    final prefs = await SharedPreferences.getInstance();
    final idiomaId = prefs.getInt("idiomaId") ?? 1;
    idioma = prefs.getString("idioma") ?? "pt";

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

  // Busca os eventos futuros
  Future<List<Evento>> fetchEventos() async {
    EventoRepository eventosRepository = EventoRepository();
    listaEventos = await eventosRepository.getEventos();

    setState(() {
      listaEvFiltrada = listaEventos;
    });
    return listaEvFiltrada;
  }

  // Busca os eventos inscritos
  Future<List<Evento>> fetchEventosInscrito() async {
    /*final response = await http
        .get(Uri.parse('https://api.yourservice.com/events-inscrito'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Evento.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load inscritos');
    }*/

    eventosInscrito = [];
    /*   Evento(
        1,
        "Conferência de Tecnologia 2024",
        1,
        0,
        "Junte-se a nós para a maior conferência de tecnologia do ano!",
        1000,
        500,
        0,
        "Virtual",
        "",
        "",
        DateTime(2024, 06, 15, 10, 0), // June 15, 2024, 10:00 AM
        DateTime(2024, 06, 17, 18, 0), // June 17, 2024, 6:00 PM
        DateTime(2024, 06, 14), // Example for dataLimiteInsc
        [],
        1,
        1,
        false,
        [1, 2, 3, 4, 5],
      ),
      Evento(
        2,
        "Festival de Música 2024",
        2,
        0,
        "Viva um fim de semana de música, comida e diversão!",
        5000,
        3000,
        0,
        "Central Park, Nova York",
        "",
        "",
        DateTime(2024, 07, 20, 12, 0), // July 20, 2024, 12:00 PM
        DateTime(2024, 07, 22, 22, 0), // July 22, 2024, 10:00 PM
        DateTime(2024, 07, 19), // Example for dataLimiteInsc
        [],
        2,
        2,
        true,
        [],
      ),
    ];*/
    return eventosInscrito;
  }

  // preenche os contadores de eventos inscritos e total de eventos
  Future<void> actualizaOsContadoresDeEventos() async {
    setState(() {
      _isLoading = true;
    });
    eventosInscrito = await fetchEventosInscrito();
    listaEventos = await fetchEventos();
    setState(() {
      if (listaEventos.isEmpty) {
        containerColorEventos = Theme.of(context).canvasColor;
      } else {
        containerColorEventos = Colors.transparent;
      }

      if (eventosInscrito.isEmpty) {
        containerColorInscritos = Theme.of(context).canvasColor;
      } else {
        containerColorInscritos = Colors.transparent;
      }
      tituloInscritos =
          "${eventosInscrito.length.toString()} ${AppLocalizations.of(context)!.eventos}";
      tituloTotalEventos =
          "${listaEventos.length.toString()} ${AppLocalizations.of(context)!.eventos}";
      _isLoading = false;
    });
  }

  @override
  void initState() {
    carregaCategorias().then((_) {
      actualizaOsContadoresDeEventos();
    });
    super.initState();
    actualizaOsContadoresDeEventos().then((_) {
      setState(() {
        listaEvFiltrada = List.from(listaEventos);
      });
    });
  }

  @override
  void dispose() {
    // Dispose the search controller
    _searchController.dispose();
    super.dispose();
  }

// Foi necessario adicionar este bloco por causa das dependencias
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

  // faz a filtragem da lista consoante o que é digitado na caixa de pesquisa
  void filtraPorTexto(String texto) {
    texto = texto.toLowerCase();
    setState(() {
      listaEvFiltrada = listaEventos.where((element) {
        String descricaoLower = element.descricao.toLowerCase();
        String localizacaoLower = element.localizacao.toLowerCase();
        String tituloLower = element.titulo.toLowerCase();
        return descricaoLower.contains(texto) ||
            localizacaoLower.contains(texto) ||
            tituloLower.contains(texto);
      }).toList();

      if (listaEvFiltrada.isEmpty) {
        containerColorEventos = Theme.of(context).canvasColor;
      } else {
        containerColorEventos = Colors.transparent;
      }

      tituloTotalEventos =
          "${listaEvFiltrada.length.toString()} ${AppLocalizations.of(context)!.eventos}";
    });
  }

  void filtraPorCategoria(String categoria) {
    int cat = int.parse(categoria);

    setState(() {
      if (cat == 0) {
        listaEvFiltrada = listaEventos;
      } else {
        listaEvFiltrada =
            listaEventos.where((element) => element.categoria == cat).toList();
      }

      if (listaEvFiltrada.isEmpty) {
        containerColorEventos = Theme.of(context).canvasColor;
      } else {
        containerColorEventos = Colors.transparent;
      }

      tituloTotalEventos =
          "${listaEvFiltrada.length.toString()} ${AppLocalizations.of(context)!.eventos}";
    });
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
          Navigator.pushNamed(context, '/criarEvento');
        },
        child: const Icon(
          FontAwesomeIcons.plus,
          color: Color.fromRGBO(217, 215, 215, 1),
        ),
      ),
      drawer: const MainDrawer(),
      bottomNavigationBar: const BottomNavigation(seleccao: 3),
      appBar: AppBar(
        title: _isSearching
            ? _buildSearchField()
            : Text(AppLocalizations.of(context)!.eventos),
        actions: _buildAppBarActions(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: altura * 0.03,
                left: largura * 0.03,
                right: largura * 0.03,
                bottom: altura * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.eventosInscrito}:",
                    style: const TextStyle(
                      color: Color.fromRGBO(217, 215, 215, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    tituloInscritos,
                    style: const TextStyle(
                      color: Color.fromRGBO(217, 215, 215, 1),
                    ),
                  ),
                  SizedBox(height: altura * 0.02),
                  Container(
                      color: containerColorInscritos,
                      height: altura * 0.25,
                      child: FutureBuilder<List<Evento>>(
                        future: fetchEventosInscrito(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text(
                                  AppLocalizations.of(context)!.ocorreuErro),
                            );
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: Text(
                                  AppLocalizations.of(context)!.naoHaDados),
                            );
                          } else {
                            List<Evento> eventosInscrito = snapshot.data!;
                            tituloInscritos =
                                "${eventosInscrito.length.toString()} ${AppLocalizations.of(context)!.eventos}";
                            return ListView(
                              scrollDirection: Axis.horizontal,
                              children: eventosInscrito.map((e) {
                                return InkWell(
                                  child: EventCardItem(evento: e),
                                  onTap: () {
                                    Map<String, dynamic> args = {
                                      "evento": e,
                                      "categorias": categorias,
                                    };
                                    Navigator.pushNamed(
                                      context,
                                      '/consultarEvento',
                                      arguments: args,
                                    );
                                  },
                                );
                              }).toList(),
                            );
                          }
                        },
                      )),
                  SizedBox(height: altura * 0.02),
                  Text(
                    "${AppLocalizations.of(context)!.eventosFuturos}:",
                    style: const TextStyle(
                      color: Color.fromRGBO(217, 215, 215, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    tituloTotalEventos,
                    style: const TextStyle(
                      color: Color.fromRGBO(217, 215, 215, 1),
                    ),
                  ),
                  SizedBox(height: altura * 0.02),
                  Container(
                    color: containerColorEventos,
                    height: altura * 0.33,
                    child: listaEvFiltrada.isEmpty
                        ? _isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                color: Theme.of(context).canvasColor,
                              ))
                            : Center(
                                child: Text(
                                    AppLocalizations.of(context)!.naoHaDados),
                              )
                        : ListView(
                            children: listaEvFiltrada.map((e) {
                              return InkWell(
                                enableFeedback: true,
                                child: EventItemCard(
                                  evento: e,
                                  categorias: categorias,
                                  idioma: idioma,
                                ),
                                onTap: () {
                                  Map<String, dynamic> args = {
                                    "evento": e,
                                    "categorias": categorias,
                                  };
                                  Navigator.pushNamed(
                                    context,
                                    '/consultarEvento',
                                    arguments: args,
                                  );
                                },
                              );
                            }).toList(),
                          ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
