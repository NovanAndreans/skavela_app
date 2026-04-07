import 'package:flutter/material.dart';

import '../Models/StudentModel.dart';
import '../PagesUtils/StudentTable.dart';
import '../Forms/StudentForm.dart';
import '../Repositories/StudentRepository.dart';
import '../Services/ExcelExportService.dart';
import '../Services/ExcelImportService.dart';
import '../Services/ExcelTemplateService.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  List<StudentModel> students = [];

  void editStudent(int index) async {
    final result = await showDialog<StudentModel>(
      context: context,
      builder: (_) => StudentFormDialog(student: students[index]),
    );

    if (result != null) {
      setState(() {
        students[index] = result;
      });
    }
  }

  void deleteStudent(int index) {
    setState(() {
      students.removeAt(index);
    });
  }

  final TextEditingController searchController = TextEditingController();
  List<StudentModel> filteredStudents = [];

  void filterStudents() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredStudents = students.where((s) {
        return s.name.toLowerCase().contains(query) ||
            s.username.toLowerCase().contains(query) ||
            s.kelas.toLowerCase().contains(query) ||
            s.ruang.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    filteredStudents = students;

    loadData();

    searchController.addListener(() {
      filterStudents();
    });
  }

  void loadData() async {
    List<StudentModel> studentsLoad = await StudentRepository.getAll();
    setState(() {
      students = studentsLoad;
      filteredStudents = studentsLoad;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Data Siswa',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const StudentFormDialog(),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Cari siswa...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    isDense: true,
                  ),
                ),
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () async {
                  final path = await ExcelTemplateService.generateTemplate();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Template disimpan di: $path")),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('Template Import'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  try {
                    final imported = await ExcelImportService.importStudents();

                    if (imported.isNotEmpty) {
                      setState(() {
                        students.addAll(imported);
                        filterStudents();
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Berhasil diimport"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.upload_file),
                label: const Text('Import Excel'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () async {
                  await ExcelExportService.exportStudents(students);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Export berhasil")),
                  );
                },
                icon: const Icon(Icons.download),
                label: const Text('Export'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Expanded(
            child: StudentTable(
              students: filteredStudents,
              onDelete: deleteStudent,
              onEdit: editStudent,
            ),
          ),
        ],
      ),
    );
  }
}
