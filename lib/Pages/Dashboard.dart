import 'package:flutter/material.dart';
import '../Widgets/StatCard.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: const [
                              CircleAvatar(
                                  radius: 6, backgroundColor: Colors.red),
                              SizedBox(width: 8),
                              Text('Offline'),
                            ],
                          )
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
                              )
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// CETAK
                      const Text(
                        'Cetak',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _buildActionCard(
                              icon: Icons.credit_card,
                              label: 'Kartu Ujian',
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildActionCard(
                              icon: Icons.table_restaurant,
                              label: 'Kartu Meja',
                              color: Colors.teal,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// ✅ STAT (FIX ERROR DI SINI)
                      SizedBox(
                        height: 120, // <-- penting!
                        child: Row(
                          children: const [
                            Expanded(
                                child: StatCard(
                                    title: 'Total Siswa', value: '1.945')),
                            SizedBox(width: 16),
                            Expanded(
                                child: StatCard(
                                    title: 'Total Kelas', value: '50')),
                            SizedBox(width: 16),
                            Expanded(
                                child: StatCard(
                                    title: 'Total Jurusan', value: '7')),
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
                          child: ListView(
                            children: const [
                              ActivityItem(color: Colors.deepPurple),
                              ActivityItem(color: Colors.teal),
                              ActivityItem(color: Colors.red),
                              ActivityItem(color: Colors.blue),
                            ],
                          ),
                        ),

                        const Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Lihat Semua',
                            style: TextStyle(color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  ),
                )
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
  }) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
        ),
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
                  color: Colors.white, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

/// ACTIVITY ITEM
class ActivityItem extends StatelessWidget {
  final Color color;

  const ActivityItem({
    super.key,
    required this.color,
  });

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
            backgroundColor: color,
            child: const Icon(Icons.print, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Cetak kartu ujian\nLorem ipsum dolor',
              style: TextStyle(fontSize: 12),
            ),
          ),
          const Text('11:30', style: TextStyle(fontSize: 10))
        ],
      ),
    );
  }
}