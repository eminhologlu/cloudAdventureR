import 'package:arprojesi/login.dart';

import 'package:arprojesi/splash_screen.dart';
import 'package:arprojesi/your_currencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AR PROJESI',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/yourcurrencies': (context) => const CurrencyListScreen(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
