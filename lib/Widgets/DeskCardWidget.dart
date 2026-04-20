import 'package:flutter/material.dart';
import 'package:skavela_app/Models/AppConfig.dart';
import 'package:skavela_app/Models/MajorModel.dart';
import 'package:skavela_app/Models/StudentModel.dart';
import 'package:skavela_app/Utils/AppImages.dart';

import '../Utils/MajorColorHelper.dart';

class DeskCardWidget extends StatelessWidget {
  final StudentModel student;
  final AppConfig config;
  final List<Major> majors;

  const DeskCardWidget({
    super.key,
    required this.student,
    required this.config,
    required this.majors,
  });

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
                    width: 35,
                    height: 45,
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        config.deskTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(config.year, style: TextStyle(fontSize: 12)),
                      Text(
                        config.schoolName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(3),
                  child: Image.asset(appImages.logoSMK, width: 38, height: 41),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              config.examLink,
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
                  _value(
                    student.jurusan,
                    background: getMajorColor(majors, student.jurusan),
                  ),
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
            fontSize: 13,
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
      child: Text(text, style: const TextStyle(fontSize: 10)),
    );
  }

  static Widget _value(String text, {Color? background}) {
    return Container(
      padding: const EdgeInsets.all(6),
      color: background,
      child: Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}
