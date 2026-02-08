import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:canteen_project/views/auth/register_siswa_page.dart';
import 'package:canteen_project/views/auth/register_stan_page.dart';
import 'package:canteen_project/views/stan/dashboard/admin_main_page.dart';
import '../../logic/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoginAsSiswa = true;
  bool _isPasswordVisible = false;

  Future<void> _handleLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    bool success = await authProvider.login(
      _usernameController.text,
      _passwordController.text,
      _isLoginAsSiswa,
    );

    if (success && mounted) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('password', _passwordController.text);
      await prefs.setString('username', _usernameController.text);

      if (_isLoginAsSiswa) {
        Navigator.pushReplacementNamed(context, '/siswa_home');
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const AdminMainPage()),
        );
      }
    } else if (mounted) {
      _showErrorSnackBar(authProvider.errorMessage ?? "Kredensial salah, silakan coba lagi.");
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon & Logo
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.restaurant_rounded, size: 60, color: Colors.orange[800]),
                ),
                const SizedBox(height: 20),
                Text(
                  "Kantin Apps",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900],
                  ),
                ),
                Text(
                  _isLoginAsSiswa 
                      ? "Makan enak, belajar pun nyaman." 
                      : "Kelola dagangan jadi lebih mudah.",
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
                const SizedBox(height: 40),

                // Role Switcher
                _buildRoleSwitcher(),
                const SizedBox(height: 30),

                // Input Username
                _buildTextField(
                  controller: _usernameController,
                  label: "Username",
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 16),

                // Input Password
                _buildTextField(
                  controller: _passwordController,
                  label: "Password",
                  icon: Icons.lock_outline_rounded,
                  isPassword: true,
                ),
                const SizedBox(height: 10),

                // Forgot Password (UI Only)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Lupa Password?", style: TextStyle(color: Colors.orange[800], fontSize: 13)),
                  ),
                ),
                const SizedBox(height: 20),

                // Login Button
                _buildLoginButton(isLoading),
                const SizedBox(height: 30),

                // Register Link
                _buildRegisterLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleSwitcher() {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _roleTab("Siswa", _isLoginAsSiswa, () => setState(() => _isLoginAsSiswa = true)),
          _roleTab("Penjual / Stan", !_isLoginAsSiswa, () => setState(() => _isLoginAsSiswa = false)),
        ],
      ),
    );
  }

  Widget _roleTab(String label, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected 
                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))]
                : [],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.orange[900] : Colors.grey[500],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !_isPasswordVisible : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.orange[400]),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              )
            : null,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.orange.shade400, width: 2),
        ),
      ),
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange[800],
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        onPressed: isLoading ? null : _handleLogin,
        child: isLoading
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text("Masuk Sekarang", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_isLoginAsSiswa ? "Belum punya akun? " : "Ingin jadi mitra? "),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _isLoginAsSiswa ? const RegisterSiswaPage() : const RegisterStanPage(),
              ),
            );
          },
          child: Text(
            "Daftar Disini",
            style: TextStyle(color: Colors.orange[900], fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}