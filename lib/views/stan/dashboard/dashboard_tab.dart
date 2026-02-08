import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:canteen_project/core/services/stan_service.dart';
import 'package:canteen_project/views/stan/menu_management/menu_page.dart';
import 'package:canteen_project/data/models/stan_model.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  String _namaUser = "Owner";
  final StanService _stanService = StanService();
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _getInitialData();
  }

  Future<void> _getInitialData() async {
    setState(() => _isSyncing = true);
    final prefs = await SharedPreferences.getInstance();
    
    try {
      Stan? profile = await _stanService.getStanProfile();
      if (profile != null) {
        setState(() => _namaUser = profile.namaPemilik);
        await prefs.setString('nama_pemilik', profile.namaPemilik);
      } else {
        setState(() => _namaUser = prefs.getString('nama_pemilik') ?? "Admin Stan");
      }
    } finally {
      setState(() => _isSyncing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Header Modern dengan Efek Gradasi
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.orange[800],
            actions: [
              IconButton(
                onPressed: _getInitialData,
                icon: _isSyncing 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.sync_rounded, color: Colors.white),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.orange[800]!, Colors.orange[500]!],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Selamat Datang,", style: TextStyle(color: Colors.white70, fontSize: 16)),
                      Text(
                        _namaUser,
                        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Konten Utama
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SEKSI RINGKASAN HARI INI ---
                  _buildSectionTitle("Ringkasan Hari Ini"),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatCard("Pendapatan", "Rp 0", Icons.account_balance_wallet_outlined, Colors.green),
                      const SizedBox(width: 15),
                      _buildStatCard("Pesanan Baru", "0", Icons.shopping_bag_outlined, Colors.blue),
                    ],
                  ),
                  
                  const SizedBox(height: 25),
                  
                  // --- SEKSI MENU UTAMA ---
                  _buildSectionTitle("Menu Manajemen"),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.1,
                    children: [
                      _buildActionCard(
                        "Kelola Menu", "Atur menu stan", 
                        Icons.restaurant_menu_rounded, Colors.orange, 
                        () => Navigator.push(context, MaterialPageRoute(builder: (c) => const MenuPage()))
                      ),
                      _buildActionCard(
                        "Pesanan", "Lihat antrean pelanggan", 
                        Icons.confirmation_number_outlined, Colors.blue, 
                        () => _showUnderDev(context)
                      ),
                      _buildActionCard(
                        "Pelanggan", "Data siswa pelanggan", 
                        Icons.groups_2_outlined, Colors.purple, 
                        () => _showUnderDev(context)
                      ),
                      _buildActionCard(
                        "Laporan", "Rekap hasil bulanan", 
                        Icons.analytics_outlined, Colors.teal, 
                        () => _showUnderDev(context)
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87));
  }

  // Widget untuk Kartu Statistik (Atas)
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // Widget untuk Kartu Menu (Bawah)
  Widget _buildActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(height: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 4),
              Text(subtitle, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
            ],
          ),
        ),
      ),
    );
  }

  void _showUnderDev(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fitur ini sedang tahap pengembangan"), behavior: SnackBarBehavior.floating),
    );
  }
}