import 'package:flutter/material.dart';
import 'package:skavela_app/Models/AppConfig.dart';
import 'package:skavela_app/Models/StudentModel.dart';
import 'package:skavela_app/Repositories/StudentRepository.dart';
import 'package:skavela_app/Services/DeskCardPdfService.dart';
import 'package:skavela_app/Utils/AppLoading.dart';

import '../Models/MajorModel.dart';
import '../Repositories/ConfigRepository.dart';
import '../Repositories/MajorRepository.dart';
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
    final classController = TextEditingController();
    final startController = TextEditingController();
    final endController = TextEditingController();

    String? selectedClass;
    String? selectedMajor;

    final classes = await StudentRepository.getClasses();
    final majors = await MajorRepository.getCodes();

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

                await DeskCardPdfService.generate(students);
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
            label: const Text("Export Semua"),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: openFilterDialog,
            child: const Text("Export per Kelas"),
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
            return DeskCardWidget(
              student: students[index],
              config: config,
              majors: majors,
            );
          },
        ),
      ),
    );
  }
}
