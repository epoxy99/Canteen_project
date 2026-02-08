import 'package:flutter/material.dart';
import '../../../data/models/stan_model.dart';
import '../../../core/services/stan_service.dart';

class SiswaDashboardTab extends StatefulWidget {
  const SiswaDashboardTab({super.key});

  @override
  State<SiswaDashboardTab> createState() => _SiswaDashboardTabState();
}

class _SiswaDashboardTabState extends State<SiswaDashboardTab> {
  final StanService _stanService = StanService();
  List<Stan> _listStan = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStans();
  }

  Future<void> _fetchStans() async {
    final data = await _stanService.getAllStans();
    setState(() {
      _listStan = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // 1. APPBAR DENGAN SEARCH
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: Colors.blue,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              title: const Text("Kantin Digital", 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              background: Container(color: Colors.blue),
            ),
          ),

          // 2. HEADER & PROMO
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                _buildPromoBanner(),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Text("Pilih Stan Kantin", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // 3. DAFTAR STAN (GRID)
          _isLoading 
            ? const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()))
            : SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 0.8,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final stan = _listStan[index];
                      return _buildStanCard(stan);
                    },
                    childCount: _listStan.length,
                  ),
                ),
              ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  // --- WIDGET SEARCH BAR ---
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Cari bakso, mie ayam, atau minuman...",
          prefixIcon: const Icon(Icons.search, color: Colors.blue),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  // --- WIDGET BANNER PROMO ---
  Widget _buildPromoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20, bottom: -20,
            child: Icon(Icons.fastfood, size: 150, color: Colors.white.withOpacity(0.2)),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Promo Makan Siang!", 
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text("Dapatkan diskon 10% di semua stan\nsetiap hari Jumat.", 
                  style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET KARTU STAN ---
  Widget _buildStanCard(Stan stan) {
    return InkWell(
      onTap: () {
        // Navigasi ke Halaman Menu Stan
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: Column(
          children: [
            // Bagian Atas (Gambar/Icon)
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: const Icon(Icons.storefront, size: 50, color: Colors.blue),
              ),
            ),
            // Bagian Bawah (Info)
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(stan.namaStan, 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text(stan.namaPemilik, 
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}