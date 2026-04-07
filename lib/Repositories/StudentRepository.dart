import 'package:skavela_app/Models/StudentModel.dart';

import '../Databases/database.dart';

class StudentRepository {
  static Future<void> insert(StudentModel s) async {
    final db = await AppDatabase.instance();

    await db.insert("students", {
      "name": s.name,
      "username": s.username,
      "password": s.password,
      "jurusan": s.jurusan,
      "kelas": s.kelas,
      "noUrut": s.noUrut,
      "ruang": s.ruang,
      "waktu1": s.waktu1,
      "waktu2": s.waktu2,
    });
  }

  static Future<List<StudentModel>> getAll() async {
    final db = await AppDatabase.instance();

    final result = await db.query("students");

    return result
        .map(
          (e) => StudentModel(
            name: e["name"] as String,
            username: e["username"] as String,
            password: e["password"] as String,
            jurusan: e["jurusan"] as String,
            kelas: e["kelas"] as String,
            noUrut: e["noUrut"] as String,
            ruang: e["ruang"] as String,
            waktu1: e["waktu1"] as String,
            waktu2: e["waktu2"] as String,
          ),
        )
        .toList();
  }

  static Future<void> update(StudentModel s) async {
    final db = await AppDatabase.instance();

    await db.update(
      "students",
      s.toMap(),
      where: "username = ?",
      whereArgs: [s.username],
    );
  }

  static Future<void> delete(String username) async {
    final db = await AppDatabase.instance();

    await db.delete("students", where: "username = ?", whereArgs: [username]);
  }

  static Future<void> deleteAll() async {
    final db = await AppDatabase.instance();
    await db.delete("students");
  }
}
