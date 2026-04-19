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

  static Future<StudentModel?> get(String username) async {
    final db = await AppDatabase.instance();

    final result = await db.query(
      "students",
      where: "username = ?",
      whereArgs: [username],
      limit: 1,
    );

    if (result.isEmpty) return null;

    final data = result.first;

    return StudentModel(
      name: data["name"] as String,
      username: data["username"] as String,
      password: data["password"] as String,
      jurusan: data["jurusan"] as String,
      kelas: data["kelas"] as String,
      noUrut: data["noUrut"] as String,
      ruang: data["ruang"] as String,
      waktu1: data["waktu1"] as String,
      waktu2: data["waktu2"] as String,
    );
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

  static Future<List<String>> getClasses() async {
    final db = await AppDatabase.instance();

    final result = await db.rawQuery(
      "SELECT DISTINCT kelas FROM students ORDER BY kelas ASC",
    );

    return result.map((e) => e["kelas"] as String).toList();
  }

  static Future<List<StudentModel>> filter({
    String? className,
    String? majorCode,
    int? startNumber,
    int? endNumber,
  }) async {
    final db = await AppDatabase.instance();

    List<String> where = [];
    List<dynamic> args = [];

    if (className != null && className.isNotEmpty) {
      where.add("kelas = ?");
      args.add(className);
    }

    if (majorCode != null && majorCode.isNotEmpty) {
      where.add("jurusan = ?");
      args.add(majorCode);
    }

    if (startNumber != null && endNumber != null) {
      where.add(
        "CAST(REPLACE(noUrut, 'No. Urut ', '') AS INTEGER) BETWEEN ? AND ?",
      );
      args.add(startNumber);
      args.add(endNumber);
    }

    final result = await db.query(
      "students",
      where: where.isEmpty ? null : where.join(" AND "),
      whereArgs: args,
      orderBy: "CAST(REPLACE(noUrut, 'No. Urut ', '') AS INTEGER) ASC",
    );

    return result.map((e) => StudentModel.fromMap(e)).toList();
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

  static Future<void> deleteMany(List<String> usernames) async {
    final db = await AppDatabase.instance();

    final batch = db.batch();

    for (var username in usernames) {
      batch.delete("students", where: "username = ?", whereArgs: [username]);
    }

    await batch.commit(noResult: true);
  }
}
