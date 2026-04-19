import 'package:flutter/material.dart';
import '../Models/MajorModel.dart';
import '../Repositories/ActivityRepository.dart';
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

  /// ================= FORM =================
  void openForm({Major? major}) {
    final code = TextEditingController(text: major?.code);
    final name = TextEditingController(text: major?.name);

    Color selected = major?.color ?? Colors.blue;

    double hue = HSVColor.fromColor(selected).hue;
    double saturation = HSVColor.fromColor(selected).saturation;
    double value = HSVColor.fromColor(selected).value;

    final hexController = TextEditingController(
      text: selected.value.toRadixString(16).substring(2).toUpperCase(),
    );

    final List<Color> palette = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.blueGrey,
    ];

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            /// HSV → COLOR
            Color getColor() {
              return HSVColor.fromAHSV(1, hue, saturation, value).toColor();
            }

            /// HEX → COLOR
            Color? hexToColor(String hex) {
              try {
                hex = hex.replaceAll("#", "");
                if (hex.length == 6) {
                  return Color(int.parse("FF$hex", radix: 16));
                }
              } catch (_) {}
              return null;
            }

            /// update HEX dari color
            void updateHex(Color c) {
              hexController.text = c.value
                  .toRadixString(16)
                  .substring(2)
                  .toUpperCase();
            }

            selected = getColor();
            updateHex(selected);

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(major == null ? "Tambah Jurusan" : "Edit Jurusan"),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    /// INPUT
                    TextField(
                      controller: code,
                      decoration: const InputDecoration(labelText: "Kode"),
                    ),
                    TextField(
                      controller: name,
                      decoration: const InputDecoration(labelText: "Nama"),
                    ),

                    const SizedBox(height: 16),

                    /// PREVIEW
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: selected,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// HEX INPUT
                    TextField(
                      controller: hexController,
                      decoration: const InputDecoration(
                        labelText: "HEX Color",
                        prefixText: "#",
                      ),
                      onChanged: (val) {
                        final c = hexToColor(val);
                        if (c != null) {
                          final hsv = HSVColor.fromColor(c);
                          setStateDialog(() {
                            hue = hsv.hue;
                            saturation = hsv.saturation;
                            value = hsv.value;
                          });
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    /// PALETTE
                    SizedBox(
                      height: 80,
                      child: GridView.builder(
                        itemCount: palette.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 9,
                              crossAxisSpacing: 6,
                              mainAxisSpacing: 6,
                            ),
                        itemBuilder: (_, i) {
                          final c = palette[i];

                          return GestureDetector(
                            onTap: () {
                              final hsv = HSVColor.fromColor(c);
                              setStateDialog(() {
                                hue = hsv.hue;
                                saturation = hsv.saturation;
                                value = hsv.value;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: c,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// HUE
                    Row(
                      children: [
                        const Text("Hue"),
                        Expanded(
                          child: Slider(
                            value: hue,
                            min: 0,
                            max: 360,
                            onChanged: (v) {
                              setStateDialog(() => hue = v);
                            },
                          ),
                        ),
                      ],
                    ),

                    /// SAT
                    Row(
                      children: [
                        const Text("Sat"),
                        Expanded(
                          child: Slider(
                            value: saturation,
                            min: 0,
                            max: 1,
                            onChanged: (v) {
                              setStateDialog(() => saturation = v);
                            },
                          ),
                        ),
                      ],
                    ),

                    /// VAL
                    Row(
                      children: [
                        const Text("Val"),
                        Expanded(
                          child: Slider(
                            value: value,
                            min: 0,
                            max: 1,
                            onChanged: (v) {
                              setStateDialog(() => value = v);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                      await ActivityRepository.log(
                        "MAJOR",
                        "Tambah ${newMajor.code}",
                      );
                    } else {
                      await MajorRepository.update(newMajor);
                      await ActivityRepository.log(
                        "MAJOR",
                        "Update ${newMajor.code}",
                      );
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
      },
    );
  }

  /// ================= DELETE =================
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

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pengaturan Jurusan",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => openForm(),
                icon: const Icon(Icons.add),
                label: const Text("Tambah Jurusan"),
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// LIST
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: majors.isEmpty
                  ? const Center(child: Text("Belum ada data"))
                  : ListView.separated(
                      itemCount: majors.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (context, i) {
                        final m = majors[i];

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: m.color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  "${m.code} - ${m.name}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
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
            ),
          ),
        ],
      ),
    );
  }
}
