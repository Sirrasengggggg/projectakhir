import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'riwayat_page.dart';

class PaymentPage extends StatefulWidget {
  final double totalIDR;
  final double totalConverted;
  final String currency;
  final String symbol;

  const PaymentPage({
    super.key,
    required this.totalIDR,
    required this.totalConverted,
    required this.currency,
    required this.symbol,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedMethod;
  bool _isLoading = false;

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  Future<void> _pay() async {
    // 🔴 Cegah pembayaran tanpa barang
    if (widget.totalIDR <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak ada barang di keranjang.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // 🔴 Cegah pembayaran tanpa memilih metode
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih metode pembayaran terlebih dahulu.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    // ✅ Simpan riwayat transaksi ke Hive
    final box = await Hive.openBox('history');
    box.add({
      'total': widget.totalIDR,
      'method': _selectedMethod!,
      'tanggal': DateFormat('dd MMM yyyy, HH:mm').format(DateTime.now()),
      'mataUang': widget.currency,
      'totalConverted': widget.totalConverted,
      'symbol': widget.symbol,
    });

    // ✅ Popup sukses dan arahkan ke riwayat
    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Pembayaran Berhasil'),
            ],
          ),
          content: Text(
            'Pembayaran sebesar ${_formatPrice(widget.totalIDR)} berhasil menggunakan $_selectedMethod!',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RiwayatPage()),
                );
              },
              child: const Text('Lihat Riwayat'),
            ),
          ],
        ),
      );
    }
  }

  Widget _option(String label, IconData icon) {
    return ListTile(
      leading: Radio<String>(
        value: label,
        groupValue: _selectedMethod,
        onChanged: (v) => setState(() => _selectedMethod = v),
      ),
      title: Text(label, style: const TextStyle(fontSize: 16)),
      trailing: Icon(icon, color: Colors.blueAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canPay = widget.totalIDR > 0 && _selectedMethod != null;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Pembayaran',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // ✅ Tiga metode pembayaran
            _option('Transfer Bank', Icons.account_balance),
            _option('GoPay', Icons.qr_code_2),
            _option('DANA', Icons.account_balance_wallet_outlined),

            const Spacer(),

            // ✅ Total harga tampil di bawah
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Pembayaran:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${_formatPrice(widget.totalIDR)} (IDR)',
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  if (widget.currency != 'IDR')
                    Text(
                      '${widget.symbol} ${widget.totalConverted.toStringAsFixed(2)} (${widget.currency})',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ✅ Tombol Bayar Sekarang
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: canPay && !_isLoading ? _pay : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canPay ? Colors.black : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : const Text(
                        'Bayar Sekarang',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
