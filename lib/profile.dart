import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Add top spacing here
              SizedBox(height: 20), // You can adjust this value
              
              // Profile Picture
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, size: 60, color: Colors.grey[600]),
              ),
              SizedBox(height: 24),

              // Profile Details Card
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileItem(
                        icon: Icons.person,
                        title: 'Nama',
                        content: 'Oktriadi Ramadhanu',
                      ),
                      _buildDivider(),
                      _buildProfileItem(
                        icon: Icons.calendar_today,
                        title: 'Tempat, Tanggal Lahir',
                        content: 'Tanjungpinang, 28 Oktober 2005',
                      ),
                      _buildDivider(),
                      _buildProfileItem(
                        icon: Icons.school,
                        title: 'Kampus',
                        content:
                            'Universitas Pembangunan Nasional "Veteran" Yogyakarta',
                      ),
                      _buildDivider(),
                      _buildProfileItem(
                        icon: Icons.code,
                        title: 'Jurusan',
                        content: 'Sistem Informasi',
                      ),
                      _buildDivider(),
                      _buildProfileItem(
                        icon: Icons.sports_esports,
                        title: 'Hobi',
                        content: 'Gaming, Coding, Music',
                      ),
                    ],
                  ),
                ),
              ),

              // Version Info
              SizedBox(height: 24),
              Text(
                'DigiSentral v1.0.0',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(color: Colors.grey[300], thickness: 1, height: 24);
  }
}
