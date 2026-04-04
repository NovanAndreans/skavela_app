import 'package:flutter/material.dart';

import '../Models/StudentModel.dart';
import '../PagesUtils/StudentTable.dart';
import '../Forms/StudentForm.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  List<StudentModel> students = [
    StudentModel(
      name: "Anastasya Dwi Putri Maharani",
      username: "SMK0071874989",
      password: "SMK0071874989",
      jurusan: "Desain Produksi Busana",
      waktu1: "07.30 - 09.00 WIB",
      waktu2: "09.30 - 11.00 WIB",
      kelas: "XII DPB 1",
      noUrut: "1",
      ruang: "Lab 20",
    ),
  ];

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

    searchController.addListener(() {
      filterStudents();
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
                onPressed: () {},
                icon: const Icon(Icons.upload_file),
                label: const Text('Import Excel'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: () {},
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
