class ApiConstants {
  static const String baseUrl = "https://ukk-p2.smktelkom-mlg.sch.id/api";

  // Auth Endpoints
  static const String loginSiswa = "$baseUrl/login_siswa";
  static const String loginStan = "$baseUrl/login_stan";
    // Register 
  static const String registerSiswa = "$baseUrl/register_siswa";
  static const String registerStan = "$baseUrl/register_stan";
  
  // Data
  static const String getProfile = "$baseUrl/get_profile";
  static const String getStan = "$baseUrl/get_stan"; // Untuk stan liat profilnya sendiri
  static const String getAllStan = "$baseUrl/get_all_stan"; // Untuk siswa cari stan

  // Menu stan
  static const String showMenu = "$baseUrl/showmenu";       // POST
  static const String tambahMenu = "$baseUrl/tambahmenu";   // POST
  static const String updateMenu = "$baseUrl/updatemenu";   // POST
  static const String hapusMenu = "$baseUrl/hapus_menu";    // DELETE (nanti ditambah /{id})
  static const String detailMenu = "$baseUrl/detail_menu";  // GET (nanti ditambah /{id})
}
