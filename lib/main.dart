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
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const RizqiHomePage(),
    );
  }
}

class RizqiHomePage extends StatefulWidget {
  const RizqiHomePage({super.key});

  @override
  State<RizqiHomePage> createState() => _RizqiHomePageState();
}

class _RizqiHomePageState extends State<RizqiHomePage> {
  double _sales = 0.0;
  double _profit = 0.0;

  void _calculate(String value) {
    setState(() {
      _sales = double.tryParse(value) ?? 0.0;
      _profit = _sales * 0.15; // حساب عمولة 15%
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('منصة رزقي | RIZQI'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // بطاقة الأرباح
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.shade700,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إجمالي الأرباح المتوقعة',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_profit.toStringAsFixed(2)} د.ع',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // حقل إدخال المبيعات
            TextField(
              keyboardType: TextInputType.number,
              onChanged: _calculate,
              decoration: const InputDecoration(
                labelText: 'أدخل قيمة المبيعات',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.money),
              ),
            ),
            const SizedBox(height: 20),
            
            const Text(
              'أقسام التطبيق',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            
            // شبكة الأقسام
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _card('المنتجات', Icons.shopping_bag, Colors.orange),
                _card('الطلبات', Icons.list_alt, Colors.blue),
                _card('المسوقين', Icons.group, Colors.purple),
                _card('الإعدادات', Icons.settings, Colors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم فتح قسم $title')),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
