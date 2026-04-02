import 'package:flutter/material.dart';
import 'package:skavela_app/Models/StudentModel.dart';

import '../PagesUtils/StudentTable.dart';
import '../Forms/AddStudent.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  final List<StudentModel> students = [...dummyStudents];

  void addStudent(StudentModel student) {
    setState(() {
      students.add(student);
    });
  }

  void deleteStudent(StudentModel student) {
    setState(() {
      students.remove(student);
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
                onPressed: () async {
                  final result = await showDialog<StudentModel>(
                    context: context,
                    builder: (_) => const StudentFormDialog(),
                  );

                  if (result != null) {
                    addStudent(result);
                  }
                },
                icon: const Icon(Icons.add),
                label: const Text('Tambah'),
              )
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: StudentsTable(
              students: students,
              onDelete: deleteStudent,
            ),
          )
        ],
      ),
    );
  }
}