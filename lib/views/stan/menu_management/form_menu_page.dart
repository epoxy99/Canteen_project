import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:canteen_project/core/services/menu_service.dart';
import 'package:canteen_project/data/models/menu_model.dart';

class FormMenuPage extends StatefulWidget {
  final Menu? menu;

  const FormMenuPage({super.key, this.menu});

  @override
  State<FormMenuPage> createState() => _FormMenuPageState();
}

class _FormMenuPageState extends State<FormMenuPage> {
  final _formKey = GlobalKey<FormState>();
  final _menuService = MenuService();
  
  late TextEditingController _namaController;
  late TextEditingController _hargaController;
  late TextEditingController _deskripsiController;
  String _jenisTerpilih = 'makanan';
  
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.menu?.namaMakanan ?? '');
    _hargaController = TextEditingController(text: widget.menu?.harga.toString() ?? '');
    _deskripsiController = TextEditingController(text: widget.menu?.deskripsi ?? '');
    _jenisTerpilih = widget.menu?.jenis ?? 'makanan';
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
    }
  }

  Future<void> _saveMenu() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.menu == null && _imageFile == null) {
      _showError("Pilih foto menu terlebih dahulu!");
      return;
    }

    setState(() => _isSubmitting = true);

    bool success;
    if (widget.menu == null) {
      success = await _menuService.addMenu(
        _namaController.text, _hargaController.text, _jenisTerpilih, _deskripsiController.text, _imageFile!,
      );
    } else {
      success = await _menuService.updateMenu(
        widget.menu!.id, _namaController.text, _hargaController.text, _jenisTerpilih, _deskripsiController.text, _imageFile,
      );
    }

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      Navigator.pop(context, true);
    } else {
      _showError("Gagal menyimpan data ke server");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    bool isEdit = widget.menu != null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(isEdit ? "Edit Menu" : "Menu Baru", 
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(isEdit),
              const SizedBox(height: 25),
              
              _buildSectionTitle("Detail Produk"),
              _buildCard([
                _buildTextField(_namaController, "Nama Menu", Icons.fastfood_outlined),
                const Divider(),
                _buildTextField(_hargaController, "Harga Jual", Icons.payments_outlined, 
                  prefix: "Rp ", inputType: TextInputType.number),
              ]),

              const SizedBox(height: 20),
              _buildSectionTitle("Kategori & Deskripsi"),
              _buildCard([
                _buildDropdown(),
                const Divider(),
                _buildTextField(_deskripsiController, "Deskripsi Singkat", Icons.notes_rounded, maxLines: 3),
              ]),

              const SizedBox(height: 40),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildImageSection(bool isEdit) {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Stack(
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.withOpacity(0.2)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : (isEdit 
                        ? Image.network(widget.menu!.fotoUrl, fit: BoxFit.cover)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_a_photo_rounded, size: 50, color: Colors.orange[300]),
                              const SizedBox(height: 8),
                              Text("Tambah Foto Menu", style: TextStyle(color: Colors.orange[800], fontWeight: FontWeight.w500)),
                            ],
                          )),
              ),
            ),
            if (_imageFile != null || isEdit)
              PositionAt(
                right: 12, bottom: 12,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                  child: const Icon(Icons.edit, color: Colors.white, size: 20),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, 
      {String? prefix, TextInputType inputType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixText: prefix,
        prefixIcon: Icon(icon, color: Colors.orange[400]),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        labelStyle: TextStyle(color: Colors.grey[400]),
      ),
      validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _jenisTerpilih,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.category_outlined, color: Colors.orange[400]),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      items: ['makanan', 'minuman'].map((v) => DropdownMenuItem(value: v, child: Text(v.toUpperCase()))).toList(),
      onChanged: (val) => setState(() => _jenisTerpilih = val!),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _saveMenu,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange[800],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          shadowColor: Colors.orange.withOpacity(0.5),
        ),
        child: _isSubmitting 
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text("SIMPAN PERUBAHAN", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}

// Widget pembantu untuk posisi icon edit
class PositionAt extends StatelessWidget {
  final double? right, bottom;
  final Widget child;
  const PositionAt({super.key, this.right, this.bottom, required this.child});
  @override Widget build(BuildContext context) => Positioned(right: right, bottom: bottom, child: child);
}