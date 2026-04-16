// lib/Repository/major_repository.dart

import '../Databases/database.dart';
import '../Models/MajorModel.dart';

class MajorRepository {

  static Future<List<Major>> getAll() async {
    final db = await AppDatabase.instance();
    final result = await db.query("majors");

    return result.map((e) => Major.fromMap(e)).toList();
  }

  static Future<void> update(Major m) async {
    final db = await AppDatabase.instance();

    await db.update(
      "majors",
      m.toMap(),
      where: "id = ?",
      whereArgs: [m.id],
    );
  }
}