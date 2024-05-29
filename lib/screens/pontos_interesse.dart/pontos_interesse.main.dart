import 'dart:async';

import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/ponto_de_interesse.dart';
import '../../widgets/pontos__de_interesse/pontos_de_interesse_card.dart';
import 'package:softshares_mobile/models/categoria.dart';

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
  Color _containerColorPontosDeInteresse = Colors.transparent;

  @override
  void initState() {
    super.initState();
    fetchPontosDeInteresse();
  }

  List<Categoria> categorias = [
    Categoria(1, "Gastronomia", "cor1", "garfo"),
    Categoria(2, "Desporto", "cor2", "futebol"),
    Categoria(3, "Atividade Ar Livre", "cor3", "arvore"),
    Categoria(4, "Alojamento", "cor3", "casa"),
    Categoria(5, "Saúde", "cor3", "cruz"),
    Categoria(6, "Ensino", "cor3", "escola"),
    Categoria(7, "Infraestruturas", "cor3", "infra"),
    Categoria(0, "Todas", "corTodas", "todos"),
  ];

  Future<void> fetchPontosDeInteresse() async {
    // Fetch data from your data source
    // Example:
    // listaPontosDeInteresse = await fetchData();
    // listaPontosDeInteresseFiltrados = List.from(listaPontosDeInteresse);
    // setState(() {});
  }

  void filterPontosDeInteresse(String query) {
    //Faz uma query que devolve pontos de interesse de uma certa categoria
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                onChanged: filterPontosDeInteresse,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
              )
            : Text('Pontos de Interesse'),
        actions: <Widget>[
          IconButton(
            icon: Icon(_isSearching ? Icons.cancel : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  filterPontosDeInteresse('');
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : listaPontosDeInteresseFiltrados.isEmpty
              ? Center(
                  child: Text('No data available'),
                )
              : SingleChildScrollView(
                child: ListView.builder(
                    itemCount: listaPontosDeInteresseFiltrados.length,
                    itemBuilder: (context, index) {
                      final pontoDeInteresse =
                          listaPontosDeInteresseFiltrados[index];
                      return PontoInteresseCard(
                        pontoInteresse: pontoDeInteresse,
                      );
                    },
                  ),
              ),
    );
  }
}