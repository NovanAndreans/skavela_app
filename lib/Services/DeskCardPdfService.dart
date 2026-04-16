import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:skavela_app/Models/StudentModel.dart';
import 'package:skavela_app/Utils/AppImages.dart';
import 'package:skavela_app/Models/AppConfig.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../Models/MajorModel.dart';
import '../Repositories/ConfigRepository.dart';
import '../Repositories/MajorRepository.dart';

Future<pw.MemoryImage> loadImage(String path) async {
  final bytes = await rootBundle.load(path);
  return pw.MemoryImage(bytes.buffer.asUint8List());
}

class DeskCardPdfService {
  static Future<void> generate(List<StudentModel> students) async {
    final logo1 = await loadImage(appImages.logoMalang);
    final logo2 = await loadImage(appImages.logoSMK);

    AppConfig config;
    config = await ConfigRepository.get();

    List<Major> majors;
    majors = await MajorRepository.getAll();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async {
        final pdf = pw.Document();

        const margin = 0.25 * PdfPageFormat.cm;
        const spacing = 4.0;
        // const cardsPerPage = 12;

        // pakai ukuran kertas dari printer
        final pageFormat = PdfPageFormat(
          210 * PdfPageFormat.mm, // width F4
          330 * PdfPageFormat.mm, // height F4
          marginLeft: margin,
          marginRight: margin,
          marginTop: margin,
          marginBottom: margin,
        ).landscape;

        final cardWidth = (pageFormat.availableWidth - (spacing * 2)) / 3;

        final cardHeight = (pageFormat.availableHeight - (spacing * 3)) / 4;

        // final totalPages = (students.length / cardsPerPage).ceil();

        pdf.addPage(
          pw.MultiPage(
            pageFormat: pageFormat,
            build: (context) {
              return [
                pw.Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: students.map((s) {
                    return pw.Container(
                      width: cardWidth,
                      height: cardHeight,
                      padding: const pw.EdgeInsets.all(2),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(width: 1),
                      ),
                      child: _card(s, logo1, logo2, config, majors),
                    );
                  }).toList(),
                ),
              ];
            },
          ),
        );

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
    return pw.SizedBox.expand(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          /// HEADER
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 2),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(logo1, width: 35, height: 45),
                pw.Column(
                  children: [
                    pw.Text(
                      config.deskTitle,
                      style: pw.TextStyle(
                        fontSize: 9,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      config.year,
                      style: const pw.TextStyle(fontSize: 8),
                    ),
                    pw.Text(
                      config.schoolName,
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                pw.Image(logo2, width: 38, height: 41),
              ],
            ),
          ),

          pw.Divider(height: 1),
          pw.Container(
            margin: pw.EdgeInsets.all(2),
            child: pw.Text(
              config.examLink,
              style: const pw.TextStyle(fontSize: 9),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.Divider(height: 1),

          /// LAB | KELAS | NO
          pw.Row(
            children: [
              _box(s.ruang, flex: 2, bold: true),
              _box(s.kelas, flex: 3, bold: true),
              _box(
                s.noUrut,
                flex: 2,
                color: PdfColor.fromInt(major.colorValue),
                bold: true,
              ),
            ],
          ),

          pw.Divider(height: 1),

          /// TABLE
          pw.Expanded(
            child: pw.Table(
              border: pw.TableBorder.all(width: 1),
              columnWidths: {
                0: const pw.FixedColumnWidth(60),
                1: const pw.FlexColumnWidth(),
              },
              children: [
                pw.TableRow(children: [_label("Nama Peserta"), _value(s.name)]),
                pw.TableRow(
                  children: [
                    _label("Konsli / Kelas"),
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
        padding: const pw.EdgeInsets.all(4),
        alignment: pw.Alignment.center,
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
            color: color,
          ),
        ),
      ),
    );
  }

  static pw.Widget _label(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      color: PdfColors.grey200,
      child: pw.Text(text, style: const pw.TextStyle(fontSize: 8)),
    );
  }

  static pw.Widget _value(String text, {PdfColor? background}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(4),
      color: background,
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
      ),
    );
  }
}
