import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const RizqiApp());
}

class ProductItem {
  final String id;
  final String title;
  final String price;
  final String sellerName;
  final String imageUrl;
  final String province;
  final String description;

  ProductItem({
    required this.id,
    required this.title,
    required this.price,
    required this.sellerName,
    required this.imageUrl,
    this.province = 'جميع المحافظات',
    this.description = 'منتج جديد متوفر للتوصيل لكافة المحافظات العراقية. تواصل مع التاجر للمساومة على السعر.',
  });
}

// المتجر يبدأ فارغاً تماماً بدون أي منتجات سابقة
List<ProductItem> globalProducts = [];

class UserSession {
  static String userName = '';
  static String email = '';
  static double balance = 0.0; // الرصيد يبدأ صفراً
  static bool isLoggedIn = false;
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
      home: UserSession.isLoggedIn ? const MainScreen() : const LoginScreen(),
    );
  }
}

// 1. شاشة تسجيل الدخول (مع جوجل وحفظ الجلسة)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();

  void _login(String name, String email) {
    setState(() {
      UserSession.userName = name;
      UserSession.email = email;
      UserSession.balance = 0.0; // يبدأ الرصيد صفراً
      UserSession.isLoggedIn = true;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.storefront, size: 80, color: Colors.teal),
              const SizedBox(height: 16),
              const Text('منصة رزقي التجارية | RIZQI', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal)),
              const SizedBox(height: 8),
              const Text('حسابك يبدأ من الصفر وبرصيد آمن', style: TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'الاسم أو اسم المتجر',
                  prefixIcon: const Icon(Icons.person, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      _login(_nameController.text, '${_nameController.text.replaceAll(' ', '').toLowerCase()}@gmail.com');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء إدخال الاسم')));
                    }
                  },
                  child: const Text('دخول إلى التطبيق', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.white, side: const BorderSide(color: Colors.grey), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () => _login('مستخدم Google المعتمد', 'rizqi.google@gmail.com'),
                  icon: const Icon(Icons.g_mobiledata, size: 32, color: Colors.red),
                  label: const Text('تسجيل الدخول بواسطة إيميل Google', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      const HomeScreen(),
      const ProductsCatalogScreen(),
      const AddProductScreen(),
      const BalanceTopUpScreen(), // قسم الدفع والشحن عبر رصيد الشركات
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.store_mall_directory_outlined), activeIcon: Icon(Icons.store), label: 'المتجر'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), activeIcon: Icon(Icons.add_circle), label: 'نشر منتج'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), activeIcon: Icon(Icons.account_balance_wallet), label: 'شحن رصيد'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('أهلاً، ${UserSession.userName} | الرصيد: ${UserSession.balance.toStringAsFixed(0)} د.ع', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.teal[700], borderRadius: BorderRadius.circular(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('رصيدك الحالي في المنصة:', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  Text('${UserSession.balance.toStringAsFixed(0)} د.ع', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('المتجر نظيف وخالٍ من المنتجات السابقة. ابدأ بنشر منتجك الآن!', style: TextStyle(color: Colors.white90, fontSize: 11)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('المنتجات المعروضة في المتجر', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            globalProducts.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      chnoose: Text('لا توجد منتجات حالياً. أضف أول منتج ليكتشفه الجميع!'),
                      child: Text('لا توجد منتجات حالياً في المتجر. اضغط على "نشر منتج" لإضافة منتجاتك!', style: TextStyle(color: Colors.grey)),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: globalProducts.length,
                    itemBuilder: (context, index) => ProductCard(product: globalProducts[index]),
                  ),
          ],
        ),
      ),
    );
  }
}

// 2. كتالوج المتجر
class ProductsCatalogScreen extends StatelessWidget {
  const ProductsCatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('متجر رزقي الشامل'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: globalProducts.isEmpty
          ? const Center(child: Text('المتجر فارغ حالياً. كن أول من ينشر منتجاً!', style: TextStyle(color: Colors.grey)))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.6,
              ),
              itemCount: globalProducts.length,
              itemBuilder: (context, index) => ProductCard(product: globalProducts[index]),
            ),
    );
  }
}

