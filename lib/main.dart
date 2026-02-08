
import 'package:canteen_project/views/stan/dashboard/dashboard_tab.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'logic/auth_provider.dart';
import 'views/auth/login_page.dart';
import 'views/siswa/dashboard/siswa_dashboard_tab.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
       
      ],
      
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kantin App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      // Halaman pertama yang dibuka
      home: const LoginPage(), 
      
      // Daftarkan rute navigasi di sini
      routes: {
        '/login': (context) => const LoginPage(),
        '/siswa_home': (context) => const SiswaDashboardTab(),
        '/stan_home': (context) => const DashboardTab(),
      },
      
    );
    
  }
}