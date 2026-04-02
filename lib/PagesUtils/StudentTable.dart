import 'package:flutter/material.dart';

import '../Models/StudentModel.dart';

final dummyStudents = [
  StudentModel(
    nis: '2024001',
    name: 'Ahmad Fauzi',
    className: 'X IPA 1',
    examNumber: '01',
  ),
  StudentModel(
    nis: '2024002',
    name: 'Siti Nurhaliza',
    className: 'X IPA 1',
    examNumber: '02',
  ),
];

class StudentsTable extends StatefulWidget {
  final List<StudentModel> students;
  final Function(StudentModel) onDelete;

  const StudentsTable({
    super.key,
    required this.students,
    required this.onDelete,
  });

  @override
  State<StudentsTable> createState() => _StudentsTableState();
}

class _StudentsTableState extends State<StudentsTable> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.students.where((s) {
      return s.name!.toLowerCase().contains(search.toLowerCase()) ||
          s.nis!.toLowerCase().contains(search.toLowerCase());
    }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Cari nama atau NIS...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() {
                search = value;
              });
            },
          ),
        ),
        Expanded(
          child: Card(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('NIS')),
                  DataColumn(label: Text('Nama')),
                  DataColumn(label: Text('Kelas')),
                  DataColumn(label: Text('No Ujian')),
                  DataColumn(label: Text('Aksi')),
                ],
                rows: filtered
                    .map(
                      (student) => DataRow(
                        cells: [
                          DataCell(Text(student.nis ?? '')),
                          DataCell(Text(student.name ?? '')),
                          DataCell(Text(student.className ?? '')),
                          DataCell(Text(student.examNumber ?? '-')),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () {
                                    widget.onDelete(student);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
