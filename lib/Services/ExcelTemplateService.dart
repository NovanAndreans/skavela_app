import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

class ExcelTemplateService {
  static Future<String> generateTemplate() async {
    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

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
          .value = headers[i];
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/Template_Data_Siswa.xlsx';

    final file = File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytesSync(excel.encode()!);

    return filePath;
  }
}