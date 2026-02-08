class User {
  final int id;
  final String nama;
  final String username;
  final String role; // 'stan', 'admin', atau 'siswa'
  final String? telp;

  User({
    required this.id,
    required this.nama,
    required this.username,
    required this.role,
    this.telp,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      // Menangani berbagai kemungkinan nama field dari backend
      nama: json['nama_user'] ?? json['name'] ?? json['nama'] ?? '',
      username: json['username'] ?? '',
      role: json['role'] ?? 'siswa',
      telp: json['telp'] ?? '',
    );
  }
}