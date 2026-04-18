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

    await db.update("majors", m.toMap(), where: "id = ?", whereArgs: [m.id]);
  }

  // lib/Repository/major_repository.dart

  static Future<void> insert(Major m) async {
    final db = await AppDatabase.instance();

    await db.insert("majors", m.toMap());
  }

  static Future<void> delete(int id) async {
    final db = await AppDatabase.instance();

    await db.delete("majors", where: "id = ?", whereArgs: [id]);
  }
}
