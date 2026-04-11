import 'package:flutter/material.dart';
import 'package:skavela_app/Models/StudentModel.dart';
import 'package:skavela_app/Utils/AppImages.dart';

class DeskCardWidget extends StatelessWidget {
  final StudentModel student;

  const DeskCardWidget({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /// HEADER
          Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(3),
                  child: Image.asset(
                    appImages.logoMalang,
                    width: 45,
                    height: 55,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: const [
                      Text(
                        "PENILAIAN SUMATIF AKHIR JENJANG",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "TAHUN AJARAN 2025 - 2026",
                        style: TextStyle(fontSize: 12),
                      ),
                      Text(
                        "SMK NEGERI 7 MALANG",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(3),
                  child: Image.asset(appImages.logoSMK, width: 48, height: 51),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              "Link Ujian : cbt.smkn7mlg.sch.id",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ),

          const Divider(height: 1),

          /// BARIS RUANG / KELAS / NOMOR
          Row(
            children: [
              _topBox(student.ruang, flex: 2, bold: true),
              _topBox(student.kelas, flex: 3, bold: true),
              _topBox(student.noUrut, flex: 2, color: Colors.red, bold: true),
            ],
          ),

          const Divider(height: 1),

          /// TABLE DATA
          Table(
            border: TableBorder.all(color: Colors.black),
            columnWidths: const {
              0: FixedColumnWidth(120),
              1: FlexColumnWidth(),
            },
            children: [
              TableRow(
                children: [_label("Nama Peserta"), _value(student.name)],
              ),
              TableRow(
                children: [
                  _label("Konsli / Kelas"),
                  _value(student.jurusan, background: Colors.orange.shade200),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _topBox(
    String text, {
    int flex = 1,
    Color? color,
    bool bold = false,
  }) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            color: color ?? Colors.black,
          ),
        ),
      ),
    );
  }

  static Widget _label(String text) {
    return Container(
      padding: const EdgeInsets.all(6),
      color: Colors.grey.shade300,
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }

  static Widget _value(String text, {Color? background}) {
    return Container(
      padding: const EdgeInsets.all(6),
      color: background,
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }
}
