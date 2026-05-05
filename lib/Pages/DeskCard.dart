import 'package:flutter/material.dart';
import 'package:skavela_app/Models/AppConfig.dart';
import 'package:skavela_app/Models/StudentModel.dart';
import 'package:skavela_app/Repositories/StudentRepository.dart';
import 'package:skavela_app/Services/DeskCardPdfService.dart';
import 'package:skavela_app/Utils/AppLoading.dart';

import '../Models/MajorModel.dart';
import '../Repositories/ActivityRepository.dart';
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

                await DeskCardPdfService.generate(filtered);

                await ActivityRepository.log(
                  "EXPORT_DESK_CARD",
                  "Generate kartu meja kelas $selectedClass",
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Berhasil Mencetak"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text("Generate"),
            ),
          ],
        );
      },
    );
  }

  void openFilterDialogRoom() async {
    String? selectedRoom;
    final rooms = await StudentRepository.getRooms();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Cetak per Ruang Ujian"),
          content: DropdownButtonFormField<String>(
            hint: const Text("Pilih Ruangan"),
            value: selectedRoom,
            items: rooms.map((c) {
              return DropdownMenuItem(value: c, child: Text(c));
            }).toList(),
            onChanged: (v) => selectedRoom = v,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                final filtered = await StudentRepository.filterRoom(
                  roomName: selectedRoom,
                );

                Navigator.pop(context);

                await DeskCardPdfService.generate(filtered);

                await ActivityRepository.log(
                  "EXPORT_DESK_CARD",
                  "Generate kartu meja kelas per $selectedRoom",
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Berhasil Mencetak"),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text("Generate"),
            ),
          ],
        );
      },
    );
  }

  /// ================= EXPORT =================
  void exportAll() async {
    try {
      AppLoading.show("Mengekspor Kartu Meja...");
      await DeskCardPdfService.generate(students);
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
                    "Kartu Meja",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: openFilterDialog,
                        icon: const Icon(Icons.filter_alt),
                        label: const Text("Cetak per Kelas"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: openFilterDialogRoom,
                        icon: const Icon(Icons.filter_alt),
                        label: const Text("Cetak per Ruangan"),
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
                  child: students.isEmpty
                      /// ================= EMPTY STATE =================
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_seat_outlined,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Belum ada Data kartu meja",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Data siswa belum tersedia untuk ditampilkan",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      /// ================= ORIGINAL GRID (TIDAK DIUBAH) =================
                      : GridView.builder(
                          itemCount: students.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.7,
                              ),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DeskCardWidget(
                                student: students[index],
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
