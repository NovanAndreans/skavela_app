// ignore_for_file: file_names

import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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
    final pdf = pw.Document();

    final logo1 = await loadImage(appImages.logoMalang);
    final logo2 = await loadImage(appImages.logoSMK);
    final wm = await loadImage(appImages.logoWM);

    // loop per 9 data
    for (int i = 0; i < students.length; i += 9) {
      final chunk = students.skip(i).take(9).toList();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat(
            330 * PdfPageFormat.mm,
            210 * PdfPageFormat.mm,
          ),
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
                            fontSize: 50,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                /// GRID 3x3
                pw.Column(
                  children: List.generate(3, (row) {
                    return pw.Expanded(
                      child: pw.Row(
                        children: List.generate(3, (col) {
                          final index = row * 3 + col;

                          return pw.Expanded(
                            child: pw.Padding(
                              padding: const pw.EdgeInsets.all(4),
                              child: index < chunk.length
                                  ? _card(chunk[index], logo1, logo2, wm)
                                  : pw.Container(),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
                ),
              ],
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
  ) {
    return pw.Container(
      // width: 70 * PdfPageFormat.mm,
      // height: 110 * PdfPageFormat.mm,
      // width: double.infinity,
      // height: double.infinity,
      padding: const pw.EdgeInsets.all(2),
      decoration: pw.BoxDecoration(border: pw.Border.all(width: 1)),
      child: pw.Column(
        children: [
          /// ================= HEADER =================
          pw.Column(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Container(
                      margin: pw.EdgeInsets.all(3),
                      child: pw.Image(logo1, width: 35, height: 45),
                    ), // ganti image kalau ada
                    pw.Column(
                      children: [
                        pw.Text(
                          "KARTU PESERTA PSAJ",
                          style: pw.TextStyle(fontSize: 11),
                        ),
                        pw.Text(
                          "SMK NEGERI 7 KOTA MALANG",
                          style: pw.TextStyle(
                            fontSize: 13,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          "Tahun Ajaran ${Appsetting.tahunAjaran}",
                          style: const pw.TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                    pw.Container(
                      margin: pw.EdgeInsets.all(3),
                      child: pw.Image(logo2, width: 38, height: 41),
                    ),
                  ],
                ),
              ),

              pw.Divider(height: 1),

              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(
                  "Link Ujian : ${Appsetting.linkUjian}",
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ),

              pw.Divider(height: 1),
            ],
          ),

          /// ================= BODY =================
          pw.Expanded(
            child: pw.Row(
              children: [
                /// LEFT CONTENT
                pw.Expanded(
                  child: pw.Stack(
                    alignment: pw.Alignment.centerRight,
                    children: [
                      pw.Container(
                        margin: pw.EdgeInsets.all(3),
                        child: pw.Image(logo3, width: 48, height: 51),
                      ),
                      pw.Column(
                        children: [
                          /// RUANG + WAKTU + NO
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(2),
                            child: pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "Ruang : ${s.ruang}",
                                  style: const pw.TextStyle(fontSize: 12),
                                ),
                                pw.Column(
                                  children: [
                                    pw.Text(
                                      s.waktu1,
                                      style: const pw.TextStyle(fontSize: 11),
                                    ),
                                    pw.Text(
                                      s.waktu2,
                                      style: const pw.TextStyle(fontSize: 11),
                                    ),
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
                          ),

                          pw.Divider(height: 1),

                          /// TABLE
                          pw.Expanded(
                            child: pw.Table(
                              // border: pw.TableBorder.all(),
                              columnWidths: {
                                0: const pw.FixedColumnWidth(105),
                                1: const pw.FixedColumnWidth(8),
                                2: const pw.FlexColumnWidth(),
                              },
                              children: [
                                _row("Nama", s.name),
                                _row("Username", s.username),
                                _row("Password", s.password),
                                _row("Konsentrasi Keahlian", s.jurusan),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// SIDE COLOR (HANYA BODY)
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(),
                    color: PdfColors.grey400,
                  ),
                  width: 12 * PdfPageFormat.mm,
                  height: double.infinity,
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
          padding: const pw.EdgeInsets.all(4.53),
          child: pw.Text(label, style: const pw.TextStyle(fontSize: 10)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(2),
          child: pw.Text(":", style: const pw.TextStyle(fontSize: 10)),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(4.53),
          child: pw.Text(value, style: const pw.TextStyle(fontSize: 10)),
        ),
      ],
    );
  }
}
