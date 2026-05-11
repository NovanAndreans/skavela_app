import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../Models/StudentModel.dart';
import '../Models/MajorModel.dart';
import '../Models/AppConfig.dart';
import '../Repositories/ConfigRepository.dart';
import '../Repositories/MajorRepository.dart';
import '../Utils/AppImages.dart';

Future<pw.MemoryImage> loadImage(String path) async {
  final bytes = await rootBundle.load(path);
  return pw.MemoryImage(bytes.buffer.asUint8List());
}

class DeskCardPdfService {
  static Future<void> generate(List<StudentModel> students) async {
    final logo1 = await loadImage(appImages.logoMalang);
    final logo2 = await loadImage(appImages.logoSMK);

    final config = await ConfigRepository.get();
    final majors = await MajorRepository.getAll();

    await Printing.layoutPdf(
      onLayout: (format) async {
        final pdf = pw.Document();

        /// === F4 LANDSCAPE FIXED ===
        final pageFormat = PdfPageFormat(
          330 * PdfPageFormat.mm,
          210 * PdfPageFormat.mm,
        );

        /// === SAFE MARGIN (REALISTIC PRINTER BUFFER) ===
        const safeMargin = 5.0 * PdfPageFormat.mm;

        final usableWidth = pageFormat.width - (safeMargin * 2);
        final usableHeight = pageFormat.height - (safeMargin * 2);

        /// === GRID FIXED 3 x 4 ===
        const cols = 3;
        const rows = 4;
        const spacing = 4.0;

        final cardWidth = (usableWidth - ((cols - 1) * spacing)) / cols;

        final cardHeight = (usableHeight - ((rows - 1) * spacing)) / rows;

        /// === SPLIT PER 12 STUDENTS ===
        for (int i = 0; i < students.length; i += 12) {
          final chunk = students.skip(i).take(12).toList();

          pdf.addPage(
            pw.Page(
              pageFormat: pageFormat,
              build: (context) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.all(safeMargin),
                  child: pw.Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: chunk.map((s) {
                      return pw.Container(
                        width: cardWidth,
                        height: cardHeight,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 1),
                        ),
                        child: _card(s, logo1, logo2, config, majors),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          );
        }

        return pdf.save();
      },
    );
  }

  static pw.Widget _card(
    StudentModel s,
    pw.MemoryImage logo1,
    pw.MemoryImage logo2,
    AppConfig config,
    List<Major> majors,
  ) {
    final major = majors.firstWhere((m) => m.name == s.jurusan);

    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          /// HEADER
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Image(logo1, width: 30),
              pw.Column(
                children: [
                  pw.Text(
                    config.deskTitle,
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(config.year, style: const pw.TextStyle(fontSize: 10)),
                  pw.Text(
                    config.schoolName,
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.Image(logo2, width: 30),
            ],
          ),

          pw.Divider(height: 10),

          pw.Text(
            config.examLink,
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(fontSize: 11),
          ),

          pw.Divider(height: 10),

          /// ROW INFO
          pw.Row(
            children: [
              _box(s.ruang, flex: 2, bold: true),
              _box(s.kelas, flex: 3, bold: true),
              _box(s.noUrut, flex: 2, color: PdfColors.red, bold: true),
            ],
          ),

          pw.SizedBox(height: 2),

          /// TABLE
          pw.Expanded(
            child: pw.Table(
              border: pw.TableBorder.all(width: 1),
              columnWidths: {
                0: const pw.FixedColumnWidth(50),
                1: const pw.FixedColumnWidth(8),
                2: const pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(
                  children: [_label("Nama"), _colon(":"), _value(s.name)],
                ),
                pw.TableRow(
                  children: [
                    _label("Jurusan"),
                    _colon(":"),
                    _value(
                      s.jurusan,
                      background: PdfColor.fromInt(major.colorValue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _box(
    String text, {
    int flex = 1,
    PdfColor? color,
    bool bold = false,
  }) {
    return pw.Expanded(
      flex: flex,
      child: pw.Container(
        alignment: pw.Alignment.center,
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 10,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: color,
          ),
        ),
      ),
    );
  }

  static pw.Widget _label(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(3),
      color: PdfColors.grey300,
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
    );
  }

  static pw.Widget _colon(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.fromLTRB(3, 3, 2, 3),
      color: PdfColors.grey300,
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 9)),
    );
  }

  static pw.Widget _value(String text, {PdfColor? background}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(3),
      color: background,
      child: pw.Text(
        text,
        maxLines: 1,
        overflow: pw.TextOverflow.clip,
        style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
      ),
    );
  }
}
