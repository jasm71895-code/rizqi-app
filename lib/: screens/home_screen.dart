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
      home: const RizqiHomeDashboard(),
    );
  }
}

class RizqiHomeDashboard extends StatefulWidget {
  const RizqiHomeDashboard({super.key});

  @override
  State<RizqiHomeDashboard> createState() => _RizqiHomeDashboardState();
}

class _RizqiHomeDashboardState extends State<RizqiHomeDashboard> {
  final TextEditingController _salesController = TextEditingController();
  double _totalSales = 0.0;
  double _totalProfit = 0.0;

  void _calculateProfit(String value) {
    setState(() {
      _totalSales = double.tryParse(value) ?? 0.0;
      _totalProfit = _totalSales * 0.15; // حساب عمولة التسويق 15%
    });
  }

  @override
  void dispose() {
    _salesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('منصة رزقي | RIZQI'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // بطاقة الأرباح العلوية
            Container(
              width: double.infinity,
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
                    '${_totalProfit.toStringAsFixed(2)} د.ع',
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

            // حقل إدخال المبيعات التفاعلي
            TextField(
              controller: _salesController,
              keyboardType: TextInputType.number,
              onChanged: _calculateProfit,
              decoration: const InputDecoration(
                labelText: 'أدخل قيمة المبيعات (د.ع)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.monetization_on),
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'أقسام المنصة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // شبكة الأقسام بتصميم عصري
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildSectionCard(context, 'المنتجات', Icons.shopping_bag, Colors.orange),
                _buildSectionCard(context, 'الطلبات', Icons.list_alt, Colors.blue),
                _buildSectionCard(context, 'المسوقين', Icons.group, Colors.purple),
                _buildSectionCard, // سيتم تصحيحها للسطر التالي
                _buildSectionCard(context, 'الإعدادات', Icons.settings, Colors.teal),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم فتح قسم $title')),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
