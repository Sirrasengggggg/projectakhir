// File: main.dart

import 'package:flutter/material.dart';
import 'package:projectakhir/LoginPage.dart'; // Pastikan path ini benar sesuai struktur proyek Anda

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
      // Mulai aplikasi dari LoginPage
      home: LoginPage(),
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
    );
  }
}
