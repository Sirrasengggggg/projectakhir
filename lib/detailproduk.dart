import 'package:flutter/material.dart';
import 'model_Komputer.dart';

class DetailProdukPage extends StatelessWidget {
  final Computer computer;
  final void Function(Map<String, dynamic>)? onAddToCart;

  const DetailProdukPage({super.key, required this.computer, this.onAddToCart});

  String _formatPrice(int price) =>
      'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(computer.name), backgroundColor: Colors.black),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                computer.imageUrl,
                height: 220,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    const Icon(Icons.broken_image, size: 80),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              computer.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(computer.type, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 10),
            Text(
              _formatPrice(computer.price),
              style: const TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(computer.description),
            const SizedBox(height: 20),
            if (onAddToCart != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    onAddToCart!({
                      'name': computer.name,
                      'price': computer.price,
                      'image': computer.imageUrl,
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Produk ditambahkan ke keranjang'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Tambah ke Keranjang'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
