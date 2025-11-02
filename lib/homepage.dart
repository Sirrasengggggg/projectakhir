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
import 'package:geolocator/geolocator.dart';

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

  DateTime flashSaleStart = DateTime(2025, 11, 2, 19, 0, 0);
  DateTime flashSaleEnd = DateTime(2025, 11, 2, 21, 0, 0);
  late Timer _timer;
  Duration _remaining = Duration.zero;

  String zonaTerpilih = 'WIB';
  final Map<String, Duration> offsetZona = {
    'WIB': const Duration(hours: 0),
    'WITA': const Duration(hours: 1),
    'WIT': const Duration(hours: 2),
    'London': const Duration(hours: -7),
  };

  double? jarakUser;
  bool _isLoadingLokasi = false;

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateCountdown(),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _tanyaIzinLokasi());
  }

  void _updateCountdown() {
    final now = DateTime.now();
    setState(() {
      _remaining = now.isBefore(flashSaleEnd)
          ? flashSaleEnd.difference(now)
          : Duration.zero;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatCountdown(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  String _formatWaktu(DateTime waktu, String zona) {
    final konversi = waktu.add(offsetZona[zona]!);
    return DateFormat('HH:mm').format(konversi);
  }

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

  Future<void> _tanyaIzinLokasi() async {
    await Future.delayed(const Duration(seconds: 1));
    final izin = await Geolocator.checkPermission();
    if (izin == LocationPermission.denied ||
        izin == LocationPermission.deniedForever) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Izin Lokasi Diperlukan'),
            content: const Text(
              'Aplikasi memerlukan akses lokasi untuk menampilkan jarak ke toko DigiSentral.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Nanti'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _getUserLocation();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text('Izinkan'),
              ),
            ],
          ),
        );
      }
    } else {
      _getUserLocation();
    }
  }

  Future<void> _getUserLocation() async {
    setState(() => _isLoadingLokasi = true);
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoadingLokasi = false);
      return;
    }

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() => _isLoadingLokasi = false);
      return;
    }

    final posisi = await Geolocator.getCurrentPosition();
    final jarak = Geolocator.distanceBetween(
      posisi.latitude,
      posisi.longitude,
      tokoLat,
      tokoLng,
    );

    setState(() {
      jarakUser = jarak / 1000;
      _isLoadingLokasi = false;
    });
  }

  Future<void> _bukaGoogleMaps() async {
    final Uri googleUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$tokoLat,$tokoLng',
    );
    if (await canLaunchUrl(googleUrl)) {
      await launchUrl(googleUrl, mode: LaunchMode.externalApplication);
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
      backgroundColor: Colors.white,
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
        selectedItemColor: Colors.white,
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
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selamat Datang di DigiSentral,',
                  style: TextStyle(fontSize: 15, color: Colors.black54),
                ),
                const SizedBox(height: 5),
                Text(
                  widget.username,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Flash Sale Spesial DigiSentral',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Mulai pada (zona default: WIB):',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 5),
                Text('WIB (Jakarta): ${_formatWaktu(flashSaleStart, 'WIB')}'),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(
                      'Lihat waktu dalam zona: ',
                      style: TextStyle(fontSize: 15),
                    ),
                    DropdownButton<String>(
                      value: zonaTerpilih,
                      items: offsetZona.keys.map((zona) {
                        return DropdownMenuItem(value: zona, child: Text(zona));
                      }).toList(),
                      onChanged: (value) {
                        setState(() => zonaTerpilih = value!);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Waktu di $zonaTerpilih: ${_formatWaktu(flashSaleStart, zonaTerpilih)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _remaining.inSeconds > 0
                      ? 'Waktu tersisa: ${_formatCountdown(_remaining)}'
                      : 'Flash Sale telah berakhir',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _remaining.inSeconds > 0
                        ? Colors.black
                        : Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: _remaining.inSeconds > 0
                        ? () => setState(() => _selectedIndex = 1)
                        : null,
                    icon: const Icon(Icons.shopping_bag),
                    label: const Text('Ikuti Sekarang'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
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
              ],
            ),
          ),
          const SizedBox(height: 30),
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
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(tokoLat, tokoLng),
                initialZoom: 16,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
          const SizedBox(height: 10),
          if (_isLoadingLokasi)
            const Center(child: CircularProgressIndicator())
          else if (jarakUser != null)
            Text(
              'Jarak Anda ke toko: ${jarakUser!.toStringAsFixed(2)} km',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            )
          else
            const Text(
              'Lokasi belum diizinkan',
              style: TextStyle(color: Colors.grey),
            ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton.icon(
              onPressed: _bukaGoogleMaps,
              icon: const Icon(Icons.map_outlined),
              label: const Text('Buka di Google Maps'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
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
          const Text(
            'Jam Operasional',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Buka: Senin - Sabtu\nJam: 09.00 - 22.00 WIB\nTutup: Minggu',
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
