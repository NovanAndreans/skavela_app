import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../Databases/database.dart';
import '../Models/AppConfig.dart';

class ConfigRepository {

  static Future<void> save(AppConfig config) async {
    final db = await AppDatabase.instance();

    await db.insert(
      "config",
      config.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<AppConfig> get() async {
    final db = await AppDatabase.instance();

    final result = await db.query("config", limit: 1);

    if (result.isEmpty) {
      return AppConfig(
        examTitle: "Kartu Peserta PSAJ",
        schoolName: "SMKN 7 MALANG",
        year: "2025/2026",
        examLink: "cbt.smkn7malang.sch.id",
        deskTitle: "Penilaian Sumatif Akhir Jenjang",
      );
    }

    return AppConfig.fromMap(result.first);
  }
}