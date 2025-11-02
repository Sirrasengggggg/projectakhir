import 'package:flutter/material.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          'Informasi Developer',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            CircleAvatar(
              radius: 70,
              backgroundImage: const AssetImage('assets/images/dev.jpg'),
              backgroundColor: Colors.grey.shade300,
            ),
            const SizedBox(height: 25),
            const Text(
              'Oktriadi Ramadhanu',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Flutter Developer | Mahasiswa Teknik Informatika',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Divider(color: Colors.grey.shade400, thickness: 1),
            const SizedBox(height: 25),
            _infoRow(
              Icons.school_outlined,
              'Universitas: Universitas Pembangunan Nasional "Veteran" Yogyakarta',
            ),
            const SizedBox(height: 15),
            _infoRow(Icons.computer_outlined, 'Jurusan: Sistem Informasi'),
            const SizedBox(height: 15),
            _infoRow(
              Icons.email_outlined,
              'Email: oktriadiramadhanu28@gmail.com',
            ),
            const SizedBox(height: 15),
            _infoRow(
              Icons.location_on_outlined,
              'Domisili: Daerah Istimewa Yogyakarta',
            ),
            const SizedBox(height: 15),
            _infoRow(Icons.favorite_outline, 'Hobi: Musik'),
            const SizedBox(height: 35),
            Divider(color: Colors.grey.shade400),
            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '“Aplikasi ini dikembangkan sebagai bagian dari tugas mata kuliah Pemrograman Aplikasi Mobile menggunakan Flutter.”',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                  color: Colors.black54,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.black54, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
