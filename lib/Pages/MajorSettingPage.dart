import 'package:flutter/material.dart';
import '../Models/MajorModel.dart';
import '../Repositories/MajorRepository.dart';

class MajorSettingPage extends StatefulWidget {
  const MajorSettingPage({super.key});

  @override
  State<MajorSettingPage> createState() => _MajorSettingPageState();
}

class _MajorSettingPageState extends State<MajorSettingPage> {
  List<Major> majors = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    majors = await MajorRepository.getAll();
    setState(() {});
  }

  // ================= ADD / EDIT =================

  void openForm({Major? major}) {
    final code = TextEditingController(text: major?.code);
    final name = TextEditingController(text: major?.name);
    Color selected = major?.color ?? Colors.blue;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(major == null ? "Tambah Jurusan" : "Edit Jurusan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: code, decoration: const InputDecoration(labelText: "Kode")),
              TextField(controller: name, decoration: const InputDecoration(labelText: "Nama")),

              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                children: Colors.primaries.map((c) {
                  return GestureDetector(
                    onTap: () {
                      selected = c;
                      Navigator.pop(context);
                      openForm(
                        major: Major(
                          id: major?.id,
                          code: code.text,
                          name: name.text,
                          colorValue: c.value,
                        ),
                      );
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      color: c,
                    ),
                  );
                }).toList(),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                final newMajor = Major(
                  id: major?.id,
                  code: code.text,
                  name: name.text,
                  colorValue: selected.value,
                );

                if (major == null) {
                  await MajorRepository.insert(newMajor);
                } else {
                  await MajorRepository.update(newMajor);
                }

                Navigator.pop(context);
                load();
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  // ================= DELETE =================

  void delete(Major m) async {
    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Jurusan"),
        content: Text("Yakin hapus ${m.code}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await MajorRepository.delete(m.id!);
      load();
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan Jurusan"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => openForm(),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: majors.length,
        itemBuilder: (context, i) {
          final m = majors[i];

          return ListTile(
            leading: Container(
              width: 20,
              height: 20,
              color: m.color,
            ),
            title: Text("${m.code} - ${m.name}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => openForm(major: m),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => delete(m),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}