// lib/profile.dart
import 'package:flutter/material.dart';
import 'riwayat_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'loginpage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> _logout(BuildContext context) async {
    final session = Hive.box('session');
    await session.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey,
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blueAccent,
              child: Icon(Icons.person, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 20),
            const Text(
              'DigiSentral Member',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Tombol riwayat pembelian
            ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.blueAccent),
              title: const Text('Riwayat Pembelian'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RiwayatPage()),
                );
              },
            ),
            const Divider(),

            // Tombol logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text('Keluar'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
    );
  }
}
