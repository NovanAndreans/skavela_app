import 'package:flutter/material.dart';
import 'package:skavela_app/Pages/ConfigPage.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'Pages/Dashboard.dart';
import 'Pages/DeskCard.dart';
import 'Pages/ExamCard.dart';
import 'Pages/MajorSettingPage.dart';
import 'Pages/StudentPage.dart';
import 'Pages/ActivityPage.dart';
import 'Widgets/LoadingOverlay.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const SchoolAdminApp());
}

class SchoolAdminApp extends StatelessWidget {
  const SchoolAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'School Admin',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      home: const LoadingOverlay(child: MainLayout()),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int selectedIndex = 0;
  bool isExpanded = false;

  final pages = const [
    DashboardPage(),
    StudentPage(),
    MajorSettingPage(),
    ConfigPage(),
    ExamCardPage(),
    DeskCardPage(),
    ActivityPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Row(
        children: [
          const SizedBox(width: 20),

          /// SIDEBAR FLOATING
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isExpanded ? 200 : 80,
              decoration: BoxDecoration(
                color: const Color(0xFF0E4B8A),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  /// TOGGLE BUTTON
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        isExpanded
                            ? Icons.keyboard_double_arrow_left
                            : Icons.keyboard_double_arrow_right,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// MENU
                  Expanded(
                    child: ListView(
                      children: [
                        _buildItem(Icons.dashboard, "Dashboard", 0),
                        _buildItem(Icons.people, "Siswa", 1),
                        _buildItem(Icons.palette, "Warna Jurusan", 2),
                        _buildItem(Icons.settings, "Pengaturan", 3),
                        _buildItem(Icons.picture_as_pdf, "Kartu Ujian", 4),
                        _buildItem(Icons.table_restaurant, "Kartu Meja", 5),
                        _buildItem(Icons.history, "Aktivitas", 6),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 20),

          /// CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.white,
                  child: pages[selectedIndex],
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),
        ],
      ),
    );
  }

  /// ITEM SIDEBAR
  Widget _buildItem(IconData icon, String label, int index) {
    final isSelected = selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white.withOpacity(0.15) : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: isExpanded
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              if (isExpanded) ...[
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}