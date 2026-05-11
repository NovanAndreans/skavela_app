import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';

class AppDatabase {
  static Database? _db;

  static Future<Database> instance() async {
    if (_db != null) return _db!;

    final dir = await getApplicationSupportDirectory();
    final path = join(dir.path, "school_admin.db");

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

        CREATE TABLE majors(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          code TEXT,
          name TEXT,
          color INTEGER
        );

        CREATE TABLE activities(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          action TEXT,
          description TEXT,
          created_at TEXT
        );
        """);

        await db.insert("majors", {
          "code": "DPB",
          "name": "Desain dan Produksi Busana",
          "color": Colors.pink.value,
        });

        await db.insert("majors", {
          "code": "KUL",
          "name": "Kuliner",
          "color": Colors.green.value,
        });

        await db.insert("majors", {
          "code": "KA",
          "name": "Kimia Analisis",
          "color": Colors.blueGrey.value,
        });

        await db.insert("majors", {
          "code": "APL",
          "name": "Analisis Pengujian Laboratorium",
          "color": Colors.blue.value,
        });

        await db.insert("majors", {
          "code": "DKV",
          "name": "Desain Komunikasi Visual",
          "color": Colors.yellow.value,
        });

        await db.insert("majors", {
          "code": "PSPT",
          "name": "Produksi dan Siaran Program Televisi",
          "color": Colors.red.value,
        });

        await db.insert("majors", {
          "code": "TKJ",
          "name": "Teknik Komputer dan Jaringan",
          "color": Colors.deepOrange.value,
        });
      },
    );

    return _db!;
  }
}
