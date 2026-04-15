import 'package:flutter/material.dart';
import '../Models/AppConfig.dart';
import '../Repositories/ConfigRepository.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final _formKey = GlobalKey<FormState>();

  final examTitle = TextEditingController();
  final schoolName = TextEditingController();
  final year = TextEditingController();
  final link = TextEditingController();
  final deskTitle = TextEditingController();

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    final config = await ConfigRepository.get();

    examTitle.text = config.examTitle;
    schoolName.text = config.schoolName;
    year.text = config.year;
    link.text = config.examLink;
    deskTitle.text = config.deskTitle;

    setState(() {});
  }

  void save() async {
    if (!_formKey.currentState!.validate()) return;

    final config = AppConfig(
      examTitle: examTitle.text,
      schoolName: schoolName.text,
      year: year.text,
      examLink: link.text,
      deskTitle: deskTitle.text,
    );

    await ConfigRepository.save(config);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Config disimpan")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            _field("Judul Kartu Ujian", examTitle),
            _field("Nama Sekolah", schoolName),
            _field("Tahun Ajaran", year),
            _field("Tautan Ujian", link),
            _field("Judul Kartu Meja", deskTitle),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: save,
              child: const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (v) =>
            v == null || v.isEmpty ? "Tidak boleh kosong" : null,
      ),
    );
  }
}