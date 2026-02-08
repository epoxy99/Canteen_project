import 'package:canteen_project/core/services/menu_service.dart';
import 'package:canteen_project/data/models/menu_model.dart';
import 'package:canteen_project/views/stan/menu_management/form_menu_page.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final MenuService _menuService = MenuService();
  List<Menu> _menus = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final data = await _menuService.getMenus();
      setState(() {
        _menus = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar("Gagal memuat data: $e", isError: true);
    }
  }

  Future<void> _confirmDelete(Menu menu) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Hapus Menu?"),
        content: Text("Apakah Anda yakin ingin menghapus '${menu.namaMakanan}'? Tindakan ini tidak bisa dibatalkan."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("BATAL")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("HAPUS", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _deleteMenu(menu.id);
    }
  }

  Future<void> _deleteMenu(int id) async {
    final success = await _menuService.deleteMenu(id);
    if (success) {
      _showSnackBar("Menu berhasil dihapus");
      _loadData();
    } else {
      _showSnackBar("Gagal menghapus menu", isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Manajemen Menu", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh_rounded, color: Colors.orange),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.orange))
          : RefreshIndicator(
              onRefresh: _loadData,
              color: Colors.orange,
              child: _menus.isEmpty ? _buildEmptyState() : _buildList(),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final refresh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormMenuPage()),
          );
          if (refresh == true) _loadData();
        },
        backgroundColor: Colors.orange[800],
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Menu Baru", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      itemCount: _menus.length,
      itemBuilder: (context, index) {
        final menu = _menus[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Gambar Menu
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    menu.fotoUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.orange[50],
                      child: const Icon(Icons.fastfood, color: Colors.orange),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Informasi Menu
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          _buildTypeBadge(menu.jenis),
                          const SizedBox(width: 8),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        menu.namaMakanan,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rp ${menu.harga}",
                        style: TextStyle(
                          color: Colors.orange[900],
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                // Tombol Aksi
                Column(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                      onPressed: () async {
                        final refresh = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FormMenuPage(menu: menu)),
                        );
                        if (refresh == true) _loadData();
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
                      onPressed: () => _confirmDelete(menu),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypeBadge(String type) {
    bool isFood = type.toLowerCase() == 'makanan';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isFood ? Colors.green[50] : Colors.blue[50],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: isFood ? Colors.green[700] : Colors.blue[700],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Belum ada menu di daftar Anda",
            style: TextStyle(color: Colors.grey[600], fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            "Ketuk 'Menu Baru' untuk memulai jualan.",
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
        ],
      ),
    );
  }
}