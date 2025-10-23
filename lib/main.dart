import 'package:flutter/material.dart';
import 'screens/main_sreen.dart';

void main() {
  runApp(const MetroParkApp());
}

class MetroParkApp extends StatelessWidget {
  const MetroParkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MetroPark',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}