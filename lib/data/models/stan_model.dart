class Stan {
  final int id;
  final String namaStan;
  final String namaPemilik;
  final String telp;

  Stan({
    required this.id,
    required this.namaStan,
    required this.namaPemilik,
    required this.telp,
  });

  factory Stan.fromJson(Map<String, dynamic> json) {
    return Stan(
      // API UKK biasanya menggunakan 'id_stan' atau 'id_user'
      // Kita cek semua kemungkinan agar tidak 0
      id: json['id'] ?? 0,
      
      // Pastikan nama key sesuai dengan database (biasanya pakai underscore)
      namaStan: json['nama_stan'] ?? json['nama'] ?? '', 
      namaPemilik: json['nama_pemilik'] ?? json['pemilik'] ?? '', 
      telp: json['telp'] ?? json['telepon'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_stan': namaStan,
      'nama_pemilik': namaPemilik,
      'telp': telp,
    };
  }
}