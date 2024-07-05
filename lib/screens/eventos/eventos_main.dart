import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/Repositories/categoria_repository.dart';
import 'package:softshares_mobile/Repositories/evento_repository.dart';
import 'package:softshares_mobile/models/evento.dart';
import 'package:softshares_mobile/models/utilizador.dart';
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
  final TextEditingController _searchController = TextEditingController();
  List<Evento> listaEvFiltrada = [];
  List<Evento> eventosInscrito = [];
  List<Evento> listaEventos = [];
  Color containerColorEventos = Colors.transparent;
  Color containerColorInscritos = Colors.transparent;
  bool _isLoading = false;
  List<Categoria> categorias = [];
  List<Categoria> categoriasFiltro = [];
  late String idioma;
  late int utilizadorId;

  // Busca as categorias do idioma selecionado
  Future<void> carregaCategorias() async {
    final prefs = await SharedPreferences.getInstance();
    final idiomaId = prefs.getInt("idiomaId") ?? 1;
    idioma = prefs.getString("idioma") ?? "pt";
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    utilizadorId = utilizador.utilizadorId;

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
    EventoRepository eventosRepository = EventoRepository();
    eventosInscrito = await eventosRepository.getEventosInscritos(utilizadorId);

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
          Map<String, dynamic> args = {
            "edicao": false,
            "eventoId": 0,
          };
          Navigator.pushNamed(context, '/criarEvento', arguments: args);
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
                            return Center(
                                child: CircularProgressIndicator(
                              color: Theme.of(context).canvasColor,
                            ));
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Container(
                                color: Theme.of(context).canvasColor,
                                child: Text(
                                    AppLocalizations.of(context)!.ocorreuErro),
                              ),
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
                                  if (e.aprovado == true) {
                                    Map<String, dynamic> args = {
                                      "evento": e,
                                      "categorias": categorias,
                                    };
                                    Navigator.pushNamed(
                                      context,
                                      '/consultarEvento',
                                      arguments: args,
                                    );
                                  } else {
                                    // Navega para o ecra de criacao de eventos
                                    Map<String, dynamic> args = {
                                      "edicao": true,
                                      "eventoId": e.eventoId,
                                    };
                                    final result = Navigator.pushNamed(
                                      context,
                                      '/criarEvento',
                                      arguments: args,
                                    );
                                    if (result != null &&
                                        result is bool &&
                                        result == true) {
                                      _isLoading = true;
                                      actualizaOsContadoresDeEventos();
                                      _isLoading = false;
                                    }
                                  }
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
