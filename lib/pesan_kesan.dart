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
              'Secara keseluruhan, mata kuliah ini benar-benar mantap! Rasanya menantang banget, tapi juga seru. Terima kasih banyak buat teman-teman seperjuangan yang rela begadang bareng ngerjain tugas sampai pagi  entah itu pas diskusi di Discord atau nongkrong di mato.'
              'Jujur, ngerjain tugasnya beneran nguras tenaga. Kadang sampai tidur nggak nyenyak, mandi  nggak basah karena pikiran masih muter di notifikasi yang ga muncul-muncul, haha. Tapi di balik semua capek itu, rasanya puas banget.'
              'Momen paling bikin senang tuh waktu fitur yang kita bikin akhirnya bisa jalan. Perasaannya tuh kayak lihat Arsenal angkat piala UCL meskipun cuma di mimpi, tapi bahagianya sama!',

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
              'Semoga ke depannya bisa lebih baik lagi! Jangan suka nunda-nunda tugas, sekecil apa pun itu karena kalau udah numpuk, rasanya kayak debug error yang nggak kelar-kelar . '
              'Terus, semoga bisa lebih rajin explore tentang Flutter dan dependency kesayangan biar makin jago bikin aplikasi yang keren dan efisien. Pokoknya, tetap semangat belajar dan jangan takut coba hal baru!',
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
