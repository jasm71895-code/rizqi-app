import 'package:flutter/material.dart';

void main() {
  runApp(const RizqiApp());
}

class RizqiApp extends StatelessWidget {
  const RizqiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'رزقي | RIZQI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const Scaffold(
        appBar: AppBar(
          title: Text('منصة رزقي | RIZQI'),
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Text(
            'مرحباً بك في تطبيق رزقي',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal),
          ),
        ),
      ),
    );
  }
}
