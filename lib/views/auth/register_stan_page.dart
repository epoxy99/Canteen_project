import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/auth_provider.dart';

class RegisterStanPage extends StatefulWidget {
  const RegisterStanPage({super.key});

  @override
  State<RegisterStanPage> createState() => _RegisterStanPageState();
}

class _RegisterStanPageState extends State<RegisterStanPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  
  // Controllers
  final _namaStanController = TextEditingController();
  final _namaPemilikController = TextEditingController();
  final _telpController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      bool success = await authProvider.registerStan(
        _namaStanController.text,
        _namaPemilikController.text,
        _telpController.text,
        _usernameController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        _showSnackBar("Registrasi Stan Berhasil! Silakan Login.", isError: false);
        Navigator.pop(context);
      } else {
        _showSnackBar(authProvider.errorMessage ?? "Gagal Daftar", isError: true);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.indigo,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Kemitraan Stan",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.indigo[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.storefront_rounded, size: 60, color: Colors.indigo[900]),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Daftarkan Bisnis Anda",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "Lengkapi data di bawah untuk mulai berjualan.",
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 32),

              _buildLabel("Informasi Bisnis"),
              _buildInputField(
                controller: _namaStanController,
                label: "Nama Stan",
                hint: "Contoh: Stan Sejahtera",
                icon: Icons.store_mall_directory_outlined,
              ),
              _buildInputField(
                controller: _namaPemilikController,
                label: "Nama Lengkap Pemilik",
                icon: Icons.badge_outlined,
              ),
              _buildInputField(
                controller: _telpController,
                label: "No. Telepon / WhatsApp",
                icon: Icons.phone_callback_rounded,
                keyboard: TextInputType.phone,
              ),

              const SizedBox(height: 20),
              _buildLabel("Keamanan Akun"),
              _buildInputField(
                controller: _usernameController,
                label: "Username",
                icon: Icons.account_circle_outlined,
              ),
              _buildInputField(
                controller: _passwordController,
                label: "Password",
                icon: Icons.lock_outline_rounded,
                isPassword: true,
              ),

              const SizedBox(height: 40),
              _buildSubmitButton(isLoading),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.indigo[900],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    bool isPassword = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword ? _obscurePassword : false,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.indigo[300]),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                )
              : null,
          filled: true,
          fillColor: Colors.indigo.withOpacity(0.03),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.indigo[900]!, width: 2),
          ),
        ),
        validator: (val) => val!.isEmpty ? 'Field ini tidak boleh kosong' : null,
      ),
    );
  }

  Widget _buildSubmitButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isLoading ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.indigo[900],
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 4,
          shadowColor: Colors.indigo.withOpacity(0.4),
        ),
        child: isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "DAFTARKAN STAN SAYA",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}