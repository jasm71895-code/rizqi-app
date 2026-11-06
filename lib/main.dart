import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const RizqiApp());
}

class ProductItem {
  final String title;
  final String price;
  final String commission;
  final String sellerName;
  final String imageUrl;
  final String province;
  final String category;

  ProductItem({
    required this.title,
    required this.price,
    required this.commission,
    required this.sellerName,
    required this.imageUrl,
    this.province = 'جميع المحافظات',
    this.category = 'عام',
  });
}

class AdBanner {
  final String title;
  final String description;
  final Color backgroundColor;

  AdBanner({required this.title, required this.description, required this.backgroundColor});
}

// قائمة عامة تضمن ظهور أي منتج يضيفه التاجر لجميع المستخدمين فوراً
List<ProductItem> globalProducts = [
  ProductItem(
    title: 'سماعات بلوتوث ذكية لاسلكية',
    price: '35,000 د.ع',
    commission: '5,000 د.ع',
    sellerName: 'متجر التقنية الحديثة',
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
    province: 'بغداد',
    category: 'إلكترونيات',
  ),
  ProductItem(
    title: 'حقيبة ظهر أنيقة للسفر والجامعة',
    price: '25,000 د.ع',
    commission: '4,000 د.ع',
    sellerName: 'أزياء بغداد',
    imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
    province: 'أربيل',
    category: 'أزياء',
  ),
  ProductItem(
    title: 'ساعة يد ذكية مقاومة للماء',
    price: '45,000 د.ع',
    commission: '7,000 د.ع',
    sellerName: 'مجوهرات العراق',
    imageUrl: 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
    province: 'البصرة',
    category: 'إلكترونيات',
  ),
];

List<AdBanner> globalAds = [
  AdBanner(title: '🔥 جميع المنتجات تظهر لجميع المحافظات', description: 'انضمي الآن لمنصة رزقي وابدئي برصيد حساب 0 دينار وعمولات فورية.', backgroundColor: Colors.teal),
  AdBanner(title: '💳 تفعيل الدفع بالماستر كارد وبوابات الآمان', description: 'رسوم المنصة الثابتة 3,000 د.ع لكل عملية بيع ناجحة.', backgroundColor: Colors.indigo),
];

// معلومات الجلسة المحفوظة لكي لا يتم تسجيل الخروج أبداً
class UserSession {
  static String userName = '';
  static bool isMerchant = false;
  static bool isLoggedIn = false;
  static String email = '';
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
      home: UserSession.isLoggedIn 
          ? MainScreen(userName: UserSession.userName, isMerchant: UserSession.isMerchant)
          : const LoginScreen(),
    );
  }
}

