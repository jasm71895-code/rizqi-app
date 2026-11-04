import 'package:flutter/material.dart';

void main() {
  runApp(const RizqiApp());
}

class RizqiApp extends StatelessWidget {
  const RizqiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'رزقي | RIZQI',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      ),
      home: const RizqiHomeDashboard(),
    );
  }
}

class RizqiHomeDashboard extends StatefulWidget {
  const RizqiHomeDashboard({Key? key}) : super(key: key);

  @override
  State<RizqiHomeDashboard> createState() => _RizqiHomeDashboardState();
}

class _RizqiHomeDashboardState extends State<RizqiHomeDashboard> {
  int _currentIndex = 0;
  double _calculatedProfit = 0.0;
  final TextEditingController _salesController = TextEditingController();

  // دالة حساب الأرباح بسلاسة ودون تعليق الواجهة
  void _calculateEarnings(String value) {
    setState(() {
      double sales = double.tryParse(value) ?? 0.0;
      _calculatedProfit = sales * 0.15; // نسبة عمولة تسويق 15%
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'منصة رزقي | RIZQI',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.teal.shade700,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('لا توجد إشعارات جديدة حالياً')),
              );
            },
          ),
        ],
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
                gradient: LinearGradient(
                  colors: [Colors.teal.shade700, Colors.teal.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مرحباً بكِ في لوحة التحكم',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'إجمالي الأرباح المتوقعة',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_calculatedProfit.toStringAsFixed(2)} د.ع',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // قسم حاسبة الأرباح التفاعلية
            const Text(
              'حاسبة الأرباح السريعة',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, spreadRadius: 2),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _salesController,
                    keyboardType: TextInputType.number,
                    onChanged: _calculateEarnings,
                    decoration: InputDecoration(
                      labelText: 'أدخل قيمة المبيعات (د.ع)',
                      prefixIcon: const Icon(Icons.monetization_on, color: Colors.teal),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'يتم حساب نسبة العمولة (15%) فوراً عند الكتابة.',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // شبكة الأزرار والأقسام
            const Text(
              'أقسام المنصة والتحكم',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _buildFeatureCard(context, 'المنتجات', Icons.shopping_bag, Colors.orange, () {
                  _showMsg(context, 'تم فتح قسم إدارة المنتجات');
                }),
                _buildFeatureCard(context, 'الطلبات', Icons.list_alt, Colors.blue, () {
                  _showMsg(context, 'تم فتح تتبع حالات الطلبات');
                }),
                _buildFeatureCard(context, 'المسوقين', Icons.group, Colors.purple, () {
                  _showMsg(context, 'تم فتح شبكة المسوقين بالعمولة');
                }),
                _buildFeatureCard(context, 'الإعدادات', Icons.settings, Colors.teal, () {
                  _showMsg(context, 'تم فتح لوحة الإعدادات العامة');
                }),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.teal.shade700,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'الأرباح'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, spreadRadius: 1),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  void _showMsg(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }
}
