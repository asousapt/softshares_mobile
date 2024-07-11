import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:softshares_mobile/models/notification_preference.dart';
import 'package:softshares_mobile/models/utilizador.dart';
import 'package:softshares_mobile/services/database_service.dart';

class NotificationPreferenceRepository {
  final DatabaseService _databaseService = DatabaseService.instance;

  Future<List<NotificationPreference>> getPrefsUtil() async {
    final prefs = await SharedPreferences.getInstance();
    String util = prefs.getString("utilizadorObj") ?? "";
    Utilizador utilizador = Utilizador.fromJson(jsonDecode(util));
    int utilizadorId = utilizador.utilizadorId;

    String query =
        'SELECT * FROM notification_preferences WHERE utilizadorId = $utilizadorId';

    final prefsUtil = await _databaseService.execSQL(query);
    return prefsUtil
        .map((item) => NotificationPreference.fromJson(item))
        .toList();
  }

  // insere uma nova preferência de notificação
  Future<bool> createNotificationPreference(
      NotificationPreference notificationPreference) async {
    final db = await _databaseService.database;
    final id = await db.insert(
        'notification_preferences', notificationPreference.toJson());
    return id > 0;
  }

  // Verifica se um utilizador ja tem as permissoes de notificacao criadas
  Future<bool> verificaPermissoesUtilizador(int utilizadorId) async {
    String query =
        'SELECT * FROM notification_preferences WHERE utilizadorId = $utilizadorId';

    final prefsUtil = await _databaseService.execSQL(query);
    return prefsUtil.isNotEmpty;
  }

  // cria as preferências de notificação para um utilizador
  Future<void> criarPrefsutil(int utilizadorId) async {
    final db = await _databaseService.database;
    final prefs = [
      NotificationPreference(
          type: 'THREAD', enabled: true, utilizadorId: utilizadorId),
      NotificationPreference(
          type: 'EVENTO', enabled: true, utilizadorId: utilizadorId),
      NotificationPreference(
          type: 'POI', enabled: true, utilizadorId: utilizadorId),
    ];

    for (var pref in prefs) {
      await db.insert('notification_preferences', pref.toJson());
    }
  }

  // atualiza uma preferência de notificação de um determinado utilizador
  // baseado no utilizadorid e tipo
  Future<bool> updateNotificationPreference(
      NotificationPreference notificationPreference) async {
    final db = await _databaseService.database;

    final updateData = notificationPreference.toJson();
    updateData.remove('id');

    final rowsAffected = await db.update(
      'notification_preferences',
      updateData,
      where: 'utilizadorId = ? AND type = ?',
      whereArgs: [
        notificationPreference.utilizadorId,
        notificationPreference.type
      ],
    );
    return rowsAffected > 0;
  }
}
