import 'package:flutter/material.dart';

class PesanKesanPage extends StatelessWidget {
  const PesanKesanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Kesan dan Saran',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Icon(Icons.school, size: 80, color: Colors.blueAccent),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Kesan & Saran terhadap Mata Kuliah\nPemrograman Aplikasi Mobile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Kesan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Mata kuliah ini memberikan banyak ilmu tentang Flutter dan pengembangan aplikasi mobile modern. '
              'Dosen mengajarkan dengan cara yang mudah dipahami dan aplikatif.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Saran:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Menyenangkan dan penuh tantangan! Saya jadi lebih semangat untuk membuat aplikasi mobile sendiri '
              'dan memahami proses pengembangan dari UI hingga backend.',
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
