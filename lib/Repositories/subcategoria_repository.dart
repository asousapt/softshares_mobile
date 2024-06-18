import 'package:flutter/material.dart';
import 'package:softshares_mobile/models/subcategoria.dart';
import 'package:softshares_mobile/services/api_service.dart';
import 'package:softshares_mobile/services/database_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SubcategoriaRepository {
  final ApiService _apiService = ApiService();
  final DatabaseService _databaseService = DatabaseService.instance;

  // Fetch subcategorias from API
  Future<List<Subcategoria>> fetchSubcategorias() async {
    _apiService.setAuthToken("tokenFixo");

    final subcategorias = await _apiService.getRequest('subcategoria/mobile');
    final subcategoriasFormatted = subcategorias['data'];

    if (subcategoriasFormatted != null) {
      return (subcategoriasFormatted as List)
          .map((item) => Subcategoria.subcategoriaFromJson(item))
          .toList();
    } else {
      return [];
    }
  }

  // Fetch subcategorias from database based on idiomaId
  Future<List<Subcategoria>> fetchSubcategoriasDB(int idiomaId) async {
    String queryCat = 'SELECT * FROM subcategoria WHERE idiomaId = $idiomaId';
    final subcategorias = await _databaseService.execSQL(queryCat);

    return subcategorias
        .map((item) => Subcategoria.subcategoriaFromJson(item))
        .toList();
  }

  // Create a subcategoria in the database
  Future<bool> createSubcategoria(Subcategoria subcategoria) async {
    final db = await _databaseService.database;
    final id = await db.insert('subcategoria', subcategoria.toJson());
    return id > 0;
  }

  // Delete all subcategorias from the database
  Future<void> deleteAllSubcategorias() async {
    final db = await _databaseService.database;
    await db.delete('subcategoria');
  }

  Future<void> carregaSubategorias(BuildContext context) async {
    SubcategoriaRepository subcategoriaRepository = SubcategoriaRepository();
    try {
      // Fetch subcategorias da api
      List<Subcategoria> subcategoriaList =
          await subcategoriaRepository.fetchSubcategorias();

      // Apagar todas as subcategorias da base de dados
      subcategoriaRepository.deleteAllSubcategorias();

      for (Subcategoria subcategoria in subcategoriaList) {
        // Inserir subcategoria na base de dados
        bool inseriu =
            await subcategoriaRepository.createSubcategoria(subcategoria);
        if (!inseriu) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.ocorreuErro),
            ),
          );
        }
      }
    } catch (e, stacktrace) {
      print("An error occurred: $e");
      print("Stacktrace: $stacktrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${AppLocalizations.of(context)!.ocorreuErro}: $e'),
        ),
      );
    }
  }
}
