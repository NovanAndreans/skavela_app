import 'package:flutter/material.dart';
import '../Data/MajorData.dart';

class MajorSettingPage extends StatefulWidget {
  const MajorSettingPage({super.key});

  @override
  State<MajorSettingPage> createState() => _MajorSettingPageState();
}

class _MajorSettingPageState extends State<MajorSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Warna Jurusan",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: majors.length,
              itemBuilder: (context, index) {
                final major = majors[index];

                return Card(
                  child: ListTile(
                    title: Text(major.name),
                    trailing: GestureDetector(
                      onTap: () async {
                        final color = await showDialog<Color>(
                          context: context,
                          builder: (_) => _ColorPickerDialog(
                            initialColor: major.color,
                          ),
                        );

                        if (color != null) {
                          setState(() {
                            major.color = color;
                          });
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: major.color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class _ColorPickerDialog extends StatefulWidget {
  final Color initialColor;

  const _ColorPickerDialog({required this.initialColor});

  @override
  State<_ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<_ColorPickerDialog> {
  late Color selected;

  @override
  void initState() {
    selected = widget.initialColor;
    super.initState();
  }

  final colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Pilih Warna"),
      content: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: colors
            .map(
              (c) => GestureDetector(
                onTap: () {
                  setState(() {
                    selected = c;
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c,
                    borderRadius: BorderRadius.circular(8),
                    border: selected == c
                        ? Border.all(width: 3, color: Colors.black)
                        : null,
                  ),
                ),
              ),
            )
            .toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, selected),
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}