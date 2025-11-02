class Transaksi {
  final String id;
  final DateTime tanggal;
  final double total;
  final String metode;
  final String currency;

  Transaksi({
    required this.id,
    required this.tanggal,
    required this.total,
    required this.metode,
    required this.currency,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tanggal': tanggal.toIso8601String(),
      'total': total,
      'metode': metode,
      'currency': currency,
    };
  }

  factory Transaksi.fromMap(Map<String, dynamic> map) {
    return Transaksi(
      id: map['id'],
      tanggal: DateTime.parse(map['tanggal']),
      total: map['total'],
      metode: map['metode'],
      currency: map['currency'],
    );
  }
}
