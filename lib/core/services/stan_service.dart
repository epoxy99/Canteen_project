import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/models/stan_model.dart';

class StanService {
  static const String baseUrl = "https://ukk-p2.smktelkom-mlg.sch.id/api";

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'makerID': '1', 
    };
  }

  // 1. GET PROFIL STAN
  Future<Stan?> getStanProfile() async {
    try {
      final url = Uri.parse("$baseUrl/get_stan");
      final headers = await _getHeaders();
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (responseData['status'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          Stan stan = Stan.fromJson(data);

          final prefs = await SharedPreferences.getInstance();
          // Simpan data untuk kebutuhan update nantinya
          await prefs.setInt('id_stan', data['id']); 
          await prefs.setInt('id_user', data['id_user']); 
          await prefs.setString('username', data['username'] ?? '');
          
          return stan;
        }
      }
    } catch (e) {
      print("Error Get Profile: $e");
    }
    return null;
  }

  // 2. UPDATE PROFIL STAN (Mendukung Username & Password Baru)
  Future<bool> updateStanProfile({
    required String namaStan,
    required String namaPemilik,
    required String telp,
    required String username, // Username baru dari input
    String? newPassword,       // Password baru (opsional)
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final int id = prefs.getInt('id_stan') ?? 0;
      final int idUser = prefs.getInt('id_user') ?? 0;
      
      // Ambil password lama sebagai cadangan jika password baru tidak diisi
      final String oldPassword = prefs.getString('password') ?? ''; 

      if (id == 0) {
        print("Update Gagal: ID Stan tidak ditemukan.");
        return false;
      }

      final url = Uri.parse("$baseUrl/update_stan/$id"); 
      final headers = await _getHeaders();

      // Susun Body
      final Map<String, String> body = {
        'nama_stan': namaStan,
        'nama_pemilik': namaPemilik,
        'telp': telp,
        'id_user': idUser.toString(),
        'username': username,
      };

      // Logika Password:
      // Jika user input password baru, gunakan itu. 
      // Jika tidak, gunakan password lama agar tidak null di database.
      if (newPassword != null && newPassword.isNotEmpty) {
        body['password'] = newPassword;
      } else if (oldPassword.isNotEmpty) {
        body['password'] = oldPassword;
      }

      print("Sending Update to: $url");
      final response = await http.post(url, headers: headers, body: body);

      print("Update Status: ${response.statusCode}");
      print("Update Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update SharedPreferences dengan data baru yang sukses
        await prefs.setString('username', username);
        if (newPassword != null && newPassword.isNotEmpty) {
          await prefs.setString('password', newPassword);
        }
        
        await getStanProfile(); 
        return true;
      }
    } catch (e) {
      print("Error Update Exception: $e");
    }
    return false;
  }

  // 3. GET ALL STANS
  Future<List<Stan>> getAllStans() async {
    try {
      final url = Uri.parse("$baseUrl/stan");
      final response = await http.get(url, headers: await _getHeaders());

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List listData = responseData['data'] ?? [];
        return listData.map((item) => Stan.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint("Error All Stans: $e");
    }
    return [];
  }
}