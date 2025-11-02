import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'loginpage.dart';
import 'homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await Hive.openBox('users'); // ✅ untuk user login
  await Hive.openBox('session'); // ✅ untuk session aktif
  await Hive.openBox('history'); // ✅ tambahkan ini untuk riwayat pembelian

  // Cek session
  final session = Hive.box('session');
  final savedEmail = session.get('email') as String?;
  final savedUsername = session.get('username') as String?;

  runApp(
    MyApp(
      initialUsername: (savedEmail != null && savedUsername != null)
          ? savedUsername
          : null,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String? initialUsername;
  const MyApp({super.key, this.initialUsername});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DigiSentral',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: (initialUsername != null)
          ? HomePage(username: initialUsername!)
          : const LoginPage(),
    );
  }
}
