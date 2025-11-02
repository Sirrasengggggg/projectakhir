import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  Box? riwayatBox;

  @override
  void initState() {
    super.initState();
    _loadBox();
  }

  
  Future<void> _loadBox() async {
    if (!Hive.isBoxOpen('riwayat')) {
      await Hive.openBox('riwayat');
    }
    setState(() {
      riwayatBox = Hive.box('riwayat');
    });
  }

 
  Future<void> _clearUserHistory(String email) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Semua Riwayat?'),
        content: const Text(
          'Apakah kamu yakin ingin menghapus semua riwayat pembelian kamu?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await riwayatBox!.put(email, []);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua riwayat kamu sudah dihapus.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (riwayatBox == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    
    final session = Hive.box('session');
    final email = session.get('email');

   
    final data = riwayatBox!.get(email, defaultValue: []);
    List<Map<String, dynamic>> userHistory = [];

    if (data is List) {
      userHistory = data.map((e) => Map<String, dynamic>.from(e)).toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Riwayat Pembelian',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (userHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.white),
              tooltip: 'Hapus Semua Riwayat',
              onPressed: () => _clearUserHistory(email),
            ),
        ],
      ),
      body: userHistory.isEmpty
          ? const Center(
              child: Text(
                'Belum ada riwayat pembelian.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userHistory.length,
              itemBuilder: (context, index) {
                final item = userHistory.reversed.toList()[index];
                final total = item['total'] ?? 0;
                final metode = item['method'] ?? '-';
                final tanggal = item['tanggal'] ?? '-';
                final currency = item['mataUang'] ?? 'IDR';
                final symbol = item['symbol'] ?? 'Rp';
                final converted = item['totalConverted'] ?? 0.0;

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(
                      Icons.receipt_long,
                      color: Colors.blueAccent,
                    ),
                    title: Text(
                      'Total: Rp ${NumberFormat('#,###').format(total)}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Metode: $metode\nTanggal: $tanggal'
                      '${currency != 'IDR' ? '\n$symbol ${converted.toStringAsFixed(2)} ($currency)' : ''}',
                    ),
                  ),
                );
              },
            ),
    );
  }
}
