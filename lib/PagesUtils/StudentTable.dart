import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

import '../Models/StudentModel.dart';

class StudentTable extends StatefulWidget {
  final List<StudentModel> students;
  final Function(String index) onDelete;
  final Function(String username) onEdit;
  final Function(Set<String>, bool) onSelectionChanged;

  final Set<String> selectedUsernames;
  final bool isAllSelected;

  final bool isLoading; // ✅ TAMBAHAN

  const StudentTable({
    super.key,
    required this.students,
    required this.onDelete,
    required this.onEdit,
    required this.onSelectionChanged,
    required this.selectedUsernames,
    required this.isAllSelected,
    this.isLoading = false, // default
  });

  @override
  State<StudentTable> createState() => _StudentTableState();
}

class _StudentTableState extends State<StudentTable>
    with SingleTickerProviderStateMixin {
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
  int currentPage = 0;

  int? sortColumnIndex;
  bool sortAscending = true;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    /// ✅ shimmer animation
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
          ..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 1).animate(_controller);
  }

  void onSort(int columnIndex, bool ascending) {
    setState(() {
      sortColumnIndex = columnIndex;
      sortAscending = ascending;
    });
  }

  @override
  void didUpdateWidget(covariant StudentTable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.students.length != widget.students.length) {
      currentPage = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// ✅ SKELETON BOX
  Widget skeleton({double width = 80}) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: width,
        height: 14,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final startIndex = currentPage * rowsPerPage;
    final paginatedStudents = widget.students
        .skip(startIndex)
        .take(rowsPerPage)
        .toList();

    final totalPages =
        (widget.students.length / rowsPerPage).ceil();

    final columns = <DataColumn>[
      DataColumn2(
        size: ColumnSize.S,
        label: Checkbox(
          value: widget.isAllSelected,
          onChanged: (value) {
            final newAll = value ?? false;
            Set<String> newSelected;

            if (newAll) {
              newSelected =
                  widget.students.map((e) => e.username).toSet();
            } else {
              newSelected = {};
            }

            widget.onSelectionChanged(newSelected, newAll);
          },
        ),
      ),
      const DataColumn2(size: ColumnSize.S, label: Text('No')),
      DataColumn2(
        size: ColumnSize.L,
        label: const Text('Nama Siswa'),
        onSort: (columnIndex, ascending) =>
            onSort(columnIndex, ascending),
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
          onSort: (columnIndex, ascending) =>
              onSort(columnIndex, ascending),
        ),
      );
    }

    if (columnVisibility["noUrut"]!) {
      columns.add(
        DataColumn2(
          size: ColumnSize.M,
          label: const Text('No Urut'),
          numeric: true,
          onSort: (columnIndex, ascending) =>
              onSort(columnIndex, ascending),
        ),
      );
    }

    if (columnVisibility["ruang"]!) {
      columns.add(
        const DataColumn2(size: ColumnSize.S, label: Text('Ruang')),
      );
    }

    columns.add(
      const DataColumn2(size: ColumnSize.M, label: Text('Aksi')),
    );

    return Column(
      children: [
        /// 🔽 COLUMN TOGGLE (TIDAK DIUBAH)
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
                  columnVisibility[key] =
                      !columnVisibility[key]!;
                });
              },
            ),
          ],
        ),

        /// 🔽 TABLE AREA (INI YANG DITAMBAH LOGIC)
        Expanded(
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Builder(
                builder: (_) {
                  /// =========================
                  /// ✅ LOADING SKELETON
                  /// =========================
                  if (widget.isLoading) {
                    return DataTable2(
                      columns: columns,
                      rows: List.generate(5, (index) {
                        return DataRow(
                          cells: List.generate(columns.length, (i) {
                            return DataCell(skeleton(width: 80));
                          }),
                        );
                      }),
                    );
                  }

                  /// =========================
                  /// ✅ EMPTY STATE
                  /// =========================
                  if (widget.students.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.inbox_outlined,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            "Belum ada data siswa",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  /// =========================
                  /// ✅ ORIGINAL TABLE (UTUH)
                  /// =========================
                  return DataTable2(
                    sortColumnIndex: sortColumnIndex,
                    sortAscending: sortAscending,
                    minWidth: 1200,
                    columnSpacing: 16,
                    horizontalMargin: 12,
                    headingRowHeight: 42,
                    columns: columns,
                    rows: paginatedStudents
                        .asMap()
                        .entries
                        .map((entry) {
                      final index = entry.key;
                      final student = entry.value;

                      final cells = <DataCell>[
                        DataCell(
                          Checkbox(
                            value: widget.selectedUsernames
                                .contains(student.username),
                            onChanged: (value) {
                              final newSelected = Set<String>.from(
                                  widget.selectedUsernames);

                              if (value == true) {
                                newSelected.add(student.username);
                              } else {
                                newSelected
                                    .remove(student.username);
                              }

                              final newAll =
                                  newSelected.length ==
                                      widget.students.length;

                              widget.onSelectionChanged(
                                  newSelected, newAll);
                            },
                          ),
                        ),
                        DataCell(Text(
                            '${startIndex + index + 1}')),
                        DataCell(Text(student.name)),
                      ];

                      if (columnVisibility["username"]!) {
                        cells.add(
                            DataCell(Text(student.username)));
                      }

                      if (columnVisibility["password"]!) {
                        cells.add(
                            DataCell(Text(student.password)));
                      }

                      if (columnVisibility["jurusan"]!) {
                        cells.add(
                            DataCell(Text(student.jurusan)));
                      }

                      if (columnVisibility["waktu1"]!) {
                        cells.add(
                            DataCell(Text(student.waktu1)));
                      }

                      if (columnVisibility["waktu2"]!) {
                        cells.add(
                            DataCell(Text(student.waktu2)));
                      }

                      if (columnVisibility["kelas"]!) {
                        cells.add(
                            DataCell(Text(student.kelas)));
                      }

                      if (columnVisibility["noUrut"]!) {
                        cells.add(
                            DataCell(Text(student.noUrut)));
                      }

                      if (columnVisibility["ruang"]!) {
                        cells.add(
                            DataCell(Text(student.ruang)));
                      }

                      cells.add(
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                    Icons.edit_outlined,
                                    size: 18),
                                onPressed: () {
                                  widget.onEdit(student.username);
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                    Icons.delete_outline,
                                    size: 18),
                                onPressed: () async {
                                  final confirm =
                                      await showDialog<bool>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title:
                                            const Text("Hapus Data"),
                                        content: const Text(
                                            "Yakin ingin menghapus data ini?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(
                                                    context, false),
                                            child:
                                                const Text("Batal"),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context, true);
                                            },
                                            child:
                                                const Text("Hapus"),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  if (confirm == true) {
                                    widget.onDelete(
                                        student.username);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );

                      return DataRow(cells: cells);
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ),

        /// 🔽 PAGINATION (TIDAK DIUBAH)
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
                  currentPage = 0;
                });
              },
            ),

            const SizedBox(width: 16),

            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: currentPage > 0
                  ? () {
                      setState(() {
                        currentPage--;
                      });
                    }
                  : null,
            ),

            Text("Page ${currentPage + 1} / $totalPages"),

            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed:
                  (currentPage + 1) * rowsPerPage <
                          widget.students.length
                      ? () {
                          setState(() {
                            currentPage++;
                          });
                        }
                      : null,
            ),

            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}