import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/funcao.dart';
import 'package:softshares_mobile/services/api_service.dart';
import 'package:softshares_mobile/services/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FuncaoRepository {
  final ApiService _apiService = ApiService();
  final DatabaseService _database = DatabaseService.instance;

  // retorna funcoes da API
  Future<List<Funcao>> fetchFuncoes() async {
    _apiService.setAuthToken("tokenFixo");

    final funcoes = await _apiService.getRequest('funcao/mobile');
    final funcoesFormatted = funcoes['data'];

    if (funcoesFormatted != null) {
      return (funcoesFormatted as List)
          .map((item) => Funcao.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }

  // retona os funcoes da base de dados com o idioma selecionado
  Future<List<Funcao>> fetchFuncoesDB(int idimoaId) async {
    String queryFun = 'SELECT * FROM funcao where idiomaId = $idimoaId';

    final funcoes = await _database.execSQL(queryFun);

    return funcoes.map((item) => Funcao.fromJson(item)).toList();
  }

  // criar funcao na base de dados
  Future<bool> createFuncao(Funcao funcao) async {
    final db = await _database.database;
    final id = await db.insert('funcao', funcao.toJson());
    return id > 0;
  }

  // retorna o número de funcoes na base de dados
  Future<int> coutFuncoes() async {
    final db = await _database.database;
    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM funcao'));
    if (count != null) {
      return count;
    } else {
      return 0;
    }
  }

  // apagar todos os funcoes da base de dados
  Future<void> deleteAllFuncoes() async {
    final db = await _database.database;
    await db.delete('funcao');
  }

  // carrega funcoes
  Future<void> carregaFuncoes(BuildContext context) async {
    FuncaoRepository funcaoRepositry = FuncaoRepository();
    try {
      // Fetch departamentos da api
      List<Funcao> funcaoList = await funcaoRepositry.fetchFuncoes();

      int funcoesCount = await funcaoRepositry.coutFuncoes();

      if (funcoesCount != funcaoList.length) {
        // Apagar todos os departamentos da base de dados
        funcaoRepositry.deleteAllFuncoes();

        for (Funcao funcao in funcaoList) {
          // cria departamento na base de dados
          await funcaoRepositry.createFuncao(funcao);
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

  Future<String> getFuncaoByIdAndIdioma(int funcaoId, int idiomaId) async {
    String descricao = "";
    final db = await _database.database;
    final funcao = await db.rawQuery(
        'SELECT descricao FROM funcao where funcaoId = $funcaoId and idiomaId = $idiomaId');

    if (funcao.isNotEmpty) {
      descricao = funcao[0]['descricao'].toString();
    }

    return descricao;
  }
}
