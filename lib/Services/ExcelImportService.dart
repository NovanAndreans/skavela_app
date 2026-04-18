import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import '../Models/StudentModel.dart';
import '../Repositories/ActivityRepository.dart';
import '../Repositories/StudentRepository.dart';

class ExcelImportService {
  static const expectedHeaders = [
    'No',
    'Nama Siswa',
    'Username',
    'Password',
    'Jurusan',
    'Waktu',
    'Waktu',
    'Kelas',
    'No Urut',
    'Ruang',
  ];

  static bool validateHeader(List<Data?> headerRow) {
    for (int i = 0; i < expectedHeaders.length; i++) {
      final cell = headerRow[i]?.value.toString().trim();

      if (cell != expectedHeaders[i]) {
        return false;
      }
    }
    return true;
  }

  static Future<List<StudentModel>> importStudents() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result == null) return [];

    final file = result.files.first;

    Uint8List bytes;

    if (file.bytes != null) {
      bytes = file.bytes!;
    } else {
      final path = file.path!;
      bytes = await File(path).readAsBytes();
    }

    final excel = Excel.decodeBytes(bytes);

    final sheet = excel.tables.values.first;

    final header = sheet.rows.first;

    if (!validateHeader(header)) {
      throw Exception("Format Excel tidak sesuai template");
    }

    List<StudentModel> students = [];

    for (int i = 1; i < sheet.rows.length; i++) {
      final row = sheet.rows[i];
      StudentModel newStudent = StudentModel(
        name: row[1]?.value.toString() ?? '',
        username: row[2]?.value.toString() ?? '',
        password: row[3]?.value.toString() ?? '',
        jurusan: row[4]?.value.toString() ?? '',
        waktu1: row[5]?.value.toString() ?? '',
        waktu2: row[6]?.value.toString() ?? '',
        kelas: row[7]?.value.toString() ?? '',
        noUrut: row[8]?.value.toString() ?? '',
        ruang: row[9]?.value.toString() ?? '',
      );

      students.add(newStudent);

      await StudentRepository.insert(newStudent); //Insert ke database
    }

    await ActivityRepository.log(
      "IMPORT_EXCEL",
      "Import ${students.length} siswa dari Excel",
    );

    return students;
  }
}
