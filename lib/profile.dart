import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'loginpage.dart';
import 'riwayat_page.dart';
import 'developer.dart';
import 'pesan_kesan.dart';
import 'controller.dart'; // 

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';
  String email = '';
  String? photoPath;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final session = Hive.box('session');
    final users = Hive.box('users');

    setState(() {
      email = session.get('email', defaultValue: '') as String;
      username = session.get('username', defaultValue: 'Pengguna') as String;
      final userData = users.get(email) as Map?;
      photoPath = userData?['photoPath'];
    });
  }

  Future<void> _pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final users = Hive.box('users');
    final userData = Map<String, dynamic>.from(users.get(email));
    userData['photoPath'] = image.path;
    await users.put(email, userData);

    setState(() => photoPath = image.path);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Foto profil berhasil diperbarui!')),
    );
  }

  void _logout() async {
    final session = Hive.box('session');
    await session.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _openRiwayat() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RiwayatPage()),
    );
  }

  void _openDeveloper() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DeveloperPage()),
    );
  }

  void _openPesanKesan() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PesanKesanPage()),
    );
  }

  void _openController() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ControllerPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 55,
                backgroundColor: Colors.blueAccent,
                backgroundImage: (photoPath != null)
                    ? FileImage(File(photoPath!))
                    : null,
                child: (photoPath == null)
                    ? const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 40,
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              username,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Divider(color: Colors.grey.shade300, thickness: 1),
            const SizedBox(height: 20),

            ListTile(
              leading: const Icon(Icons.info, color: Colors.indigo),
              title: const Text('Informasi Developer'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: _openDeveloper,
            ),
            const SizedBox(height: 10),

            ListTile(
              leading: const Icon(
                Icons.feedback_outlined,
                color: Colors.orange,
              ),
              title: const Text('Pesan dan Kesan'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: _openPesanKesan,
            ),
            const SizedBox(height: 10),

            
            ListTile(
              leading: const Icon(
                Icons.notifications_active,
                color: Colors.purple,
              ),
              title: const Text('Controller Notifikasi'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: _openController,
            ),
            const SizedBox(height: 10),

            ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.blue),
              title: const Text('Lihat Riwayat Pembelian'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: _openRiwayat,
            ),
            const SizedBox(height: 10),

            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
