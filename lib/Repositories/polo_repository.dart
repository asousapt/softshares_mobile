import 'package:softshares_mobile/models/polo.dart';
import 'package:softshares_mobile/services/api_service.dart';
import 'package:softshares_mobile/services/database_service.dart';

class PoloRepository {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<List<Polo>> fetchPolos() async {
    _apiService.setAuthToken("tokenFixo");
    final polos = await _apiService.getRequest('polo/mobile');
    final polosFormatted = polos['data'];

    if (polosFormatted != null) {
      return (polosFormatted as List)
          .map((item) => Polo.fromJson(item))
          .toList();
    } else {
      return [];
    }
  }

  Future<bool> createPolo(Polo polo) async {
    final db = await _databaseService.database;
    final id = await db.insert('polo', polo.toJson());
    print('Inserted row id: $id');
    return id > 0;
  }

  Future<void> deleteAllPolos() async {
    final db = await _databaseService.database;
    await db.delete('polo');
  }

  Future<List<Polo>> fetchPolosFromDb() async {
    print("vou iniciar a busca");
    final db = await _databaseService.database;
    final polos = await db.query('polo');
    print("Polos: $polos");
    return polos.map((item) => Polo.fromJson(item)).toList();
  }
}
