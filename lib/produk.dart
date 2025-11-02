import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model_Komputer.dart';
import 'detailproduk.dart';

class ProdukPage extends StatefulWidget {
  final void Function(Map<String, dynamic>) onAddToCart;

  const ProdukPage({super.key, required this.onAddToCart});

  @override
  State<ProdukPage> createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  late Future<List<Computer>> _computersFuture;
  List<Computer> _allComputers = [];
  List<Computer> _filteredComputers = [];
  final TextEditingController _searchController = TextEditingController();

  final String _apiUrl = "https://computers-shop.vercel.app/computers";

  @override
  void initState() {
    super.initState();
    _computersFuture = _fetchComputers();
  }

  Future<List<Computer>> _fetchComputers() async {
    final response = await http.get(Uri.parse(_apiUrl));
    if (response.statusCode == 200) {
      final list = computerFromJson(response.body);
      _allComputers = list;
      _filteredComputers = list;
      return list;
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  void _filterComputers(String query) {
    final q = query.toLowerCase();
    setState(() {
      _filteredComputers = _allComputers
          .where(
            (c) =>
                c.name.toLowerCase().contains(q) ||
                c.type.toLowerCase().contains(q),
          )
          .toList();
    });
  }

  String _formatPrice(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Halaman Produk',
          style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey,
        
      ),
      body: FutureBuilder<List<Computer>>(
        future: _computersFuture,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
          final list = snap.data ?? [];
          if (list.isEmpty) {
            return const Center(child: Text('Tidak ada produk.'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterComputers,
                  decoration: InputDecoration(
                    hintText: 'Cari komputer...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ),
              Expanded(
                child: _filteredComputers.isEmpty
                    ? const Center(child: Text('Produk tidak ditemukan.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: _filteredComputers.length,
                        itemBuilder: (context, index) {
                          final comp = _filteredComputers[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DetailProdukPage(
                                    computer: comp,
                                    onAddToCart: (map) =>
                                        widget.onAddToCart(map),
                                  ),
                                ),
                              );
                            },
                            child: Card(
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
                                    comp.imageUrl,
                                    height: 160,
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) =>
                                        const Icon(Icons.broken_image),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comp.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Text(
                                          comp.type,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                            fontStyle: FontStyle.italic,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          comp.description,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _formatPrice(comp.price),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue,
                                                fontSize: 16,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                Icons.add_shopping_cart,
                                              ),
                                              color: Colors.blue,
                                              onPressed: () {
                                                widget.onAddToCart({
                                                  'name': comp.name,
                                                  'price': comp.price,
                                                  'image': comp.imageUrl,
                                                });
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Produk ditambahkan ke keranjang',
                                                    ),
                                                    duration: Duration(
                                                      seconds: 1,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