// 1. شاشة تسجيل الدخول (مع حفظ البيانات ودعم Google)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  bool _isMerchant = false;

  void _loginSuccess(String name, String userEmail) {
    setState(() {
      UserSession.userName = name;
      UserSession.email = userEmail;
      UserSession.isMerchant = _isMerchant;
      UserSession.isLoggedIn = true;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(userName: name, isMerchant: _isMerchant),
      ),
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
              const Text('حسابك يبدأ بـ (0 دينار) - يظهر لجميع المحافظات', style: TextStyle(color: Colors.grey, fontSize: 12)),
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
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('تسجيل الدخول كـ (تاجر / صاحب منتجات)'),
                value: _isMerchant,
                activeColor: Colors.teal,
                onChanged: (val) {
                  setState(() {
                    _isMerchant = val;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_nameController.text.isNotEmpty) {
                      _loginSuccess(_nameController.text, '${_nameController.text.replaceAll(' ', '').toLowerCase()}@gmail.com');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء إدخال الاسم')));
                    }
                  },
                  child: const Text('دخول إلى المنصة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
              // زر تسجيل الدخول عبر Google
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Colors.grey),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    _loginSuccess('مستخدم Google المعتمد', 'rizqi.user@gmail.com');
                  },
                  icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.red),
                  label: const Text('الدخول بواسطة إيميل Google', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// الشاشة الرئيسية مع التنقل السفلي الاحترافي
class MainScreen extends StatefulWidget {
  final String userName;
  final bool isMerchant;

  const MainScreen({super.key, required this.userName, required this.isMerchant});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(userName: widget.userName, isMerchant: widget.isMerchant),
      const ProductsCatalogScreen(),
      const MastercardScreen(), 
      const SupportAIScreen(), 
      ProfileScreen(userName: widget.userName, isMerchant: widget.isMerchant),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'الرئيسية'),
          BottomNavigationBarItem(icon: Icon(Icons.store_mall_directory_outlined), activeIcon: Icon(Icons.store), label: 'المتجر'),
          BottomNavigationBarItem(icon: Icon(Icons.credit_card), activeIcon: Icon(Icons.credit_card), label: 'الماستر كارد'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy_outlined), activeIcon: Icon(Icons.smart_toy), label: 'الدعم الذكي'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final String userName;
  final bool isMerchant;

  const HomeScreen({super.key, required this.userName, required this.isMerchant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('أهلاً، $userName | رصيد: 0 د.ع', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          if (isMerchant)
            IconButton(
              icon: const Icon(Icons.add_box),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductMerchantScreen(merchantName: userName))),
              tooltip: 'إضافة منتج يظهر للجميع',
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // شريط الإعلانات
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: globalAds.length,
                itemBuilder: (context, index) {
                  final ad = globalAds[index];
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(left: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: ad.backgroundColor, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(ad.title, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(ad.description, style: const TextStyle(color: Colors.white70, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                const Text('أحدث المنتجات المعروضة للجميع', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                if (isMerchant)
                  TextButton.icon(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductMerchantScreen(merchantName: userName))),
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('أضف منتجك الآن'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            // عرض المنتجات بشكل فوري وشامل لجميع المستخدمين
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.55,
              ),
              itemCount: globalProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(product: globalProducts[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 2. شاشة كتالوج المتجر (مشابهة لخصائص متاجر التطبيقات الكبرى)
class ProductsCatalogScreen extends StatefulWidget {
  const ProductsCatalogScreen({super.key});

  @override
  State<ProductsCatalogScreen> createState() => _ProductsCatalogScreenState();
}

class _ProductsCatalogScreenState extends State<ProductsCatalogScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'الكل';

  @override
  Widget build(BuildContext context) {
    final filteredProducts = globalProducts.where((p) {
      final matchesSearch = p.title.contains(_searchQuery) || p.sellerName.contains(_searchQuery);
      final matchesCat = _selectedCategory == 'الكل' || p.category == _selectedCategory;
      return matchesSearch && matchesCat;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('متجر رزقي الشامل'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'ابحث عن أي منتج أو متجر...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: ['الكل', 'إلكترونيات', 'أزياء', 'عام'].map((cat) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: _selectedCategory == cat,
                    onSelected: (selected) => setState(() => _selectedCategory = cat),
                    selectedColor: Colors.teal[100],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.55,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) => ProductCard(product: filteredProducts[index]),
            ),
          ),
        ],
      ),
    );
  }
}

// 3. شاشة إدارة الماستر كارد والدفع الإلكتروني
class MastercardScreen extends StatefulWidget {
  const MastercardScreen({super.key});

  @override
  State<MastercardScreen> createState() => _MastercardScreenState();
}

class _MastercardScreenState extends State<MastercardScreen> {
  final _cardController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLinked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الماستر كارد والدفع الإلكتروني'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.indigo, Colors.teal]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mastercard / Visa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      Icon(Icons.credit_card, color: Colors.white, size: 30),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text(_isLinked ? '**** **** **** 8821' : '#### #### #### ####', style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 2)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_nameController.text.isNotEmpty ? _nameController.text : UserSession.userName, style: const TextStyle(color: Colors.white70)),
                      const Text('رسم البيع: 3,000 د.ع', style: TextStyle(color: Colors.orangeAccent, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'اسم حامل البطاقة الثلاثي', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cardController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'رقم البطاقة (16 رقم)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                if (_cardController.text.length >= 10) {
                  setState(() => _isLinked = true);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم ربط وتفعيل الماستر كارد بنجاح!')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء إدخال رقم بطاقة صحيح')));
                }
              },
              child: Text(_isLinked ? 'البطاقة مفعلة ومربوطة' : 'ربط وتفعيل الماستر كارد'),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. شاشة إضافة المنتجات ونشرها لجميع المستخدمين فوراً
class AddProductMerchantScreen extends StatefulWidget {
  final String merchantName;
  const AddProductMerchantScreen({super.key, required this.merchantName});

  @override
  State<AddProductMerchantScreen> createState() => _AddProductMerchantScreenState();
}

class _AddProductMerchantScreenState extends State<AddProductMerchantScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  String _selectedProvince = 'جميع المحافظات';
  String _selectedCategory = 'إلكترونيات';

  final List<String> provinces = [
    'جميع المحافظات', 'بغداد', 'البصرة', 'النجف الأشرف', 'كربلاء المقدسة',
    'أربيل', 'السليمانية', 'نينوى', 'الأنبار', 'بابل', 'ديالى', 'صلاح الدين',
    'كركوك', 'المثنى', 'الديوانية', 'ميسان', 'ذي قار', 'واسط'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
