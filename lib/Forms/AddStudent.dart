import 'package:flutter/material.dart';

class StudentFormDialog extends StatefulWidget {
  const StudentFormDialog({super.key});

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
                    'Tambah Data Siswa Ujian',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),

                  _field(nameController, 'Nama Siswa'),

                  Row(
                    children: [
                      Expanded(child: _field(usernameController, 'Username')),
                      const SizedBox(width: 12),
                      Expanded(child: _field(passwordController, 'Password')),
                    ],
                  ),

                  _field(jurusanController, 'Jurusan'),

                  Row(
                    children: [
                      Expanded(child: _field(waktu1Controller, 'Waktu Sesi 1')),
                      const SizedBox(width: 12),
                      Expanded(child: _field(waktu2Controller, 'Waktu Sesi 2')),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _field(kelasController, 'Kelas'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: _field(noUrutController, 'No Urut')),
                      const SizedBox(width: 12),
                      Expanded(child: _field(ruangController, 'Ruang')),
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

  Widget _field(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
      ),
    );
  }
}
