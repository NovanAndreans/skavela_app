import '../Databases/database.dart';
import '../Models/AppConfig.dart';

class ConfigRepository {
  static Future<void> save(AppConfig config) async {
    final db = await AppDatabase.instance();
    await db.update("config", config.toMap(), where: "id = ?", whereArgs: [1]);
  }

  static Future<AppConfig> get() async {
    final db = await AppDatabase.instance();

    final result = await db.query("config", limit: 1);

    if (result.isEmpty) {
      await db.insert(
        "config",
        AppConfig(
          examTitle: "Kartu Peserta PSAJ",
          schoolName: "SMKN 7 MALANG",
          year: "2025/2026",
          examLink: "cbt.smkn7malang.sch.id",
          deskTitle: "Penilaian Sumatif Akhir Jenjang",
        ).toMap(),
      );

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
