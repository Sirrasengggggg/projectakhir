import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import package http
import 'dart:convert'; // Import untuk json.decode
import 'Model_Komputer.dart'; // <-- PERBAIKAN: Nama file disesuaikan

class ProdukPage extends StatefulWidget {
  const ProdukPage({super.key});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  late Future<List<Computer>> _computersFuture;
  // PASTIKAN URL API INI BENAR
  final String _apiUrl = "https://computers-shop.vercel.app/computers";

  @override
  void initState() {
    super.initState();
    _computersFuture = _fetchComputers();
  }

  Future<List<Computer>> _fetchComputers() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl));

      if (response.statusCode == 200) {
        // Menggunakan fungsi computerFromJson dari model Anda
        return computerFromJson(response.body);
      } else {
        throw Exception(
          'Gagal memuat data komputer. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // Tambahkan penanganan error yang lebih spesifik
      debugPrint('Error fetching computers: $e');
      throw Exception('Gagal terhubung ke server: $e');
    }
  }

  // Fungsi untuk format harga
  String _formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman Produk')),
      body: FutureBuilder<List<Computer>>(
        future: _computersFuture,
        builder: (context, snapshot) {
          // Saat loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Jika ada error
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          // Jika data sukses didapat
          else if (snapshot.hasData) {
            final computers = snapshot.data!;
            // Jika tidak ada data
            if (computers.isEmpty) {
              return const Center(child: Text('Tidak ada produk.'));
            }

            // Tampilkan list data
            return ListView.builder(
              padding: const EdgeInsets.all(8.0), // Beri padding pada list
              itemCount: computers.length,
              itemBuilder: (context, index) {
                final computer = computers[index];
                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 12.0,
                  ), // Beri jarak antar card
                  clipBehavior: Clip.antiAlias, // Untuk memotong gambar
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Tampilkan Gambar
                      Image.network(
                        computer.imageUrl,
                        height: 160, // Beri ketinggian tetap
                        fit: BoxFit.cover, // Agar gambar pas
                        // Tampilkan loading saat gambar dimuat
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 160,
                            color: Colors.grey[200],
                            child: Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          );
                        },
                        // Tampilkan icon error jika gambar gagal dimuat
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 160,
                            color: Colors.grey[100],
                            child: Icon(
                              Icons.broken_image_outlined,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                          );
                        },
                      ),
                      // Tampilkan Detail Teks
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              computer.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            //
                            // DI SINI PERBAIKANNYA:
                            // Menggunakan computer.type, bukan specifications
                            //
                            Text(
                              computer.type, // Menampilkan tipe
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 8),
                            //
                            // DI SINI PERBAIKANNYA:
                            // Menggunakan computer.description
                            //
                            Text(
                              computer.description, // Menampilkan deskripsi
                              style: const TextStyle(fontSize: 14),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            // Menampilkan harga
                            Text(
                              _formatPrice(computer.price),
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          // Jika tidak ada data (snapshot.hasData == false)
          else {
            return const Center(child: Text('Tidak ada data komputer.'));
          }
        },
      ),
    );
  }
}
