/*
import 'package:canteen_project/core/services/stan_service.dart';
import 'package:canteen_project/data/models/stan_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'login_page.dart'; // Ganti dengan import halaman loginmu

class ProfileStanPage extends StatefulWidget {
  const ProfileStanPage({super.key});

  @override
  State<ProfileStanPage> createState() => _ProfileStanPageState();
}

class _ProfileStanPageState extends State<ProfileStanPage> {
  final StanService _stanService = StanService();
  final _formKey = GlobalKey<FormState>();

  // 1. Siapkan Controller untuk 3 Inputan
  final TextEditingController _namaStanController = TextEditingController();
  final TextEditingController _namaPemilikController = TextEditingController();
  final TextEditingController _telpController = TextEditingController();

  Stan? _stanData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStanData();
  }

  // 2. Ambil Data dari Server & Masukkan ke Input
  Future<void> _loadStanData() async {
    final stan = await _stanService.getStanProfile();
    
    if (stan != null) {
      setState(() {
        _stanData = stan;
        // Isi text field dengan data dari database
        _namaStanController.text = stan.namaStan;
        _namaPemilikController.text = stan.namaPemilik;
        _telpController.text = stan.telp;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  // 3. Kirim Perubahan ke Server
  Future<void> _updateStan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final success = await _stanService.updateStanProfile(
      _namaStanController.text,
      _namaPemilikController.text, // Field baru
      _telpController.text,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data Stan Berhasil Disimpan!"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal menyimpan. Cek koneksi internet."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => LoginPage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Profil Stan"),
        backgroundColor: Colors.orange, // Warna khas Stan/Makanan
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _stanData == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Gagal memuat data stan."),
                      ElevatedButton(
                        onPressed: _loadStanData, 
                        child: const Text("Coba Lagi")
                      )
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- HEADER GAMBAR ---
                        Center(
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.orangeAccent,
                                child: Icon(Icons.storefront, size: 50, color: Colors.white),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "ID Stan: ${_stanData!.id}",
                                style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // --- INPUT 1: NAMA STAN ---
                        const Text("Informasi Stan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 10),
                        TextFormField(
                          controller: _namaStanController,
                          decoration: const InputDecoration(
                            labelText: "Nama Stan",
                            hintText: "Contoh: Stan Bu Jum",
                            prefixIcon: Icon(Icons.store),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value!.isEmpty ? "Nama Stan tidak boleh kosong" : null,
                        ),
                        const SizedBox(height: 20),

                        // --- INPUT 2: NAMA PEMILIK ---
                        TextFormField(
                          controller: _namaPemilikController,
                          decoration: const InputDecoration(
                            labelText: "Nama Pemilik",
                            hintText: "Nama lengkap pemilik",
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value!.isEmpty ? "Nama Pemilik tidak boleh kosong" : null,
                        ),
                        const SizedBox(height: 20),

                        // --- INPUT 3: NO TELEPON ---
                        TextFormField(
                          controller: _telpController,
                          decoration: const InputDecoration(
                            labelText: "Nomor Telepon / WA",
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) => value!.isEmpty ? "Nomor telepon wajib diisi" : null,
                        ),
                        const SizedBox(height: 40),

                        // --- TOMBOL SIMPAN ---
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _updateStan,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              "SIMPAN PERUBAHAN",
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // --- TOMBOL LOGOUT ---
                        Center(
                          child: TextButton.icon(
                            onPressed: _logout,
                            icon: const Icon(Icons.logout, color: Colors.red),
                            label: const Text("Keluar Aplikasi", style: TextStyle(color: Colors.red)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
*/