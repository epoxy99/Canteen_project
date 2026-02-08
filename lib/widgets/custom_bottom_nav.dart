import 'package:flutter/material.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final bool isStan; // Parameter penentu role

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.isStan = false, // Default ke siswa jika tidak diisi
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: isStan ? Colors.orange : Colors.blue, // Stan Oranye, Siswa Biru
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        // LOGIKA PEMILIHAN MENU DI SINI
        items: isStan ? _adminItems : _siswaItems,
      ),
    );
  }

  // --- MENU UNTUK ADMIN STAN ---
  // 1. Dashboard, 2. Profil Stan
  List<BottomNavigationBarItem> get _adminItems => const [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard_outlined),
      activeIcon: Icon(Icons.dashboard),
      label: "Beranda",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.store_outlined),
      activeIcon: Icon(Icons.store),
      label: "Profil Stan",
    ),
  ];

  // --- MENU UNTUK SISWA ---
  // 1. Menu Makanan, 2. Histori Pesanan, 3. Profil Siswa
  List<BottomNavigationBarItem> get _siswaItems => const [
    BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_menu),
      activeIcon: Icon(Icons.restaurant),
      label: "Menu",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history),
      activeIcon: Icon(Icons.history_edu), // Icon history lebih jelas
      label: "Pesanan",
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: "Profil",
    ),
  ];
}