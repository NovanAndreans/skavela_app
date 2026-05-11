import 'package:flutter/material.dart';
import 'package:skavela_app/Repositories/StudentRepository.dart';

import '../Models/StudentModel.dart';
import '../Repositories/ActivityRepository.dart';
import '../Repositories/MajorRepository.dart';
import '../Models/MajorModel.dart';
import '../Widgets/CustomInputs.dart';

class StudentFormDialog extends StatefulWidget {
  final StudentModel? student;

  const StudentFormDialog({super.key, this.student});

  @override
  State<StudentFormDialog> createState() => _StudentFormDialogState();
}

class _StudentFormDialogState extends State<StudentFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final waktu1Controller = TextEditingController();
  final waktu2Controller = TextEditingController();
  final kelasController = TextEditingController();
  final noUrutController = TextEditingController();
  final ruangController = TextEditingController();

  List<Major> majors = [];
  String? selectedJurusan;

  @override
  void initState() {
    super.initState();
    loadMajors();

    if (widget.student != null) {
      nameController.text = widget.student!.name;
      usernameController.text = widget.student!.username;
      passwordController.text = widget.student!.password;
      waktu1Controller.text = widget.student!.waktu1;
      waktu2Controller.text = widget.student!.waktu2;
      kelasController.text = widget.student!.kelas;
      noUrutController.text = widget.student!.noUrut;
      ruangController.text = widget.student!.ruang;

      selectedJurusan = widget.student!.jurusan;
    }
  }

  Future<void> loadMajors() async {
    final data = await MajorRepository.getAll();
    setState(() {
      majors = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 600,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.student == null
                        ? 'Tambah Data Siswa Ujian'
                        : 'Edit Data Siswa',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),

                  CustomInputText(nameController, 'Nama Siswa'),

                  Row(
                    children: [
                      Expanded(
                        child: CustomInputText(
                            usernameController, 'Username'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child:
                            CustomInputText(passwordController, 'Password'),
                      ),
                    ],
                  ),

                  /// 🔽 DROPDOWN JURUSAN (NEW)
                  DropdownButtonFormField<String>(
                    value: selectedJurusan,
                    decoration: const InputDecoration(
                      labelText: 'Jurusan',
                      border: OutlineInputBorder(),
                    ),
                    items: majors.map((m) {
                      return DropdownMenuItem(
                        value: m.name,
                        child: Text("${m.code} - ${m.name}"),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedJurusan = value;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Jurusan wajib dipilih' : null,
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: CustomInputText(
                          waktu1Controller,
                          'Waktu Sesi 1',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomInputText(
                          waktu2Controller,
                          'Waktu Sesi 2',
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child:
                            CustomInputText(kelasController, 'Kelas'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomInputText(
                            noUrutController, 'No Urut'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child:
                            CustomInputText(ruangController, 'Ruang'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final student = StudentModel(
                              name: nameController.text,
                              username: usernameController.text,
                              password: passwordController.text,
                              jurusan: selectedJurusan!,
                              kelas: kelasController.text,
                              noUrut: noUrutController.text,
                              ruang: ruangController.text,
                              waktu1: waktu1Controller.text,
                              waktu2: waktu2Controller.text,
                            );

                            if (widget.student == null) {
                              await StudentRepository.insert(student);
                              await ActivityRepository.log(
                                "STUDENT",
                                "Menambah siswa: ${student.name}",
                              );
                            } else {
                              await StudentRepository.update(student);
                              await ActivityRepository.log(
                                "STUDENT",
                                "Edit siswa: ${student.name}",
                              );
                            }

                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Simpan'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}