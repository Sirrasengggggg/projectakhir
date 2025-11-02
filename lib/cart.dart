import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'payment.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  const CartPage({super.key, required this.cartItems});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String selectedCurrency = 'IDR';
  double totalKonversi = 0.0;

  // ✅ Kurs statis (offline)
  final Map<String, double> rates = {
    'IDR': 1.0,
    'MYR': 3500.0,
    'EUR': 17100.0,
    'SGD': 11700.0,
  };

  // ✅ Simbol mata uang
  String _getSymbol(String code) {
    switch (code) {
      case 'MYR':
        return 'RM';
      case 'EUR':
        return '€';
      case 'SGD':
        return 'S\$';
      default:
        return 'Rp';
    }
  }

  // ✅ Format angka ke bentuk Rupiah
  String formatHarga(double harga) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(harga);
  }

  // ✅ Hitung total harga di keranjang
  double get totalHargaIDR {
    double total = 0.0;
    for (var item in widget.cartItems) {
      final double price = (item['price'] as num).toDouble();
      final int qty = item['quantity'] as int;
      total += price * qty;
    }
    return total;
  }

  // ✅ Hitung konversi otomatis
  void _hitungKonversi() {
    final rate = rates[selectedCurrency] ?? 1.0;
    setState(() {
      totalKonversi = totalHargaIDR / rate;
    });
  }

  // ✅ Tambah dan kurang produk
  void _tambahProduk(int index) {
    setState(() {
      widget.cartItems[index]['quantity'] += 1;
      _hitungKonversi();
    });
  }

  void _kurangiProduk(int index) {
    setState(() {
      if (widget.cartItems[index]['quantity'] > 1) {
        widget.cartItems[index]['quantity'] -= 1;
      } else {
        widget.cartItems.removeAt(index);
      }
      _hitungKonversi();
    });
  }

  // ✅ Validasi sebelum pindah ke pembayaran
  void _goToPaymentPage() {
    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Keranjang kamu masih kosong!'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          totalIDR: totalHargaIDR,
          totalConverted: totalKonversi,
          currency: selectedCurrency,
          symbol: _getSymbol(selectedCurrency),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _hitungKonversi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'DigiSentral',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey.shade300,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: const Text(
              'Keranjang Saya',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: widget.cartItems.isEmpty
                ? const Center(
                    child: Text(
                      'Keranjang kamu masih kosong.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      final double price = (item['price'] as num).toDouble();
                      final int qty = item['quantity'] as int;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: item['image'] != null
                                    ? Image.network(
                                        item['image'],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                                  Icons.broken_image,
                                                  size: 50,
                                                  color: Colors.grey,
                                                ),
                                      )
                                    : const Icon(
                                        Icons.image,
                                        size: 50,
                                        color: Colors.grey,
                                      ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '${formatHarga(price)} x $qty',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      formatHarga(price * qty),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _kurangiProduk(index),
                                    icon: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                  Text(
                                    '$qty',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    onPressed: () => _tambahProduk(index),
                                    icon: const Icon(
                                      Icons.add_circle,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // 🧮 Konversi & total harga
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Konversi Mata Uang:',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      DropdownButton<String>(
                        value: selectedCurrency,
                        items: rates.keys.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            selectedCurrency = newVal!;
                            _hitungKonversi();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${formatHarga(totalHargaIDR)} (IDR)',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      if (selectedCurrency != 'IDR')
                        Text(
                          '${_getSymbol(selectedCurrency)} ${totalKonversi.toStringAsFixed(2)} (${selectedCurrency})',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blueAccent,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                // ✅ Tombol lanjut ke pembayaran
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: widget.cartItems.isEmpty
                        ? null
                        : _goToPaymentPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.cartItems.isEmpty
                          ? Colors.grey
                          : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Lanjut ke Pembayaran',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
