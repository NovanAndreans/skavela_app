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
      const SnackBar(content: Text("Config berhasil disimpan")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          /// ================= HEADER =================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pengaturan Aplikasi",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// ================= FORM =================
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    /// ===== SECTION: UJIAN =====
                    _sectionTitle("Pengaturan Ujian"),
                    _field("Judul Kartu Ujian", examTitle),
                    _field("Tautan Ujian", link),

                    const SizedBox(height: 20),

                    /// ===== SECTION: SEKOLAH =====
                    _sectionTitle("Informasi Sekolah"),
                    _field("Nama Sekolah", schoolName),
                    _field("Tahun Ajaran", year),

                    const SizedBox(height: 20),

                    /// ===== SECTION: MEJA =====
                    _sectionTitle("Kartu Meja"),
                    _field("Judul Kartu Meja", deskTitle),

                    const SizedBox(height: 30),

                    /// BUTTON
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          onPressed: save,
                          icon: const Icon(Icons.save),
                          label: const Text("Simpan"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SECTION TITLE =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// ================= INPUT FIELD =================
  Widget _field(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (v) =>
            v == null || v.isEmpty ? "Tidak boleh kosong" : null,
      ),
    );
  }
}