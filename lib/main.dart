import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'loginpage.dart';
import 'homepage.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
  tz.initializeTimeZones();

  
  await Hive.initFlutter();
  await Hive.openBox('users');
  await Hive.openBox('session');
  await Hive.openBox('history');
  await Hive.openBox('profile');

  
  const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidInit);
  await flutterLocalNotificationsPlugin.initialize(initSettings);

  
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF4F6F8),
      ),
      home: (initialUsername != null)
          ? HomePage(username: initialUsername!)
          : const LoginPage(),
    );
  }
}
