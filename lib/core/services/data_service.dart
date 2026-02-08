import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';
import '../../data/models/stan_model.dart';
import '../../data/models/menu_model.dart';

class DataService {
  // Helper untuk ambil token dari HP
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };
  }

  // FITUR SISWA: Mengambil semua stan
  Future<List<Stan>> getAllStan() async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse(ApiConstants.getAllStan), headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Asumsi response API berbentuk: { "data": [...] } atau langsung [...]
      // Sesuaikan parsing ini dengan postman Anda
      List<dynamic> list = data['data'] ?? data; 
      return list.map((e) => Stan.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data stan');
    }
  }

  // FITUR STAN: Mengambil profil stan (termasuk list menunya biasanya)
  // Jika API terpisah, buat fungsi getMenuByStan
  Future<List<Menu>> getMyMenus() async {
    // Implementasi tergantung endpoint API Anda untuk mengambil menu milik stan yang sedang login
    // Ini contoh dummy request
    final headers = await _getHeaders();
    // Anggap ada endpoint ini, atau endpoint get_stan mengembalikan relasi menu
    final response = await http.get(Uri.parse("${ApiConstants.baseUrl}/menu"), headers: headers); 
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> list = data['data'] ?? data;
      return list.map((e) => Menu.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat menu');
    }
  }
}