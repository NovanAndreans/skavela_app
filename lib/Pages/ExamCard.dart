import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:skavela_app/Models/StudentModel.dart';
import '../Services/ExamCardPdfService.dart';
import '../Widgets/ExamCardWidget.dart';

import 'package:flutter/material.dart';
import '../Widgets/ExamCardWidget.dart';

class ExamCardPage extends StatelessWidget {
  const ExamCardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dummy = List.generate(
      25,
      (i) => StudentModel(
        name: "Nama Siswa $i",
        username: "SMK000$i",
        password: "SMK000$i",
        jurusan: "Desain Komunikasi Visual",
        kelas: "XII DKV",
        noUrut: "No Urut ${i + 1}",
        ruang: "Lab 20",
        waktu1: "07.30 - 09.00",
        waktu2: "09.30 - 11.00",
      ),
    );

    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(3),
          child: ElevatedButton(
            onPressed: () async {
              final pdf = await ExamCardPdfService.generate(dummy);

              await Printing.layoutPdf(onLayout: (format) => pdf);
            },
            child: const Text("Export PDF"),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.all(3),
            width: 820,
            height: 700,
            color: Colors.grey.shade200,
            child: GridView.builder(
              itemCount: dummy.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 260 / 170,
              ),
              itemBuilder: (_, i) => Container(
                margin: EdgeInsets.all(2.4),
                child: ExamCardWidget(student: dummy[i]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
