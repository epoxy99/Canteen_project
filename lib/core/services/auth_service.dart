import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../../data/models/auth_model.dart';

class AuthService {
  // Header wajib untuk setiap request ke backend ini
  final Map<String, String> _headers = {
    'makerID': '1', // <-- INI YANG KURANG SEBELUMNYA
    'Accept': 'application/json', // Agar backend merespon dalam format JSON
  };

  Future<AuthResponse> login({
    required String username,
    required String password,
    required bool isSiswa,
  }) async {
    final url = isSiswa ? ApiConstants.loginSiswa : ApiConstants.loginStan;
    
    print("Mencoba Login ke: $url");
    print("Headers: $_headers");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: _headers, // Sertakan header di sini
        body: {
          'username': username,
          'password': password,
        },
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AuthResponse.fromJson(data);
      } else {
        // Jika masih error, kita tangkap pesannya
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Login Gagal: ${response.statusCode}');
      }
    } catch (e) {
      print("Error Login: $e");
      rethrow;
    }
  }
  Future<bool> registerStan({
    required String namaStan,
    required String namaPemilik,
    required String telp,
    required String username,
    required String password,
  }) async {
    final url = ApiConstants.registerStan; // Pastikan ini ada di api_constants.dart
    
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: _headers,
        body: {
          'nama_stan': namaStan,
          'nama_pemilik': namaPemilik,
          'telp': telp,
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Register Gagal');
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<bool> registerSiswa({
    required String namaSiswa,
    required String alamat,
    required String telp,
    required String username,
    required String password,
    required File? imageFile, // File Foto
  }) async {
    final url = ApiConstants.registerSiswa;
    
    try {
      // Gunakan MultipartRequest karena ada upload file
      var request = http.MultipartRequest('POST', Uri.parse(url));
      
      // Tambahkan Headers
      request.headers.addAll(_headers);

      // Tambahkan Field Teks
      request.fields['nama_siswa'] = namaSiswa;
      request.fields['alamat'] = alamat;
      request.fields['telp'] = telp;
      request.fields['username'] = username;
      request.fields['password'] = password;

      // Tambahkan File Foto (Jika user memilih foto)
      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'foto', // Key ini harus sesuai dengan backend (biasanya 'foto' atau 'image')
          imageFile.path,
        ));
      }

      // Kirim Request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Status Register Siswa: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Gagal mendaftar siswa');
      }
    } catch (e) {
      print("Error Upload: $e");
      rethrow;
    }
  }
}