import 'package:flutter/material.dart';
import 'package:projectakhir/profile.dart';
import 'produk.dart'; // <-- SAYA TAMBAHKAN IMPORT INI

// Mengubah StatelessWidget menjadi StatefulWidget karena perlu menyimpan state halaman aktif
class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Index untuk melacak halaman yang aktif
  int _selectedIndex = 0;

  // Fungsi yang dipanggil saat item bottom nav ditekan
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DigiSentral', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      // Body menggunakan widget yang berbeda berdasarkan index yang dipilih
      body: _buildBody(),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        // Properti untuk mengatur tampilan bottom nav
        type: BottomNavigationBarType.fixed, // Agar semua item terlihat
        backgroundColor: Colors.black, // Warna latar
        selectedItemColor: Colors.blue, // Warna item yang dipilih
        unselectedItemColor: Colors.grey, // Warna item yang tidak dipilih
        // Index halaman yang sedang aktif
        currentIndex: _selectedIndex,

        // Fungsi yang dipanggil saat item ditekan
        onTap: _onItemTapped,

        // Daftar item dalam bottom navigation
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Produk'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Keranjang',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  // Fungsi untuk membangun konten body berdasarkan index yang dipilih
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent(); // Tampilan Beranda
      case 1:
        return _buildProductContent(); // Tampilan Produk
      case 2:
        return _buildCartContent(); // Tampilan Keranjang
      case 3:
        return _buildProfileContent(); // Tampilan Profil
      default:
        return _buildHomeContent();
    }
  }

  // Widget untuk tampilan Beranda
  Widget _buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kartu selamat datang
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Icon(Icons.person, color: Colors.blue),
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Selamat datang,', style: TextStyle(fontSize: 16)),
                      Text(
                        widget.username, // Mengakses username dari widget
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Tambahkan konten beranda lainnya di sini
        ],
      ),
    );
  }

  // Widget untuk tampilan Produk
  Widget _buildProductContent() {
    //
    // <-- DI SINI SAMBUNGANNYA
    //
    return ProdukPage(); // Mengembalikan widget Halaman Produk Anda
  }

  // Widget untuk tampilan Keranjang
  Widget _buildCartContent() {
    return Center(child: Text('Halaman Keranjang'));
  }

  // Widget untuk tampilan Profil
  Widget _buildProfileContent() {
    return ProfilePage();
  }
}
