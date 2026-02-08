import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import Image Picker
import 'package:provider/provider.dart';
import '../../logic/auth_provider.dart';

class RegisterSiswaPage extends StatefulWidget {
  const RegisterSiswaPage({super.key});

  @override
  State<RegisterSiswaPage> createState() => _RegisterSiswaPageState();
}

class _RegisterSiswaPageState extends State<RegisterSiswaPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _telpController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variabel untuk menampung file foto
  File? _selectedImage;

  // Fungsi ambil gambar dari galeri
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      // Validasi tambahan: Foto wajib ada atau tidak?
      // Jika wajib, buka komentar di bawah:
      /*
      if (_selectedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Mohon pilih foto profil")),
        );
        return;
      }
      */

      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      bool success = await authProvider.registerSiswa(
        _namaController.text,
        _alamatController.text,
        _telpController.text,
        _usernameController.text,
        _passwordController.text,
        _selectedImage,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registrasi Siswa Berhasil! Silakan Login.")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.errorMessage ?? "Gagal Daftar")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Siswa")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // --- Bagian Upload Foto ---
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : null,
                  child: _selectedImage == null
                      ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              const Text("Ketuk untuk upload foto", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 20),

              // --- Form Input ---
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: "Nama Lengkap", border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _alamatController,
                decoration: const InputDecoration(labelText: "Alamat", border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _telpController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "No Telepon", border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: "Username", border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 20),

              // --- Tombol Submit ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _handleRegister,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("DAFTAR SISWA"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}