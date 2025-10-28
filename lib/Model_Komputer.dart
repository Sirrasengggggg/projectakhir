import 'dart:convert';

// Fungsi untuk mengubah List<dynamic> json menjadi List<Computer>
List<Computer> computerFromJson(String str) =>
    List<Computer>.from(json.decode(str).map((x) => Computer.fromJson(x)));

class Computer {
  final String id;
  final String name;
  final int price;
  final String imageUrl;
  final String type;
  final String description;

  Computer({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.type,
    required this.description,
  });

  // Factory constructor untuk membuat instance Computer dari JSON map
  factory Computer.fromJson(Map<String, dynamic> json) {
    //
    // KODE YANG SESUAI DENGAN JSON ANDA ('nama', 'harga', 'gambar')
    //

    // Konversi harga dari String ke int.
    // Jika 'harga' null atau gagal parse, akan jadi 0.
    int parsedPrice = 0;
    if (json['harga'] != null) {
      // Menghilangkan 'Rp' atau '.' jika ada, sebelum parsing
      String priceString = json['harga'].toString().replaceAll(
        RegExp(r'[Rp.]'),
        '',
      );
      parsedPrice = int.tryParse(priceString) ?? 0;
    }

    return Computer(
      id: json['id'] ?? '',
      name: json['nama'] ?? 'Nama Tidak Tersedia',
      price: parsedPrice, // Menggunakan harga yang sudah diparse
      imageUrl: json['gambar'] ?? '', // URL gambar
      type: json['tipe'] ?? 'Tipe Tidak Tersedia',
      description: json['deskripsi'] ?? 'Deskripsi Tidak Tersedia',
    );
  }
}
