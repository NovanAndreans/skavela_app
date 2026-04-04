import 'dart:io';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:skavela_app/Models/StudentModel.dart';

class ExcelExportService {
  static Future<void> exportStudents(List<StudentModel> students) async {
    final excel = Excel.createExcel();
    final sheet = excel['Data Export'];

    final headers = [
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

    for (int i = 0; i < headers.length; i++) {
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
              .value =
          headers[i];
    }

    for (int i = 0; i < students.length; i++) {
      final s = students[i];

      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1))
              .value =
          i + 1;
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
              .value =
          s.name;
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1))
              .value =
          s.username;
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1))
              .value =
          s.password;
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i + 1))
              .value =
          s.jurusan;
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: i + 1))
              .value =
          s.waktu1;
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: i + 1))
              .value =
          s.waktu2;
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: i + 1))
              .value =
          s.kelas;
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: i + 1))
              .value =
          s.noUrut;
      sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: i + 1))
              .value =
          s.ruang;
    }
    
    final now = DateTime.now();
    final formattedDate =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";

    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Simpan Excel',
      fileName: 'Data_Siswa_$formattedDate.xlsx',
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    if (outputFile == null) return;

    final file = File(outputFile);
    await file.writeAsBytes(excel.encode()!);
  }
}
