import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/cidade.dart';
import 'package:softshares_mobile/services/api_service.dart';
import 'package:softshares_mobile/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CidadeRepository {
  final _apiService = ApiService();
  final _databaseService = DatabaseService.instance;

  // retorna cidades da API
  Future<List<Cidade>> fetchCidades() async {
    _apiService.setAuthToken("tokenFixo");

    final cidades = await _apiService.getRequest('cidades');
    final cidadesFormatted = cidades['data'];

    if (cidadesFormatted != null) {
      return (cidadesFormatted as List)
          .map((item) => Cidade.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }

  Future<bool> createCidade(Cidade cidade) async {
    final db = await _databaseService.database;
    final id = await db.insert('cidade', cidade.toJson());
    return id > 0;
  }

  // retorna o número de cidades na base de dados
  Future<int> coutCidades() async {
    final db = await _databaseService.database;
    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM cidade'));
    if (count != null) {
      return count;
    } else {
      return 0;
    }
  }

  // apaga todos os cidades da base de dados
  Future<void> deleteAllCidades() async {
    final db = await _databaseService.database;
    await db.delete('cidade');
  }

  // carrega cidades da API para a base de dados local
  Future<void> carregaCidades(BuildContext context) async {
    CidadeRepository cidadeRepository = CidadeRepository();
    try {
      // Fetch departamentos da api
      List<Cidade> cidadeList = await cidadeRepository.fetchCidades();

      int cidadesCount = await cidadeRepository.coutCidades();

      if (cidadesCount != cidadeList.length) {
        // Apagar todos os departamentos da base de dados
        cidadeRepository.deleteAllCidades();

        for (Cidade cidade in cidadeList) {
          // cria departamento na base de dados
          await cidadeRepository.createCidade(cidade);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.ocorreuErro),
        ),
      );
      print(e);
    }
  }
}
