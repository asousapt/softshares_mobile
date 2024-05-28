import 'dart:async';

import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/ponto_de_interesse.dart';
import '../../widgets/pontos__de_interesse/pontos_de_interesse_card.dart';

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

  Future<void> fetchPontosDeInteresse() async {
    // Fetch data from your data source
    // Example:
    // listaPontosDeInteresse = await fetchData();
    // listaPontosDeInteresseFiltrados = List.from(listaPontosDeInteresse);
    // setState(() {});
  }

  void filterPontosDeInteresse(String query) {
    // Filter the list of points of interest based on the query
    // Example:
    // listaPontosDeInteresseFiltrados = listaPontosDeInteresse.where((ponto) {
    //   return ponto.titulo.toLowerCase().contains(query.toLowerCase());
    // }).toList();
    // setState(() {});
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
              : ListView.builder(
                  itemCount: listaPontosDeInteresseFiltrados.length,
                  itemBuilder: (context, index) {
                    final pontoDeInteresse =
                        listaPontosDeInteresseFiltrados[index];
                    return PontoInteresseCard(
                      pontoInteresse: pontoDeInteresse,
                    );
                  },
                ),
    );
  }
}