import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Models/ActivityModel.dart';
import '../Repositories/ActivityRepository.dart';
import '../Repositories/MajorRepository.dart';
import '../Repositories/StudentRepository.dart';
import '../Widgets/StatCard.dart';

class DashboardPage extends StatefulWidget {
  final Function(int) onNavigate;

  const DashboardPage({super.key, required this.onNavigate});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int totalStudents = 0;
  int totalClasses = 0;
  int totalMajors = 0;

  List<Activity> activities = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final students = await StudentRepository.getAll();
    final classes = await StudentRepository.getClasses();
    final majors = await MajorRepository.getAll();
    final recent = await ActivityRepository.getRecent();

    setState(() {
      totalStudents = students.length;
      totalClasses = classes.length;
      totalMajors = majors.length;
      activities = recent.take(5).toList(); // ambil 5 terbaru
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          /// WAJIB: Expanded biar tidak error
          Expanded(
            child: Row(
              children: [
                /// ================= LEFT =================
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// HEADER
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Dashboard',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: const [
                              CircleAvatar(
                                radius: 6,
                                backgroundColor: Colors.red,
                              ),
                              SizedBox(width: 8),
                              Text('Offline'),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// BANNER
                      Container(
                        width: 900,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/classroom.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black.withOpacity(0.4),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Selamat datang di\nExamly Skavela',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Cetak kartu ujian dengan mudah dan cepat',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// CETAK
                      const Text(
                        'Cetak',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              icon: Icons.credit_card,
                              label: 'Kartu Ujian',
                              color: Colors.deepPurple,
                              onTap: () => widget.onNavigate(4),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildActionCard(
                              icon: Icons.table_restaurant,
                              label: 'Kartu Meja',
                              color: Colors.teal,
                              onTap: () => widget.onNavigate(5),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// ✅ STAT (FIX ERROR DI SINI)
                      SizedBox(
                        height: 120, // <-- penting!
                        child: Row(
                          children: [
                            Expanded(
                              child: StatCard(
                                title: 'Total Siswa',
                                value: totalStudents.toString(),
                              ),
                            ),
                            Expanded(
                              child: StatCard(
                                title: 'Total Kelas',
                                value: totalClasses.toString(),
                              ),
                            ),
                            Expanded(
                              child: StatCard(
                                title: 'Total Jurusan',
                                value: totalMajors.toString(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                /// ================= RIGHT =================
                SizedBox(
                  width: 300,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recent Activity',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),

                        /// WAJIB Expanded biar tidak error
                        Expanded(
                          child: Expanded(
                            child: ListView.builder(
                              itemCount: activities.length,
                              itemBuilder: (context, i) {
                                final a = activities[i];

                                return ActivityItem(
                                  action: a.action,
                                  description: a.description,
                                  time: formatTime(a.createdAt),
                                );
                              },
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => widget.onNavigate(6),
                            child: const Text(
                              'Lihat Semua',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ACTION BUTTON
  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [color.withOpacity(0.8), color]),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ACTIVITY ITEM
class ActivityItem extends StatelessWidget {
  final String action;
  final String description;
  final String time;

  const ActivityItem({
    super.key,
    required this.action,
    required this.description,
    required this.time,
  });

  IconData getIcon() {
    switch (action) {
      case "IMPORT_EXCEL":
        return Icons.upload_file;
      case "EXPORT_EXCEL":
        return Icons.download;
      case "EXPORT_EXAM_CARD":
        return Icons.picture_as_pdf;
      case "EXPORT_DESK_CARD":
        return Icons.table_restaurant;
      case "CREATE_STUDENT":
        return Icons.person_add;
      case "DELETE_STUDENT":
        return Icons.delete;
      default:
        return Icons.history;
    }
  }

  Color getColor() {
    switch (action) {
      case "IMPORT_EXCEL":
        return Colors.blue;
      case "EXPORT_EXAM_CARD":
        return Colors.deepPurple;
      case "EXPORT_DESK_CARD":
        return Colors.teal;
      case "DELETE_STUDENT":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: getColor(),
            child: Icon(getIcon(), color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(description, style: const TextStyle(fontSize: 12)),
          ),
          Text(time, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}

String formatTime(String iso) {
  final dt = DateTime.parse(iso);
  return DateFormat("HH:mm").format(dt);
}
