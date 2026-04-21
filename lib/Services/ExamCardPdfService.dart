import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show rootBundle;

import '../Models/AppConfig.dart';
import '../Models/MajorModel.dart';
import '../Models/StudentModel.dart';
import '../Repositories/ConfigRepository.dart';
import '../Repositories/MajorRepository.dart';
import '../Utils/AppImages.dart';

Future<pw.MemoryImage> loadImage(String path) async {
  final bytes = await rootBundle.load(path);
  return pw.MemoryImage(bytes.buffer.asUint8List());
}

class ExamCardPdfService {
  static Future<Uint8List> generate(List<StudentModel> students) async {
    final pdf = pw.Document();

    final logo1 = await loadImage(appImages.logoMalang);
    final logo2 = await loadImage(appImages.logoSMK);
    final wm = await loadImage(appImages.logoWM);

    final config = await ConfigRepository.get();
    final majors = await MajorRepository.getAll();

    /// =========================
    /// F4 LANDSCAPE (FIXED)
    /// =========================
    final pageFormat = PdfPageFormat(
      330 * PdfPageFormat.mm,
      210 * PdfPageFormat.mm,
    );

    /// =========================
    /// SAFE MARGIN (ANTI KEPOONG)
    /// =========================
    const margin = 5.0 * PdfPageFormat.mm;

    final usableWidth = pageFormat.width - (margin * 2);
    final usableHeight = pageFormat.height - (margin * 2);

    /// =========================
    /// GRID 3 x 3 (FIXED)
    /// =========================
    const cols = 3;
    const rows = 3;
    const spacing = 4.0;

    final cardWidth = (usableWidth - ((cols - 1) * spacing)) / cols;

    final cardHeight = (usableHeight - ((rows - 1) * spacing)) / rows;

    /// =========================
    /// LOOP PER 9 DATA
    /// =========================
    for (int i = 0; i < students.length; i += 9) {
      final chunk = students.skip(i).take(9).toList();

      pdf.addPage(
        pw.Page(
          pageFormat: pageFormat,
          build: (context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(margin),
              child: pw.Stack(
                children: [
                  /// WATERMARK
                  pw.Center(
                    child: pw.Transform.rotate(
                      angle: -0.5,
                      child: pw.Opacity(
                        opacity: 0.05,
                        child: pw.Image(wm, width: 180),
                      ),
                    ),
                  ),

                  /// GRID FIXED
                  pw.Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: List.generate(chunk.length, (i) {
                      return pw.Container(
                        width: cardWidth,
                        height: cardHeight,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 1),
                        ),
                        child: _card(
                          chunk[i],
                          logo1,
                          logo2,
                          wm,
                          config,
                          majors,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return pdf.save();
  }

  static pw.Widget _card(
    StudentModel s,
    pw.MemoryImage logo1,
    pw.MemoryImage logo2,
    pw.MemoryImage logo3,
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
              pw.Image(logo1, width: 28),
              pw.Column(
                children: [
                  pw.Text(config.examTitle, style: pw.TextStyle(fontSize: 9)),
                  pw.Text(
                    config.schoolName,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(config.year, style: const pw.TextStyle(fontSize: 8)),
                ],
              ),
              pw.Image(logo2, width: 28),
            ],
          ),

          pw.Divider(),

          pw.Text(
            config.examLink,
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(fontSize: 9),
          ),

          pw.Divider(),

          /// BODY
          pw.Expanded(
            child: pw.Row(
              children: [
                /// LEFT CONTENT
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            "Ruang: ${s.ruang}",
                            style: const pw.TextStyle(fontSize: 9),
                          ),
                          pw.Column(
                            children: [
                              pw.Text(
                                s.waktu1,
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                              pw.Text(
                                s.waktu2,
                                style: const pw.TextStyle(fontSize: 9),
                              ),
                            ],
                          ),
                          pw.Container(
                            margin: pw.EdgeInsets.fromLTRB(0, 0, 3, 0),
                            child: pw.Text(
                              s.noUrut,
                              style: pw.TextStyle(
                                fontSize: 9,
                                color: PdfColors.red,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      pw.Divider(),

                      pw.Expanded(
                        child: pw.Stack(
                          alignment: pw.Alignment.centerRight,
                          children: [
                            pw.Table(
                              columnWidths: {
                                0: const pw.FixedColumnWidth(90),
                                1: const pw.FlexColumnWidth(),
                              },
                              children: [
                                _row("Nama", s.name),
                                _row("Username", s.username),
                                _row("Password", s.password),
                                _row("Konsentrasi Keahlian", s.jurusan),
                              ],
                            ),
                            pw.Image(logo3, width: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// SIDE COLOR
                /// SIDE COLOR (HANYA BODY)
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    color: PdfColor.fromInt(major.colorValue),
                  ),
                  width: 12 * PdfPageFormat.mm,
                  height: 100,
                  // color: , // bisa kamu map dari jurusan juga
                  child: pw.Center(
                    child: pw.Transform.rotate(
                      angle: 1.57,
                      child: pw.FittedBox(
                        child: pw.Text(
                          s.kelas,
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.TableRow _row(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(3),
          child: pw.Text(label, style: const pw.TextStyle(fontSize: 8)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(3),
          child: pw.Text(value, style: const pw.TextStyle(fontSize: 8)),
        ),
      ],
    );
  }
}
