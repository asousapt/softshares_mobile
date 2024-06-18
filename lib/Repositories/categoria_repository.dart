import 'package:softshares_mobile/models/categoria.dart';
import 'package:softshares_mobile/services/api_service.dart';
import 'package:softshares_mobile/services/database_service.dart';

class CategoriaRepository {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService.instance;

  // retorna categorias da API
  Future<List<Categoria>> fetchCategorias() async {
    _apiService.setAuthToken("tokenFixo");

    final categorias = await _apiService.getRequest('categoria/mobile');
    final categoriasFormatted = categorias['data'];

    if (categoriasFormatted != null) {
      return (categoriasFormatted as List)
          .map((item) => categoriafromJson(item))
          .toList();
    } else {
      return [];
    }
  }

  // retona as categorias da base de dados com id maior que 0
  Future<List<Categoria>> fetchCategoriasDB(int idiomaID) async {
    String queryCat = 'SELECT * FROM categoria  WHERE idiomaId = $idiomaID';

    final categorias = await _databaseService.execSQL(queryCat);
    print(categorias);
    return categorias.map((item) => categoriafromJson(item)).toList();
  }

  // criar categoria na base de dados
  Future<bool> createCategoria(Categoria categoria) async {
    final db = await _databaseService.database;
    final id = await db.insert('categoria', categoriaToJson(categoria));
    return id > 0;
  }

  // apaga todas as categorias existentes
  Future<void> deleteAllCategorias() async {
    final db = await _databaseService.database;
    await db.delete('categoria');
  }
}
