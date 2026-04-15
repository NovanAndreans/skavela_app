import 'package:flutter/material.dart';
import 'package:skavela_app/Models/AppConfig.dart';
import 'package:skavela_app/Utils/AppSetting.dart';
import '../Models/StudentModel.dart';
import '../Utils/MajorColorHelper.dart';

import '../Utils/AppImages.dart';

class ExamCardWidget extends StatelessWidget {
  final StudentModel student;
  final AppConfig config;

  const ExamCardWidget({
    super.key,
    required this.student,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    // final color = getMajorColor(student.jurusan);

    return Container(
      width: 260,
      height: 170,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Column(
        children: [
          /// ================= HEADER =================
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.all(3),
                    child: Image.asset(
                      appImages.logoMalang,
                      width: 35,
                      height: 45,
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        config.examTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                      Text(config.schoolName, style: TextStyle(fontSize: 8)),
                      Text(config.year, style: TextStyle(fontSize: 8)),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.all(3),
                    child: Image.asset(
                      appImages.logoSMK,
                      width: 38,
                      height: 41,
                    ),
                  ),
                ],
              ),

              const Divider(height: 1, color: Colors.black),

              Padding(
                padding: const EdgeInsets.all(3),
                child: Text(
                  config.examLink,
                  style: const TextStyle(fontSize: 8),
                ),
              ),

              const Divider(height: 1, color: Colors.black),
            ],
          ),

          /// ================= BODY =================
          Expanded(
            child: Row(
              children: [
                /// KONTEN KIRI
                Expanded(
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Container(
                        margin: EdgeInsets.all(3),
                        child: Image.asset(
                          appImages.logoWM,
                          width: 48,
                          height: 51,
                        ),
                      ),
                      Column(
                        children: [
                          /// RUANG + WAKTU + NO
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Ruang : ${student.ruang}",
                                  style: const TextStyle(fontSize: 9),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      student.waktu1,
                                      style: const TextStyle(fontSize: 8),
                                    ),
                                    Text(
                                      student.waktu2,
                                      style: const TextStyle(fontSize: 8),
                                    ),
                                  ],
                                ),
                                Text(
                                  student.noUrut,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Divider(height: 1, color: Colors.black),

                          /// TABLE
                          Expanded(
                            child: Table(
                              // border: TableBorder.all(color: Colors.black),
                              columnWidths: const {
                                0: FixedColumnWidth(90),
                                1: FixedColumnWidth(8),
                                2: FlexColumnWidth(),
                              },
                              children: [
                                _row("Nama", student.name),
                                _row("Username", student.username),
                                _row("Password", student.password),
                                _row("Konsentrasi Keahlian", student.jurusan),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// SIDE COLOR (SEJAJAR BODY SAJA)
                Container(
                  width: 24,
                  height: double.infinity,
                  color: getMajorColor(student.jurusan),
                  child: Center(
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        student.kelas,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
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

  TableRow _row(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(3.9),
          child: Text(label, style: const TextStyle(fontSize: 8)),
        ),
        const Padding(
          padding: EdgeInsets.all(3.9),
          child: Text(":", style: TextStyle(fontSize: 8)),
        ),
        Padding(
          padding: const EdgeInsets.all(3.9),
          child: Text(value, style: const TextStyle(fontSize: 8)),
        ),
      ],
    );
  }
}
