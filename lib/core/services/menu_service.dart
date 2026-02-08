import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
import '../../data/models/menu_model.dart';
import 'package:path/path.dart' as p; 


class MenuService {
  static const String baseUrl = "https://ukk-p2.smktelkom-mlg.sch.id/api";

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return {
      'Authorization': 'Bearer $token',
      'makerID': '1', 
      'Accept': 'application/json',
    };
  }

  // 1. Ambil Semua Menu
  Future<List<Menu>> getMenus() async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/showmenu"), headers: await _getHeaders());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List list = data['data'] ?? [];
        return list.map((e) => Menu.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error Get Menu: $e");
    }
    return [];
  }

  // 2. Tambah Menu
Future<bool> addMenu(String nama, String harga, String jenis, String deskripsi, File imageFile) async {
  var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/tambahmenu"));
  request.headers.addAll(await _getHeaders());
  
  request.fields.addAll({
    'nama_makanan': nama,
    'harga': harga,
    'jenis': jenis,
    'deskripsi': deskripsi,
  });

  if (imageFile.existsSync()) {
    // Karena sudah dikonversi di UI, kita cukup ambil nama aslinya
    String fileName = p.basename(imageFile.path); 
    
    // Pastikan extensi bersih (kadang ada sisa path)
    String extension = p.extension(imageFile.path).replaceAll('.', ''); 

    print("DEBUG UPLOAD: Mengirim file $fileName dengan tipe image/$extension");

    request.files.add(await http.MultipartFile.fromPath(
      'foto', 
      imageFile.path,
      filename: fileName, 
      contentType: MediaType('image', 'jpeg'), // Kita set jpeg karena hasil convert pasti jpeg
    ));
  }

  var response = await request.send();
  var resStr = await response.stream.bytesToString();
  
  print("STATUS TAMBAH: ${response.statusCode}");
  print("RESPON SERVER: $resStr");

  return response.statusCode == 200 || response.statusCode == 201;
}

  // 3. Update Menu
 Future<bool> updateMenu(int id, String nama, String harga, String jenis, String deskripsi, File? imageFile) async {
    // URL Update (biasanya POST di project UKK)
    var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/updatemenu/$id"));
    request.headers.addAll(await _getHeaders());

    // Masukkan data teks
    request.fields.addAll({
      'nama_makanan': nama,
      'harga': harga,
      'jenis': jenis,
      'deskripsi': deskripsi,
    });

    // Masukkan Gambar (HANYA JIKA user memilih foto baru)
    if (imageFile != null && imageFile.existsSync()) {
      String fileName = p.basename(imageFile.path); 
      // Karena di UI sudah kita paksa convert ke JPG, kita aman set ke 'jpeg'
      request.files.add(await http.MultipartFile.fromPath(
        'foto', 
        imageFile.path,
        filename: fileName, 
        contentType: MediaType('image', 'jpeg'), 
      ));
    }

    // Eksekusi
    var response = await request.send();
    var resStr = await response.stream.bytesToString(); // Untuk debug jika error

    print("STATUS EDIT: ${response.statusCode}");
    print("RESPON EDIT: $resStr");

    return response.statusCode == 200 || response.statusCode == 201;
  }

  // 4. Hapus Menu
 Future<bool> deleteMenu(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/hapus_menu/$id"), headers: await _getHeaders());
    
    print("STATUS HAPUS: ${response.statusCode}");
    print("RESPON SERVER: ${response.body}"); // LIHAT DI SINI SAAT ERROR
    
    return response.statusCode == 200;
  }
}