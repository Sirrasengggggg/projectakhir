import 'dart:convert';

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

  factory Computer.fromJson(Map<String, dynamic> json) {
    int parsedPrice = 0;
    if (json['harga'] != null) {
      String priceString = json['harga'].toString().replaceAll(
        RegExp(r'[Rp.\s]'),
        '',
      );
      parsedPrice = int.tryParse(priceString) ?? 0;
    }

    return Computer(
      id: json['id']?.toString() ?? '',
      name: json['nama']?.toString() ?? 'Nama Tidak Tersedia',
      price: parsedPrice,
      imageUrl: json['gambar']?.toString() ?? '',
      type: json['tipe']?.toString() ?? 'Tipe Tidak Tersedia',
      description: json['deskripsi']?.toString() ?? 'Deskripsi Tidak Tersedia',
    );
  }
}
