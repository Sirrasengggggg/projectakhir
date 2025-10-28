import 'package:flutter/material.dart';

// 1. Import LoginPage Anda
// Pastikan path ini benar sesuai struktur proyek Anda
import 'package:projectakhir/LoginPage.dart';

// 2. Import file baru Anda yang sudah digabung
// (Meskipun tidak dipanggil di sini, ini untuk memastikan semua terhubung)
import 'package:projectakhir/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Komputer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),

      // 3. Mulai aplikasi dari LoginPage
      // Ini adalah halaman awal aplikasi Anda
      home: LoginPage(),

      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
    );
  }
}
