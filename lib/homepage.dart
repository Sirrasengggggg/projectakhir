// lib/homepage.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'produk.dart';
import 'cart.dart';
import 'profile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'loginpage.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final String username;
  const HomePage({super.key, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Map<String, dynamic>> _cartItems = [];

  static const double tokoLat = -7.766287535772006;
  static const double tokoLng = 110.42621336745788;

  // 🔥 FLASH SALE VARIABLES
  DateTime flashSaleStart = DateTime(2025, 11, 2, 19, 0, 0); // WIB
  DateTime flashSaleEnd = DateTime(2025, 11, 2, 21, 0, 0); // WIB
  late Timer _timer;
  Duration _remaining = Duration.zero;
  String zonaTerpilih = 'WIB';

  final Map<String, Duration> offsetZona = {
    'WIB': const Duration(hours: 0),
    'WITA': const Duration(hours: 1),
    'WIT': const Duration(hours: 2),
    'London': const Duration(hours: -7),
  };

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateCountdown(),
    );
  }

  void _updateCountdown() {
    final now = DateTime.now();
    setState(() {
      if (now.isBefore(flashSaleEnd)) {
        _remaining = flashSaleEnd.difference(now);
      } else {
        _remaining = Duration.zero;
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatWaktu(DateTime waktu, String zona) {
    final konversi = waktu.add(offsetZona[zona]!);
    return DateFormat('HH:mm').format(konversi);
  }

  String _formatCountdown(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  // 🛒 CART LOGIC
  void _onAddToCart(Map<String, dynamic> product) {
    setState(() {
      int idx = _cartItems.indexWhere((it) => it['name'] == product['name']);
      if (idx != -1) {
        _cartItems[idx]['quantity'] = (_cartItems[idx]['quantity'] as int) + 1;
      } else {
        _cartItems.add({
          'name': product['name'],
          'price': product['price'],
          'image': product['image'],
          'quantity': 1,
        });
      }
    });
  }

  void _onUpdateQuantity(String name, int delta) {
    setState(() {
      final idx = _cartItems.indexWhere((it) => it['name'] == name);
      if (idx != -1) {
        final newQty = (_cartItems[idx]['quantity'] as int) + delta;
        if (newQty <= 0) {
          _cartItems.removeAt(idx);
        } else {
          _cartItems[idx]['quantity'] = newQty;
        }
      }
    });
  }

  void _onRemove(String name) {
    setState(() {
      _cartItems.removeWhere((it) => it['name'] == name);
    });
  }

  Future<void> _logout() async {
    final session = Hive.box('session');
    await session.clear();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _bukaGoogleMaps() async {
    final Uri googleUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$tokoLat,$tokoLng',
    );

    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka Google Maps'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeContent(),
      ProdukPage(onAddToCart: _onAddToCart),
      CartPage(cartItems: _cartItems),
      const ProfilePage(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          'DigiSentral',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        onTap: (i) => setState(() => _selectedIndex = i),
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

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🧍‍♂️ Kartu sambutan
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue.shade100,
                    child: const Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selamat datang di DigiSentral,',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          widget.username,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // ⚡ FLASH SALE
          Card(
            elevation: 4,
            color: Colors.orange.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.local_fire_department,
                        color: Colors.deepOrange,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Flash Sale Spesial DigiSentral',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Mulai pada (zona default: WIB):',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '🕒 WIB (Jakarta): ${_formatWaktu(flashSaleStart, 'WIB')}',
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        'Lihat waktu dalam zona: ',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      DropdownButton<String>(
                        value: zonaTerpilih,
                        items: offsetZona.keys.map((zona) {
                          return DropdownMenuItem(
                            value: zona,
                            child: Text(zona),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => zonaTerpilih = value!);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '⏰ Waktu di $zonaTerpilih: ${_formatWaktu(flashSaleStart, zonaTerpilih)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Divider(color: Colors.orange.shade200),
                  Text(
                    _remaining.inSeconds > 0
                        ? '⏳ Waktu tersisa: ${_formatCountdown(_remaining)}'
                        : '🎉 Flash Sale telah berakhir!',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: _remaining.inSeconds > 0
                          ? () {
                              setState(() {
                                _selectedIndex =
                                    1; // 👉 langsung ke halaman Produk
                              });
                            }
                          : null,
                      icon: const Icon(Icons.shopping_bag),
                      label: const Text('Ikuti Sekarang'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Tentang DigiSentral
          Card(
            elevation: 3,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(
                        Icons.storefront,
                        color: Colors.blueAccent,
                        size: 28,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Tentang DigiSentral',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 24, thickness: 1.2, color: Colors.blueAccent),
                  Text(
                    'DigiSentral adalah toko elektronik modern yang menyediakan berbagai produk digital '
                    'dan aksesoris gadget terkini. Kami berkomitmen memberikan layanan terbaik dan '
                    'produk berkualitas tinggi untuk memenuhi kebutuhan pelanggan di era digital.',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 15.5,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Lokasi
          const Text(
            'Lokasi Toko Kami',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(tokoLat, tokoLng),
                  initialZoom: 16,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.projectakhir',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: const LatLng(tokoLat, tokoLng),
                        width: 80,
                        height: 80,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 42,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: _bukaGoogleMaps,
              icon: const Icon(Icons.map_outlined),
              label: const Text('Buka di Google Maps'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Jam operasional
          const Text(
            'Jam Operasional',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade100),
            ),
            padding: const EdgeInsets.all(16),
            child: const Text(
              '🕒 Buka: Senin - Sabtu\n'
              '⏰ Jam: 09.00 pagi - 22.00 malam\n'
              '📍 Tutup setiap hari Minggu',
              style: TextStyle(fontSize: 15, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
