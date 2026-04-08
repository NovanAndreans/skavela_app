import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:skavela_app/Repositories/StudentRepository.dart';

import '../Models/StudentModel.dart';

class StudentTable extends StatefulWidget {
  final List<StudentModel> students;
  final Function(String index) onDelete;
  final Function(int index) onEdit;

  const StudentTable({
    super.key,
    required this.students,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<StudentTable> createState() => _StudentTableState();
}

class _StudentTableState extends State<StudentTable> {
  Map<String, bool> columnVisibility = {
    "username": false,
    "password": false,
    "jurusan": true,
    "waktu1": false,
    "waktu2": false,
    "kelas": true,
    "noUrut": false,
    "ruang": false,
  };

  int rowsPerPage = 10;
  int? sortColumnIndex;
  bool sortAscending = true;

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    final columns = <DataColumn>[
      const DataColumn2(size: ColumnSize.S, label: Text('No')),
      DataColumn2(
        size: ColumnSize.L,
        label: const Text('Nama Siswa'),
        onSort: (columnIndex, ascending) => onSort(columnIndex, ascending),
      ),
    ];

    if (columnVisibility["username"]!) {
      columns.add(
        const DataColumn2(size: ColumnSize.M, label: Text('Username')),
      );
    }

    if (columnVisibility["password"]!) {
      columns.add(
        const DataColumn2(size: ColumnSize.M, label: Text('Password')),
      );
    }

    if (columnVisibility["jurusan"]!) {
      columns.add(
        const DataColumn2(size: ColumnSize.L, label: Text('Jurusan')),
      );
    }

    if (columnVisibility["waktu1"]!) {
      columns.add(
        const DataColumn2(size: ColumnSize.L, label: Text('Waktu 1')),
      );
    }

    if (columnVisibility["waktu2"]!) {
      columns.add(
        const DataColumn2(size: ColumnSize.L, label: Text('Waktu 2')),
      );
    }

    if (columnVisibility["kelas"]!) {
      columns.add(
        DataColumn2(
          size: ColumnSize.M,
          label: const Text('Kelas'),
          onSort: (columnIndex, ascending) => onSort(columnIndex, ascending),
        ),
      );
    }

    if (columnVisibility["noUrut"]!) {
      columns.add(
        DataColumn2(
          size: ColumnSize.M,
          label: const Text('No Urut'),
          numeric: true,
          onSort: (columnIndex, ascending) => onSort(columnIndex, ascending),
        ),
      );
    }

    if (columnVisibility["ruang"]!) {
      columns.add(const DataColumn2(size: ColumnSize.S, label: Text('Ruang')));
    }

    columns.add(const DataColumn2(size: ColumnSize.M, label: Text('Aksi')));
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.view_column),
              tooltip: "Tampilkan/Sembunyikan Kolom",
              itemBuilder: (context) {
                return columnVisibility.keys.map((key) {
                  return CheckedPopupMenuItem(
                    value: key,
                    checked: columnVisibility[key]!,
                    child: Text(key),
                  );
                }).toList();
              },
              onSelected: (key) {
                setState(() {
                  columnVisibility[key] = !columnVisibility[key]!;
                });
              },
            ),
          ],
        ),
        Expanded(
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: DataTable2(
                sortColumnIndex: sortColumnIndex,
                sortAscending: sortAscending,
                minWidth: 1200,
                columnSpacing: 16,
                horizontalMargin: 12,
                // dataRowMinHeight: 36,
                // dataRowMaxHeight: 40,
                headingRowHeight: 42,
                columns: columns,
                rows: widget.students
                    .take(rowsPerPage)
                    .toList()
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key;
                      final student = entry.value;

                      final cells = <DataCell>[
                        DataCell(Text('${index + 1}')),
                        DataCell(Text(student.name)),
                      ];

                      if (columnVisibility["username"]!) {
                        cells.add(DataCell(Text(student.username)));
                      }

                      if (columnVisibility["password"]!) {
                        cells.add(DataCell(Text(student.password)));
                      }

                      if (columnVisibility["jurusan"]!) {
                        cells.add(DataCell(Text(student.jurusan)));
                      }

                      if (columnVisibility["waktu1"]!) {
                        cells.add(DataCell(Text(student.waktu1)));
                      }

                      if (columnVisibility["waktu2"]!) {
                        cells.add(DataCell(Text(student.waktu2)));
                      }

                      if (columnVisibility["kelas"]!) {
                        cells.add(DataCell(Text(student.kelas)));
                      }

                      if (columnVisibility["noUrut"]!) {
                        cells.add(DataCell(Text(student.noUrut)));
                      }

                      if (columnVisibility["ruang"]!) {
                        cells.add(DataCell(Text(student.ruang)));
                      }

                      cells.add(
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                onPressed: () {
                                  widget.onEdit(index);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                ),
                                onPressed: () async {
                                  final confirm = await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Hapus Data"),
                                        content: const Text(
                                          "Apakah Anda yakin ingin menghapus data siswa ini?",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text("Batal"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              StudentRepository.delete(
                                                student.username,
                                              );
                                              Navigator.pop(context, true);
                                            },
                                            child: const Text("Hapus"),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    widget.onDelete(student.username);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );

                      return DataRow(cells: cells);
                    })
                    .toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Rows per page: "),
            const SizedBox(width: 8),
            DropdownButton<int>(
              value: rowsPerPage,
              items: const [
                DropdownMenuItem(value: 5, child: Text("5")),
                DropdownMenuItem(value: 10, child: Text("10")),
                DropdownMenuItem(value: 20, child: Text("20")),
                DropdownMenuItem(value: 50, child: Text("50")),
                DropdownMenuItem(value: 100, child: Text("100")),
              ],
              onChanged: (value) {
                setState(() {
                  rowsPerPage = value!;
                });
              },
            ),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}
