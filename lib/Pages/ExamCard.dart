// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:skavela_app/Models/MajorModel.dart';
import 'package:skavela_app/Models/StudentModel.dart';
import 'package:skavela_app/Repositories/ConfigRepository.dart';
import '../Models/AppConfig.dart';
import '../Repositories/MajorRepository.dart';
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
  AppConfig config = AppConfig(
    examTitle: "Kartu Peserta PSAJ",
    schoolName: "SMKN 7 MALANG",
    year: "2025/2026",
    examLink: "cbt.smkn7malang.sch.id",
    deskTitle: "Penilaian Sumatif Akhir Jenjang",
  );

  List<Major> majors = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    students = await StudentRepository.getAll();
    config = await ConfigRepository.get();
    majors = await MajorRepository.getAll();
    setState(() {});
  }

  void openFilterDialog() async {
    // final classController = TextEditingController();
    final startController = TextEditingController();
    final endController = TextEditingController();

    String? selectedClass;
    String? selectedMajor;

    final classes = await StudentRepository.getClasses();
    // final majors = await MajorRepository.getCodes();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Filter Data"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                hint: const Text("Pilih Kelas"),
                value: selectedClass,
                items: classes.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c));
                }).toList(),
                onChanged: (v) => selectedClass = v,
              ),

              // const SizedBox(height: 10),

              // DropdownButtonFormField<String>(
              //   hint: const Text("Pilih Jurusan"),
              //   value: selectedMajor,
              //   items: majors.map((m) {
              //     return DropdownMenuItem(value: m, child: Text(m));
              //   }).toList(),
              //   onChanged: (v) => selectedMajor = v,
              // ),

              // const SizedBox(height: 10),

              // TextField(
              //   controller: startController,
              //   keyboardType: TextInputType.number,
              //   decoration: const InputDecoration(labelText: "No Urut Awal"),
              // ),

              // TextField(
              //   controller: endController,
              //   keyboardType: TextInputType.number,
              //   decoration: const InputDecoration(labelText: "No Urut Akhir"),
              // ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                final students = await StudentRepository.filter(
                  className: selectedClass,
                  majorCode: selectedMajor,
                  startNumber: int.tryParse(startController.text),
                  endNumber: int.tryParse(endController.text),
                );

                Navigator.pop(context);

                final pdf = await ExamCardPdfService.generate(students);

                try {
                  AppLoading.show("Mengekspor Kartu Ujian...");

                  await Printing.layoutPdf(onLayout: (format) => pdf);
                } finally { 
                  AppLoading.hide();
                }
              },
              child: const Text("Generate"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(3),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final pdf = await ExamCardPdfService.generate(students);

                  try {
                    AppLoading.show("Mengekspor Kartu Ujian...");

                    await Printing.layoutPdf(onLayout: (format) => pdf);
                  } finally {
                    AppLoading.hide();
                  }
                },
                child: const Text("Export Semua"),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: openFilterDialog,
                child: const Text("Export per Kelas"),
              ),
            ],
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
                child: ExamCardWidget(
                  student: students[i],
                  config: config,
                  majors: majors,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
