import 'package:canteen_project/views/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:canteen_project/data/models/stan_model.dart';
import 'package:canteen_project/core/services/stan_service.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final StanService _stanService = StanService();
  final _formKey = GlobalKey<FormState>();

  final _namaStanController = TextEditingController();
  final _namaPemilikController = TextEditingController();
  final _telpController = TextEditingController();
  final _usernameController = TextEditingController(); 
  final _passwordController = TextEditingController(); 

  bool _isLoading = true;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loadStanData();
  }

  // 1. Memuat Data dan mengisi SEMUA Controller (termasuk Password)
  Future<void> _loadStanData() async {
    setState(() => _isLoading = true);
    
    final profile = await _stanService.getStanProfile();
    final prefs = await SharedPreferences.getInstance();
    
    // Ambil password yang tersimpan saat login
    final savedPassword = prefs.getString('password') ?? '';
    final savedUsername = prefs.getString('username') ?? '';

    if (profile != null) {
      setState(() {
        _namaStanController.text = profile.namaStan;
        _namaPemilikController.text = profile.namaPemilik;
        _telpController.text = profile.telp;
        _usernameController.text = savedUsername;
        
        // MENAMPILKAN PASSWORD LAMA DI TEXTFIELD
        _passwordController.text = savedPassword; 
        
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal memuat data profil")),
        );
      }
    }
  }

  // 2. Fungsi Update
  Future<void> _updateStan() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);

    final success = await _stanService.updateStanProfile(
      namaStan: _namaStanController.text,
      namaPemilik: _namaPemilikController.text,
      telp: _telpController.text,
      username: _usernameController.text,
      // Karena controller sudah terisi password lama/baru, langsung kirim isinya
      newPassword: _passwordController.text, 
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil berhasil diperbarui!"), backgroundColor: Colors.green)
        );
        _loadStanData(); // Refresh data
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menyimpan data."), backgroundColor: Colors.red)
        );
      }
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan Profil", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(onPressed: _loadStanData, icon: const Icon(Icons.refresh))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : RefreshIndicator(
              onRefresh: _loadStanData,
              color: Colors.orange,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(child: _buildAvatar()),
                      const SizedBox(height: 30),
                      
                      const Text("Informasi Stan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 10),
                      _buildTextField(_namaStanController, "Nama Stan", Icons.store),
                      const SizedBox(height: 15),
                      _buildTextField(_namaPemilikController, "Nama Pemilik", Icons.person),
                      const SizedBox(height: 15),
                      _buildTextField(_telpController, "No Telepon", Icons.phone, inputType: TextInputType.phone),
                      
                      const SizedBox(height: 30),
                      const Text("Kredensial Akun", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 10),
                      _buildTextField(_usernameController, "Username", Icons.alternate_email),
                      const SizedBox(height: 15),
                      
                      _buildPasswordField(),
                      
                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _updateStan,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                          ),
                          child: const Text("SIMPAN PERUBAHAN", 
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text("Keluar Aplikasi", 
                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        onTap: _logout,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: const Icon(Icons.lock, color: Colors.orange),
        suffixIcon: IconButton(
          icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      // Validasi agar password tidak sengaja terhapus kosong
      validator: (v) => v!.isEmpty ? "Password tidak boleh kosong" : null,
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orange),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (v) => v!.isEmpty ? "$label wajib diisi" : null,
    );
  }

  Widget _buildAvatar() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.orange.withOpacity(0.3), width: 3),
      ),
      child: const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.orange,
        child: Icon(Icons.storefront, size: 50, color: Colors.white),
      ),
    );
  }
}