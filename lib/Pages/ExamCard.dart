import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:skavela_app/Models/MajorModel.dart';
import 'package:skavela_app/Models/StudentModel.dart';
import 'package:skavela_app/Repositories/ConfigRepository.dart';

import '../Models/AppConfig.dart';
import '../Repositories/ActivityRepository.dart';
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
  List<Major> majors = [];

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
    majors = await MajorRepository.getAll();
    setState(() {});
  }

  /// ================= EXPORT ALL =================
  void exportAll() async {
    final pdf = await ExamCardPdfService.generate(students);

    try {
      AppLoading.show("Mengekspor Kartu Ujian...");
      await Printing.layoutPdf(onLayout: (format) => pdf);
    } finally {
      AppLoading.hide();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Berhasil Mencetak"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  /// ================= FILTER =================
  void openFilterDialog() async {
    String? selectedClass;
    final classes = await StudentRepository.getClasses();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Cetak per Kelas"),
          content: DropdownButtonFormField<String>(
            hint: const Text("Pilih Kelas"),
            value: selectedClass,
            items: classes.map((c) {
              return DropdownMenuItem(value: c, child: Text(c));
            }).toList(),
            onChanged: (v) => selectedClass = v,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                final filtered = await StudentRepository.filter(
                  className: selectedClass,
                );

                Navigator.pop(context);

                final pdf = await ExamCardPdfService.generate(filtered);

                await ActivityRepository.log(
                  "EXPORT_EXAM_CARD",
                  "Generate kartu ujian kelas $selectedClass",
                );

                try {
                  AppLoading.show("Mengekspor...");
                  await Printing.layoutPdf(onLayout: (format) => pdf);
                } finally {
                  AppLoading.hide();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Berhasil Mencetak"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: const Text("Generate"),
            ),
          ],
        );
      },
    );
  }

  /// ================= RESPONSIVE GRID =================
  int getCrossAxisCount(double width) {
    if (width > 1400) return 4;
    if (width > 1000) return 3;
    if (width > 700) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = getCrossAxisCount(constraints.maxWidth);

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              /// ================= HEADER =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cetak Kartu Ujian",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  /// BUTTON RIGHT
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: openFilterDialog,
                        icon: const Icon(Icons.filter_alt),
                        label: const Text("Cetak per Kelas"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: exportAll,
                        icon: const Icon(Icons.print),
                        label: const Text("Cetak"),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// ================= GRID =================
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GridView.builder(
                    itemCount: students.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 260 / 170,
                    ),
                    itemBuilder: (_, i) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                        ),
                        child: ExamCardWidget(
                          student: students[i],
                          config: config,
                          majors: majors,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
