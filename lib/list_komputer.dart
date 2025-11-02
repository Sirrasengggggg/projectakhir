import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model_Komputer.dart'; // pastikan file model sesuai

class ListKomputer extends StatefulWidget {
  const ListKomputer({super.key});

  @override
  State<ListKomputer> createState() => _ListKomputerState();
}

class _ListKomputerState extends State<ListKomputer> {
  late Future<List<Computer>> _computersFuture;
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
        return computerFromJson(response.body);
      } else {
        throw Exception('Gagal memuat data komputer. (${response.statusCode})');
      }
    } catch (e) {
      debugPrint('Error fetching computers: $e');
      throw Exception('Gagal terhubung ke server: $e');
    }
  }

  String _formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Produk Komputer'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Computer>>(
        future: _computersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.hasData) {
            final computers = snapshot.data!;
            if (computers.isEmpty) {
              return const Center(child: Text('Tidak ada produk komputer.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: computers.length,
              itemBuilder: (context, index) {
                final computer = computers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  clipBehavior: Clip.antiAlias,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.network(
                        computer.imageUrl,
                        height: 160,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 160,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
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
                            Text(
                              computer.type,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              computer.description,
                              style: const TextStyle(fontSize: 14),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
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
          } else {
            return const Center(child: Text('Tidak ada data.'));
          }
        },
      ),
    );
  }
}
