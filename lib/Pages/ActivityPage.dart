import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Models/ActivityModel.dart';
import '../Repositories/ActivityRepository.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<Activity> activities = [];
  String selectedFilter = "ALL";

  final filters = [
    "ALL",
    "IMPORT_EXCEL",
    "EXPORT_EXCEL",
    "EXPORT_EXAM_CARD",
    "EXPORT_DESK_CARD",
    "CREATE_STUDENT",
    "UPDATE_STUDENT",
    "DELETE_STUDENT",
    "UPDATE_MAJOR",
  ];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    if (selectedFilter == "ALL") {
      activities = await ActivityRepository.getRecent();
    } else {
      activities = await ActivityRepository.getByAction(selectedFilter);
    }

    setState(() {});
  }

  IconData getIcon(String action) {
    switch (action) {
      case "IMPORT_EXCEL":
        return Icons.upload_file;
      case "EXPORT_EXCEL":
        return Icons.download;
      case "EXPORT_EXAM_CARD":
        return Icons.picture_as_pdf;
      case "EXPORT_DESK_CARD":
        return Icons.table_restaurant;
      case "STUDENT":
        return Icons.person_add;
      // case "DELETE_STUDENT":
      //   return Icons.delete;
      default:
        return Icons.history;
    }
  }

  String formatDate(String iso) {
    final dt = DateTime.parse(iso);
    return DateFormat("dd MMM yyyy, HH:mm").format(dt);
  }

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
              const Text(
                "Activity Log",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              Row(
                children: [
                  DropdownButton<String>(
                    value: selectedFilter,
                    items: filters.map((f) {
                      return DropdownMenuItem(value: f, child: Text(f));
                    }).toList(),
                    onChanged: (v) {
                      selectedFilter = v!;
                      load();
                    },
                  ),
                  SizedBox(width: 16),
                  PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == "clear_all") {
                        await ActivityRepository.deleteAll();
                        

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Berhasil Menghapus semua Riwayat"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      } else if (value == "keep_50") {
                        await ActivityRepository.keepLatest(50);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Berhasil Menghapus Riwayat, dengan menyimpan 50 riwayat"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      }
                      load();
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: "keep_50",
                        child: Text("Simpan 50 terbaru"),
                      ),
                      const PopupMenuItem(
                        value: "clear_all",
                        child: Text("Hapus semua"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          /// LIST
          Expanded(
            child: Card(
              child: ListView.separated(
                itemCount: activities.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final a = activities[i];

                  return ListTile(
                    leading: CircleAvatar(child: Icon(getIcon(a.action))),
                    title: Text(a.description),
                    subtitle: Text(formatDate(a.createdAt)),
                    trailing: Text(
                      a.action,
                      style: const TextStyle(fontSize: 10),
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
