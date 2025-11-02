// lib/riwayat_page.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  late Box historyBox;

  @override
  void initState() {
    super.initState();
    historyBox = Hive.box('history');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Riwayat Pembelian',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
      ),
      body: ValueListenableBuilder(
        valueListenable: historyBox.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada riwayat pembelian.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final items = box.values.toList().reversed.toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final total = item['total'] ?? 0;
              final metode = item['method'] ?? '-';
              final tanggal = item['tanggal'] ?? '';

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
                  ),
                  subtitle: Text('Metode: $metode\nTanggal: $tanggal'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
