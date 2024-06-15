import 'package:softshares_mobile/models/idioma.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();

  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('softshares.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // criacao da tabela idioma
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER';
    const textType = 'TEXT NOT NULL';
    const booleanType = 'BOOLEAN NOT NULL';

    await db.execute('''CREATE TABLE idioma (
      idiomaid $idType,
      descricao $textType, 
      icone $textType
    )''');
  }

  Future<List<Map<String, dynamic>>> execSQL(String sql) async {
    final db = await instance.database;
    return await db.rawQuery(sql);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
