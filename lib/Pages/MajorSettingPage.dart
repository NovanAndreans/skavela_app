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

  void pickColor(Major m) async {
    Color selected = m.color;

    await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Pilih Warna"),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              children: Colors.primaries.map((c) {
                return GestureDetector(
                  onTap: () {
                    selected = c;
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    color: c,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );

    final updated = Major(
      id: m.id,
      code: m.code,
      name: m.name,
      colorValue: selected.value,
    );

    await MajorRepository.update(updated);
    load();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: majors.length,
      itemBuilder: (context, i) {
        final m = majors[i];

        return ListTile(
          title: Text("${m.code} - ${m.name}"),
          trailing: GestureDetector(
            onTap: () => pickColor(m),
            child: Container(
              width: 40,
              height: 40,
              color: m.color,
            ),
          ),
        );
      },
    );
  }
}