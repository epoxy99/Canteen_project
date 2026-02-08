class Menu {
  final int id;
  final String namaMakanan;
  final int harga;
  final String jenis;
  final String deskripsi;
  final String? foto;

  Menu({
    required this.id,
    required this.namaMakanan,
    required this.harga,
    required this.jenis,
    required this.deskripsi,
    this.foto,
  });

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      // Mencari ID di semua kemungkinan nama kolom dari server
      id: json['id_masakan'] ?? json['id_menu'] ?? json['id'] ?? 0,
      namaMakanan: json['nama_makanan'] ?? '',
      harga: int.tryParse(json['harga'].toString()) ?? 0,
      jenis: json['jenis'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      foto: json['foto'],
    );
  }

  // Sesuai saran guru: Ambil langsung dari domain/storage/
  String get fotoUrl {
    if (foto == null || foto!.isEmpty) {
      return 'https://ui-avatars.com/api/?name=$namaMakanan&background=random';
    }
    const String baseStorage = "https://ukk-p2.smktelkom-mlg.sch.id/";
    
    if (foto!.startsWith('http')) return foto!;
    return "$baseStorage/$foto";
  }
}