import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

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
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}