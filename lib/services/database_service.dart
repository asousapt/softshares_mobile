import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();

  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) {
      print("Já tinha bd");
      return _database!;
    }

    _database = await _initDB('softshares.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    await db.execute('''CREATE TABLE idioma (
      idiomaid $idType,
      descricao $textType, 
      icone $textType
    )''');

    await db.execute('''CREATE TABLE polo (
       poloid $idType,
      descricao $textType,
      coordenador $textType,
      cidade $textType, 
      cidadeid $idType
    )''');

    await db.execute('''CREATE TABLE categoria (
      categoriaId $idType,
      descricao $textType, 
      cor $textType, 
      icone $textType, 
      idiomaId $idType
    )''');

    await db.execute('''CREATE TABLE subcategoria (
      subcategoriaId $idType,
      categoriaId $idType,
      descricao $textType,
      idiomaId $idType
    )''');

    await db.execute('''CREATE TABLE departamento (
      departamentoId $idType,
      descricao $textType,
      idiomaId $idType
    )''');

    await db.execute('''CREATE TABLE funcao (
      funcaoId $idType,
      descricao $textType,
      idiomaId $idType
    )''');

    print('Tables created');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    const idType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    if (oldVersion < 2) {
      await db.execute('''CREATE TABLE IF NOT EXISTS polo (
           poloid $idType,
            descricao $textType,
            coordenador $textType,
            cidade $textType, 
            cidadeid $idType
      )''');
      print('Table polo created in upgrade');
      await db.execute('''CREATE TABLE IF NOT EXISTS categoria (
      categoriaId $idType,
      descricao $textType, 
      cor $textType, 
      icone $textType, 
      idiomaId $idType
    )''');
      print('Table categoria created in upgrade');

      await db.execute('''CREATE TABLE IF NOT EXISTS subcategoria (
      subcategoriaId $idType,
      categoriaId $idType,
      descricao $textType,
      idiomaId $idType
    )''');

      print('Table subcategoria created in upgrade');

      await db.execute('''CREATE TABLE IF NOT EXISTS departamento (
      departamentoId $idType,
      descricao $textType,
      idiomaId $idType
    )''');
      print('Table departamento created in upgrade');

      await db.execute('''CREATE TABLE IF NOT EXISTS funcao (
      funcaoId $idType,
      descricao $textType,
      idiomaId $idType
    )''');
      print('Table funcao created in upgrade');
    }
  }

  Future<List<Map<String, dynamic>>> execSQL(String sql) async {
    final db = await instance.database;
    return await db.rawQuery(sql);
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }

  Future<void> deleteDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'softshares.db');

    await deleteDatabase(path);
    print('Database deleted');
    _database = null;
  }
}
