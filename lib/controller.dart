import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

class ControllerPage extends StatefulWidget {
  const ControllerPage({super.key});

  @override
  State<ControllerPage> createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _notifikasiAktif = false;

  @override
  void initState() {
    super.initState();
    _initNotifikasi();
  }

  
  Future<void> _initNotifikasi() async {
    tz.initializeTimeZones();

    
    final notifStatus = await Permission.notification.status;
    if (!notifStatus.isGranted) {
      await Permission.notification.request();
    }

    
    if (await Permission.scheduleExactAlarm.isDenied) {
    
      await openAppSettings();
    }

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  
  Future<void> _tampilkanNotifikasiLangsung() async {
    const androidDetail = AndroidNotificationDetails(
      'flashsale_channel',
      'Flash Sale Notifications',
      channelDescription: 'Notifikasi promo spesial DigiSentral',
      importance: Importance.max,
      priority: Priority.high,
      color: Colors.black,
      playSound: true,
    );

    const notifDetail = NotificationDetails(android: androidDetail);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Notifikasi Berhasil!',
      'Notifikasi langsung bekerja dengan baik.',
      notifDetail,
    );
  }

  
  Future<void> _jadwalkanNotifikasi() async {
    final waktuJadwal = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 10));

    const androidDetail = AndroidNotificationDetails(
      'flashsale_channel',
      'Flash Sale Notifications',
      channelDescription: 'Notifikasi promo spesial DigiSentral',
      importance: Importance.max,
      priority: Priority.high,
      color: Colors.black,
      playSound: true,
    );

    const notifDetail = NotificationDetails(android: androidDetail);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Flash Sale DigiSentral!',
      'Segera ikuti promo spesial sebelum waktunya habis!',
      waktuJadwal,
      notifDetail,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  
  void _toggleNotifikasi(bool aktif) async {
    setState(() => _notifikasiAktif = aktif);

    if (aktif) {
      await _jadwalkanNotifikasi();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notifikasi diaktifkan! Akan muncul dalam 10 detik.'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      await flutterLocalNotificationsPlugin.cancelAll();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notifikasi dimatikan.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        title: const Text(
          'Pengaturan Notifikasi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Icon(
              Icons.notifications_active,
              size: 90,
              color: Colors.black87,
            ),
            const SizedBox(height: 20),
            const Text(
              'Kontrol Notifikasi Flash Sale',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Aktifkan untuk menerima notifikasi promo menarik\nsetiap kali ada Flash Sale DigiSentral.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
            const SizedBox(height: 40),
            SwitchListTile(
              title: const Text(
                'Aktifkan Notifikasi (Delay 10 detik)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              value: _notifikasiAktif,
              onChanged: _toggleNotifikasi,
              activeColor: Colors.black,
            ),
            const SizedBox(height: 20),

            // Tombol test notifikasi langsung
            ElevatedButton.icon(
              onPressed: _tampilkanNotifikasiLangsung,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Test Notifikasi Langsung'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Profil'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
