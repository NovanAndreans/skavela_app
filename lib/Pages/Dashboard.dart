import 'package:flutter/material.dart';
import '../Widgets/StatCard.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: const [
                StatCard(title: 'Total Siswa', value: '0'),
                StatCard(title: 'Total Kelas', value: '0'),
                StatCard(title: 'Status', value: 'Offline'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