// 3. شاشة نشر المنتج (يبقى دائماً في المتجر)
class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedProvince = 'جميع المحافظات';

  final List<String> provinces = [
    'جميع المحافظات', 'بغداد', 'البصرة', 'النجف الأشرف', 'كربلاء المقدسة',
    'أربيل', 'السليمانية', 'نينوى', 'الأنبار', 'بابل', 'ديالى', 'صلاح الدين',
    'كركوك', 'المثنى', 'الديوانية', 'ميسان', 'ذي قار', 'واسط'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('نشر منتج جديد في المتجر'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('ما تنشره الآن سيبقى ثابتاً في المتجر ويظهر لجميع المستخدمين:', style: TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 16),
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'اسم المنتج', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'السعر (مثال: 25,000 د.ع)', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _imageController, decoration: const InputDecoration(labelText: 'رابط صورة المنتج (URL)', border: OutlineInputBorder(), hintText: 'https://...')),
            const SizedBox(height: 12),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'وصف المنتج وتفاصيله', border: OutlineInputBorder()), maxLines: 2),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedProvince,
              decoration: const InputDecoration(labelText: 'نطاق التوصيل للمحافظات', border: OutlineInputBorder()),
              items: provinces.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (val) => setState(() => _selectedProvince = val!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                if (_titleController.text.isNotEmpty && _priceController.text.isNotEmpty) {
                  setState(() {
                    globalProducts.insert(
                      0,
                      ProductItem(
                        id: DateTime.now().toString(),
                        title: _titleController.text,
                        price: _priceController.text,
                        sellerName: UserSession.userName,
                        imageUrl: _imageController.text.isNotEmpty ? _imageController.text : 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
                        province: _selectedProvince,
                        description: _descController.text.isNotEmpty ? _descController.text : 'منتج جديد متوفر للتوصيل.',
                      ),
                    );
                    UserSession.balance += 1000; // مكافأة نشر
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نشر المنتج بنجاح وأصبح ظاهراً للجميع في المتجر!')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء إدخال اسم المنتج والسعر')));
                }
              },
              child: const Text('نشر المنتج للعامة'),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. شاشة شحن الرصيد عبر شركات الاتصالات (آسيا سيل، كورك، زين)
class BalanceTopUpScreen extends StatefulWidget {
  const BalanceTopUpScreen({super.key});

  @override
  State<BalanceTopUpScreen> createState() => _BalanceTopUpScreenState();
}

class _BalanceTopUpScreenState extends State<BalanceTopUpScreen> {
  String _selectedCompany = 'آسيا سيل (Asiacell)';
  final _phoneController = TextEditingController();
  final _cardController = TextEditingController();

  final List<String> companies = [
    'آسيا سيل (Asiacell)',
    'كورك تيليكوم (Korek)',
    'زين العراق (Zain Iraq)'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('شحن الرصيد عبر شركات الاتصالات'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('اشحن رصيدك أو حول أرباحك عبر كارتات الشحن لشبكات العراق:', style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedCompany,
              decoration: const InputDecoration(labelText: 'اختر شركة الرصيد', border: OutlineInputBorder()),
              items: companies.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _selectedCompany = val!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'رقم الهاتف (مثال: 0770xxxxxxx)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _cardController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'رقم كارت الشحن أو رمز التحويل', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                if (_cardController.text.length >= 5 && _phoneController.text.length >= 10) {
                  setState(() {
                    UserSession.balance += 10000; // محاكاة شحن 10 آلاف دينار
                  });
                  _cardController.clear();
                  _phoneController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إرسال طلب شحن الرصيد بنجاح وسيتم إضافته لحسابك!')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء التأكد من إدخال رقم الهاتف وكارت الشحن بشكل صحيح')));
                }
              },
              child: const Text('تأكيد شحن الرصيد'),
            ),
          ],
        ),
      ),
    );
  }
}

// 5. شاشة تفاصيل المنتج والمساومة مع التاجر
class ProductDetailScreen extends StatelessWidget {
  final ProductItem product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.imageUrl, height: 260, width: double.infinity, fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(height: 200, color: Colors.teal[50], child: const Icon(Icons.shopping_bag, size: 80, color: Colors.teal)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(product.price, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.teal[50], borderRadius: BorderRadius.circular(8)),
                        child: Text(product.province, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('التاجر الناشر: ${product.sellerName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  const Text('تفاصيل المنتج:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(product.description, style: const TextStyle(color: Colors.black70)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
                      onPressed: () {
                
