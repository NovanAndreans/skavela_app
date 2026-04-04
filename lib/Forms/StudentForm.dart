import 'package:flutter/material.dart';

import '../Models/StudentModel.dart';
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
  final jurusanController = TextEditingController();
  final waktu1Controller = TextEditingController();
  final waktu2Controller = TextEditingController();
  final kelasController = TextEditingController();
  final noUrutController = TextEditingController();
  final ruangController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.student != null) {
      nameController.text = widget.student!.name;
      usernameController.text = widget.student!.username;
      passwordController.text = widget.student!.password;
      jurusanController.text = widget.student!.jurusan;
      waktu1Controller.text = widget.student!.waktu1;
      waktu2Controller.text = widget.student!.waktu2;
      kelasController.text = widget.student!.kelas;
      noUrutController.text = widget.student!.noUrut;
      ruangController.text = widget.student!.ruang;
    }
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
                      Expanded(child: CustomInputText(usernameController, 'Username')),
                      const SizedBox(width: 12),
                      Expanded(child: CustomInputText(passwordController, 'Password')),
                    ],
                  ),

                  CustomInputText(jurusanController, 'Jurusan'),

                  Row(
                    children: [
                      Expanded(child: CustomInputText(waktu1Controller, 'Waktu Sesi 1')),
                      const SizedBox(width: 12),
                      Expanded(child: CustomInputText(waktu2Controller, 'Waktu Sesi 2')),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomInputText(kelasController, 'Kelas'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: CustomInputText(noUrutController, 'No Urut')),
                      const SizedBox(width: 12),
                      Expanded(child: CustomInputText(ruangController, 'Ruang')),
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
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
