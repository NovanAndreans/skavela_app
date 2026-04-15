import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> instance() async {
    if (_db != null) return _db!;

    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, "school_admin.db");
    print(path);

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
        CREATE TABLE students(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          username TEXT,
          password TEXT,
          jurusan TEXT,
          kelas TEXT,
          noUrut TEXT,
          ruang TEXT,
          waktu1 TEXT,
          waktu2 TEXT
        );

        CREATE TABLE config(
          id INTEGER PRIMARY KEY,
          examTitle TEXT,
          schoolName TEXT,
          year TEXT,
          examLink TEXT,
          deskTitle TEXT
        );
        """);
      },
    );

    return _db!;
  }
}
