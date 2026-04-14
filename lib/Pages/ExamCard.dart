// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:skavela_app/Models/StudentModel.dart';
import '../Repositories/StudentRepository.dart';
import '../Services/ExamCardPdfService.dart';
import '../Utils/AppLoading.dart';
import '../Widgets/ExamCardWidget.dart';

class ExamCardPage extends StatefulWidget {
  const ExamCardPage({super.key});

  @override
  State<ExamCardPage> createState() => _ExamCardPageState();
}

class _ExamCardPageState extends State<ExamCardPage> {
  List<StudentModel> students = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    students = await StudentRepository.getAll();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(3),
          child: ElevatedButton(
            onPressed: () async {
              final pdf = await ExamCardPdfService.generate(students);

              try {
                AppLoading.show("Mengekspor Kartu Ujian...");

                await Printing.layoutPdf(onLayout: (format) => pdf);
              } finally {
                AppLoading.hide();
              }
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
              itemCount: students.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 260 / 170,
              ),
              itemBuilder: (_, i) => Container(
                margin: EdgeInsets.all(2.4),
                child: ExamCardWidget(student: students[i]),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
