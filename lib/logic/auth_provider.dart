import 'dart:io';
import 'package:canteen_project/core/services/stan_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/auth_service.dart';
import '../data/models/auth_model.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final StanService _stanService = StanService();
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

 Future<bool> login(String username, String password, bool isSiswa) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      AuthResponse response = await _authService.login(
        username: username,
        password: password,
        isSiswa: isSiswa,
      );

      final prefs = await SharedPreferences.getInstance();
      // Simpan data dasar
      await prefs.setString('token', response.accessToken);
      await prefs.setString('role', response.user.role);
      await prefs.setString('username', response.user.username);

      // KHUSUS STAN: Ambil profil lengkap sebelum mengakhiri loading
      if (!isSiswa && response.user.role == 'admin_stan') {
        // Kita panggil getStanProfile di sini supaya 'nama_pemilik' disimpan
        // saat token masih segar di memory
        await _stanService.getStanProfile();
      }

      _isLoading = false;
      notifyListeners();
      return true; 
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false; 
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data sesi
    notifyListeners();
  }
  Future<bool> registerStan(
      String namaStan, String namaPemilik, String telp, String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.registerStan(
        namaStan: namaStan,
        namaPemilik: namaPemilik,
        telp: telp,
        username: username,
        password: password,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
  Future<bool> registerSiswa(
      String nama, String alamat, String telp, String username, String pass, File? foto) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.registerSiswa(
        namaSiswa: nama,
        alamat: alamat,
        telp: telp,
        username: username,
        password: pass,
        imageFile: foto,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}