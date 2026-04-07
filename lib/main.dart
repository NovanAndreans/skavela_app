// main.dart
// Starter modern Flutter Desktop UI for School Admin App

import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'Pages/Dashboard.dart';
import 'Pages/DeskCard.dart';
import 'Pages/ExamCard.dart';
import 'Pages/MajorSettingPage.dart';
import 'Pages/StudentPage.dart';

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
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const MainLayout(),
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
  bool isCollapsed = false;

  final pages = const [
    DashboardPage(),
    StudentPage(),
    MajorSettingPage(),
    ExamCardPage(),
    DeskCardPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: NavigationRail(
              extended: isCollapsed,
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              leading: IconButton(
                icon: Icon(
                  isCollapsed
                      ? Icons.keyboard_double_arrow_right
                      : Icons.keyboard_double_arrow_left,
                ),
                onPressed: () {
                  setState(() {
                    isCollapsed = !isCollapsed;
                  });
                },
              ),
              labelType: isCollapsed
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(Icons.dashboard),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: Text('Siswa'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.palette_outlined),
                  selectedIcon: Icon(Icons.palette),
                  label: Text('Warna Jurusan'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.picture_as_pdf_outlined),
                  selectedIcon: Icon(Icons.picture_as_pdf),
                  label: Text('Kartu Ujian'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.table_restaurant_outlined),
                  selectedIcon: Icon(Icons.table_restaurant),
                  label: Text('Kartu Meja'),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(child: pages[selectedIndex]),
        ],
      ),
    );
  }
}
