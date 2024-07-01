import 'package:softshares_mobile/models/notification_preference.dart';
import 'package:softshares_mobile/services/database_service.dart';

class NotificationPreferenceRepository {
  final DatabaseService _databaseService = DatabaseService.instance;

  // Fetch notification preferences from the local database
  Future<List<NotificationPreference>> fetchLocalNotificationPreferences() async {
    const query = 'SELECT * FROM notification_preferences';
    final result = await _databaseService.execSQL(query);
    return result.map((row) => NotificationPreference.fromJson(row)).toList();
  }

  // Insert a notification preference into the local database
  Future<bool> createNotificationPreference(NotificationPreference preference) async {
    final db = await _databaseService.database;
    final id = await db.insert('notification_preferences', preference.toJson());
    return id > 0;
  }

  // Get the ID of a notification preference by type
  Future<int> getNotificationPreferenceId(String type) async {
    final query = 'SELECT id FROM notification_preferences WHERE type = "$type"';
    final result = await _databaseService.execSQL(query);
    return result[0]['id'] as int;
  }

  // Delete all notification preferences from the local database
  Future<void> deleteAllNotificationPreferences() async {
    final db = await _databaseService.database;
    await db.delete('notification_preferences');
  }

  // Update a notification preference in the local database
  Future<bool> updateNotificationPreference(String type, bool enabled) async {
    final db = await _databaseService.database;
    final rows = await db.update(
      'notification_preferences',
      {'enabled': enabled ? 1 : 0}, // Assuming 'enabled' is stored as an integer (0 or 1) in the database
      where: 'type = ?',
      whereArgs: [type],
    );
    return rows > 0;
  }
}
