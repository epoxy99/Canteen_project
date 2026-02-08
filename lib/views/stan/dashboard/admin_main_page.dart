// File: lib/presentation/pages/admin/admin_main_page.dart

import 'package:canteen_project/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
// Import Widget yang baru dibuat

import 'dashboard_tab.dart';
import 'profile_tab.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int _currentIndex = 0;

  // Daftar halaman
  final List<Widget> _pages = [
    const DashboardTab(), // Index 0
    const ProfileTab(), // Index 1
  ];

  // Fungsi untuk mengubah halaman saat navigasi ditekan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menampilkan halaman sesuai index saat ini
      body: _pages[_currentIndex],

      // Memanggil CustomBottomNav dari folder widgets
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        isStan: true,
      ),
    );
  }
}
