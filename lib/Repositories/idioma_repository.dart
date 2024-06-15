import 'package:softshares_mobile/models/idioma.dart';
import 'package:softshares_mobile/services/api_service.dart';
import 'package:softshares_mobile/services/database_service.dart';

class IdiomaRepository {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<List<Idioma>> fetchIdiomas() async {
    final idiomas = await _apiService.getRequestNoAuth('idioma/');
    final idiomasFormatted = idiomas['data'];

    if (idiomasFormatted != null) {
      return (idiomasFormatted as List)
          .map((item) => Idioma.idiomafromJson(item))
          .toList();
    } else {
      return [];
    }
  }

// retorna os idiomas suportados pela aplicação da base de dados local
  Future<List<String>> fetchSupportedLocales() async {
    const queryIdioma = 'SELECT icone FROM idioma';
    final result = await _databaseService.execSQL(queryIdioma);
    return result.map((row) => row['icone'] as String).toList();
  }

  Future<int> numeroIdiomas() async {
    const queryIdioma = 'SELECT COUNT(*) FROM idioma';
    final result = await _databaseService.execSQL(queryIdioma);
    return result[0]['COUNT(*)'] as int;
  }

// inserir idioma
  Future<bool> createIdioma(Idioma idioma) async {
    final db = await _databaseService.database;
    final id = await db.insert('idioma', idioma.idiomatoJson());
    return id > 0;
  }

// apaga todos os idiomas existentes
  Future<void> deleteAllIdiomas() async {
    final db = await _databaseService.database;
    await db.delete('idioma');
  }
}
