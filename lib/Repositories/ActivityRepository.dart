// lib/Repository/activity_repository.dart

import '../Databases/database.dart';
import '../Models/ActivityModel.dart';

class ActivityRepository {
  static Future<void> log(String action, String description) async {
    final db = await AppDatabase.instance();

    await db.insert("activities", {
      "action": action,
      "description": description,
      "created_at": DateTime.now().toIso8601String(),
    });
  }

  static Future<List<Activity>> getRecent() async {
    final db = await AppDatabase.instance();

    final result = await db.query(
      "activities",
      orderBy: "created_at DESC",
      limit: 50,
    );

    return result.map((e) => Activity.fromMap(e)).toList();
  }

  static Future<List<Activity>> getByAction(String action) async {
    final db = await AppDatabase.instance();

    final result = await db.query(
      "activities",
      where: "action = ?",
      whereArgs: [action],
      orderBy: "created_at DESC",
    );

    return result.map((e) => Activity.fromMap(e)).toList();
  }

  static Future<void> deleteAll() async {
    final db = await AppDatabase.instance();
    await db.delete("activities");
  }

  static Future<void> keepLatest(int limit) async {
    final db = await AppDatabase.instance();

    await db.rawDelete(
      """
    DELETE FROM activities
    WHERE id NOT IN (
      SELECT id FROM activities
      ORDER BY created_at DESC
      LIMIT ?
    )
  """,
      [limit],
    );
  }
}
