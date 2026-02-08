import 'package:flutter/material.dart';
import '/widgets/custom_bottom_nav.dart';
import 'siswa_dashboard_tab.dart';
// import 'siswa_history_tab.dart';
// import 'siswa_profile_tab.dart';

class SiswaMainPage extends StatefulWidget {
  const SiswaMainPage({super.key});

  @override
  State<SiswaMainPage> createState() => _SiswaMainPageState();
}

class _SiswaMainPageState extends State<SiswaMainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const SiswaDashboardTab(),
    const Center(child: Text("Halaman Riwayat Pesanan (Biru)")),
    const Center(child: Text("Halaman Profil Siswa (Biru)")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _currentIndex,
        isStan: false, // Penting: Agar warna tema jadi biru & icon sesuai siswa
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}