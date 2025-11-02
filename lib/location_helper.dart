import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

Future<void> requestLocationPermission(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Layanan lokasi tidak aktif. Aktifkan GPS Anda.'),
        backgroundColor: Colors.redAccent,
      ),
    );
    return;
  }

  
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Izin lokasi ditolak.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Izin lokasi ditolak permanen. Ubah di pengaturan.'),
        backgroundColor: Colors.redAccent,
      ),
    );
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Izin lokasi diberikan ✅'),
      backgroundColor: Colors.green,
    ),
  );
}
