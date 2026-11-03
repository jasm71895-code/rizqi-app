import 'package:flutter/material.dart';

void main() {
  runApp(const RizqiApp());
}

class RizqiApp extends StatelessWidget {
  const RizqiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'رزقي | RIZQI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: const RizqiHomeScreen(),
    );
  }
}

class RizqiHomeScreen extends StatelessWidget {
  const RizqiHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('منصة رزقي للتجارة والتسويق بالعمولة'),
        backgroundColor: Colors.teal.shade700,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.teal),
            const SizedBox(height: 20),
            const Text(
              'مرحباً بكِ في تطبيق رزقي',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'المنصة الرائدة للتجارة الإلكترونية والتسويق بالعمولة في العراق',
              style: TextStyle(fontSize: 14, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                // الانتقال للوحة التحكم
              },
              icon: const Icon(Icons.login),
              label: const Text('دخول لوحة التحكم', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
