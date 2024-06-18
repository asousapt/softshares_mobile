import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/departamento.dart';
import 'package:softshares_mobile/services/api_service.dart';
import 'package:softshares_mobile/services/database_service.dart';
import 'package:sqflite/sqflite.dart';

class DepartamentoRepository {
  final ApiService _apiService = ApiService();
  final DatabaseService _database = DatabaseService.instance;

  // retorna departamentos da API
  Future<List<Departamento>> fetchDepartamentos() async {
    _apiService.setAuthToken("tokenFixo");

    final departamentos = await _apiService.getRequest('departamento/mobile');
    final departamentosFormatted = departamentos['data'];

    if (departamentosFormatted != null) {
      return (departamentosFormatted as List)
          .map((item) => Departamento.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }

  // retona os departamentos da base de dados com o idioma selecionado
  Future<List<Departamento>> fetchDepartamentosDB(int idimoaId) async {
    String queryDep = 'SELECT * FROM departamento where idiomaId = $idimoaId';

    final departamentos = await _database.execSQL(queryDep);

    return departamentos.map((item) => Departamento.fromJson(item)).toList();
  }

  // criar departamento na base de dados
  Future<bool> createDepartamento(Departamento departamento) async {
    final db = await _database.database;
    final id = await db.insert('departamento', departamento.toJson());
    return id > 0;
  }

  // retorna o número de departamentos na base de dados
  Future<int> coutDepartamentos() async {
    final db = await _database.database;
    final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM departamento'));
    if (count != null) {
      return count;
    } else {
      return 0;
    }
  }

  // apagar todos os departamentos da base de dados
  Future<void> deleteAllDepartamentos() async {
    final db = await _database.database;
    await db.delete('departamento');
  }

  Future<void> carregaDepartamentos(BuildContext context) async {
    DepartamentoRepository departamentoRepository = DepartamentoRepository();
    try {
      // Fetch departamentos da api
      List<Departamento> departamentoList =
          await departamentoRepository.fetchDepartamentos();

      int departamentosCount = await departamentoRepository.coutDepartamentos();

      if (departamentosCount != departamentoList.length) {
        // Apagar todos os departamentos da base de dados
        departamentoRepository.deleteAllDepartamentos();

        for (Departamento departamento in departamentoList) {
          // cria departamento na base de dados
          await departamentoRepository.createDepartamento(departamento);
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
