import 'package:flutter/material.dart';
import 'package:skavela_app/Models/AppConfig.dart';
import 'package:skavela_app/Models/StudentModel.dart';
import 'package:skavela_app/Repositories/StudentRepository.dart';
import 'package:skavela_app/Services/DeskCardPdfService.dart';
import 'package:skavela_app/Utils/AppLoading.dart';

import '../Repositories/ConfigRepository.dart';
import '../Widgets/DeskCardWidget.dart';

class DeskCardPage extends StatefulWidget {
  const DeskCardPage({super.key});

  @override
  State<DeskCardPage> createState() => _DeskCardPageState();
}

class _DeskCardPageState extends State<DeskCardPage> {
  List<StudentModel> students = [];
  AppConfig config = AppConfig(
    examTitle: "Kartu Peserta PSAJ",
    schoolName: "SMKN 7 MALANG",
    year: "2025/2026",
    examLink: "cbt.smkn7malang.sch.id",
    deskTitle: "Penilaian Sumatif Akhir Jenjang",
  );

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    students = await StudentRepository.getAll();
    config = await ConfigRepository.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview Kartu Meja"),
        actions: [
          ElevatedButton.icon(
            onPressed: () async {
              try {
                AppLoading.show("Mengekspor Kartu Meja...");

                await DeskCardPdfService.generate(students);
              } finally {
                AppLoading.hide();
              }
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text("Export PDF"),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: students.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.7,
          ),
          itemBuilder: (context, index) {
            return DeskCardWidget(student: students[index], config: config);
          },
        ),
      ),
    );
  }
}
