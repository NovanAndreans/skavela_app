// ignore_for_file: file_names
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:skavela_app/Utils/AppImages.dart';
import '../Models/StudentModel.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../Utils/AppSetting.dart';

Future<pw.MemoryImage> loadImage(String path) async {
  final bytes = await rootBundle.load(path);
  return pw.MemoryImage(bytes.buffer.asUint8List());
}

class ExamCardPdfService {
  static Future<Uint8List> generate(List<StudentModel> students) async {
    final logo1 = await loadImage(appImages.logoMalang);
    final logo2 = await loadImage(appImages.logoSMK);
    final wm = await loadImage(appImages.logoWM);

    final pdf = pw.Document();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {

        const margin = 6.0;
        const spacing = 4.0;

        final pageFormat = format.copyWith(
          marginLeft: margin,
          marginRight: margin,
          marginTop: margin,
          marginBottom: margin,
        );

        final cardWidth =
            (pageFormat.availableWidth - (spacing * 2)) / 3;

        final cardHeight =
            (pageFormat.availableHeight - (spacing * 2)) / 3;

        const cardsPerPage = 9;

        for (int i = 0; i < students.length; i += cardsPerPage) {
          final chunk = students.skip(i).take(cardsPerPage).toList();

          pdf.addPage(
            pw.Page(
              pageFormat: pageFormat,
              build: (context) {
                return pw.Stack(
                  children: [

                    /// WATERMARK
                    pw.Positioned.fill(
                      child: pw.Center(
                        child: pw.Transform.rotate(
                          angle: -0.5,
                          child: pw.Opacity(
                            opacity: 0.08,
                            child: pw.Text(
                              "Asistensi Mengajar UM x SKAVELA 2026",
                              style: pw.TextStyle(
                                fontSize: cardWidth * 0.18,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// GRID
                    pw.Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: chunk.map((s) {
                        return pw.Container(
                          width: cardWidth,
                          height: cardHeight,
                          child: _card(s, logo1, logo2, wm),
                        );
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          );
        }

        return pdf.save();
      },
    );

    return pdf.save();
  }

  static pw.Widget _card(
    StudentModel s,
    pw.MemoryImage logo1,
    pw.MemoryImage logo2,
    pw.MemoryImage logo3,
  ) {
    return pw.FittedBox(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(2),
        decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
        child: pw.Column(
          children: [

            /// HEADER
            pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Image(logo1, width: 35, height: 45),
                    pw.Column(
                      children: [
                        pw.Text("KARTU PESERTA PSAJ",
                            style: pw.TextStyle(fontSize: 11)),
                        pw.Text(
                          "SMK NEGERI 7 KOTA MALANG",
                          style: pw.TextStyle(
                              fontSize: 13,
                              fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          "Tahun Ajaran ${Appsetting.tahunAjaran}",
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    pw.Image(logo2, width: 38, height: 41),
                  ],
                ),
                pw.Divider(),
                pw.Text(
                  "Link Ujian : ${Appsetting.linkUjian}",
                  style: const pw.TextStyle(fontSize: 11),
                ),
                pw.Divider(),
              ],
            ),

            /// BODY
            pw.Expanded(
              child: pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment:
                              pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Ruang : ${s.ruang}",
                                style: const pw.TextStyle(fontSize: 12)),
                            pw.Column(
                              children: [
                                pw.Text(s.waktu1,
                                    style:
                                        const pw.TextStyle(fontSize: 11)),
                                pw.Text(s.waktu2,
                                    style:
                                        const pw.TextStyle(fontSize: 11)),
                              ],
                            ),
                            pw.Text(
                              s.noUrut,
                              style: pw.TextStyle(
                                fontSize: 11,
                                color: PdfColors.red,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        pw.Divider(),
                        pw.Table(
                          columnWidths: {
                            0: const pw.FlexColumnWidth(2),
                            1: const pw.FixedColumnWidth(5),
                            2: const pw.FlexColumnWidth(3),
                          },
                          children: [
                            _row("Nama", s.name),
                            _row("Username", s.username),
                            _row("Password", s.password),
                            _row("Konsentrasi", s.jurusan),
                          ],
                        ),
                      ],
                    ),
                  ),

                  pw.Container(
                    width: 12,
                    color: PdfColors.grey400,
                    child: pw.Center(
                      child: pw.Transform.rotate(
                        angle: 1.57,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static pw.TableRow _row(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(3),
          child: pw.Text(label),
        ),
        pw.Text(":"),
        pw.Padding(
          padding: const pw.EdgeInsets.all(3),
          child: pw.Text(value),
        ),
      ],
    );
  }
}