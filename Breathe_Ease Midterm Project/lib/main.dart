import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const BreatheEaseApp());
}

class BreatheEaseApp extends StatelessWidget {
  const BreatheEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BreatheEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF6FBFA),
        useMaterial3: false,
      ),
      home: const HomePage(),
    );
  }
}
