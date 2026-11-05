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

  ProductItem({
    required this.title,
    required this.price,
    required this.commission,
    required this.sellerName,
    required this.imageUrl,
    this.province = 'جميع المحافظات',
  });
}

class AdBanner {
  final String title;
  final String description;
  final Color backgroundColor;

  AdBanner({required this.title, required this.description, required this.backgroundColor});
}

List<ProductItem> globalProducts = [
  ProductItem(
    title: 'سماعات بلوتوث ذكية',
    price: '35,000 د.ع',
    commission: '5,000 د.ع',
    sellerName: 'متجر التقنية',
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
    province: 'بغداد',
  ),
  ProductItem(
    title: 'حقيبة ظهر أنيقة',
    price: '25,000 د.ع',
    commission: '4,000 د.ع',
    sellerName: 'أزياء بغداد',
    imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
    province: 'أربيل',
  ),
];

List<AdBanner> globalAds = [
  AdBanner(title: '🔥 التوصيل متوفر لكافة محافظات العراق', description: 'انضمي الآن لمنصة رزقي وابدئي البيع برصيد حساب ابتدائي 0 دينار.', backgroundColor: Colors.teal),
  AdBanner(title: '💳 ميزة الدفع بالماستر كارد', description: 'تم تفعيل بوابة الدفع الإلكتروني ورسوم الـ 3,000 د.ع بكل سهولة.', backgroundColor: Colors.indigo),
];

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
      home: const LoginScreen(),
    );
  }
}

// 1. شاشة تسجيل الدخول (مع دعم Google والدخول التقليدي)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  bool _isMerchant = false;

  void _proceedToApp(String name) {
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
              const Text('حسابك يبدأ بـ (0 دينار) - لكافة المحافظات العراقية', style: TextStyle(color: Colors.grey, fontSize: 12)),
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
                      _proceedToApp(_nameController.text);
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
                    _proceedToApp('مستخدم Google المعتمد');
                  },
                  icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.red),
                  label: const Text('تسجيل الدخول بواسطة Google', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// الشاشة الرئيسية مع التنقل السفلي المطور
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
      const ProductsScreen(),
      const MastercardScreen(), // 2. شاشة الماستر كارد والدفع الإلكتروني
      const SupportAIScreen(), // الدعم والذكاء الاصطناعي والشكاوى
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
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: 'المنتجات'),
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
        title: Text('أهلاً، $userName | رصيد الحساب: 0 د.ع', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('الإعلانات والعروض التجارية', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
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
            const Text('المنتجات المتاحة لكافة المحافظات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.58,
              ),
              itemCount: globalProducts.length,
              itemBuilder: (context, index) {
                return ProductCard(product: globalProducts[index], isMerchant: isMerchant);
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 2. شاشة ربط الماستر كارد للدفع الإلكتروني
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
                      Text(_nameController.text.isNotEmpty ? _nameController.text : 'اسم حامل البطاقة', style: const TextStyle(color: Colors.white70)),
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
                  setState(() {
                    _isLinked = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم ربط الماستر كارد بنجاح لتسوية رسوم الـ 3,000 د.ع!')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء إدخال رقم بطاقة صحيح')));
                }
              },
              child: Text(_isLinked ? 'البطاقة مفعلة ومربوحة' : 'ربط وتفعيل الماستر كارد'),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. شاشة إضافة المنتجات وتحديد المحافظات ورسوم الـ 3000 دينار
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

  final List<String> provinces = [
    'جميع المحافظات', 'بغداد', 'البصرة', 'النجف الأشرف', 'كربلاء المقدسة',
    'أربيل', 'السليمانية', 'نينوى', 'الأنبار', 'بابل', 'ديالى', 'صلاح الدين',
    'كركوك', 'المثنى', 'الديوانية', 'ميسان', 'ذي قار', 'واسط'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة منتج جديد (رسوم البيع: 3,000 د.ع)'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('أدخل تفاصيل المنتج مع تحديد النطاق الجغرافي للتوصيل:', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'اسم المنتج', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'سعر المنتج (مثال: 35,000 د.ع)', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _imageController, decoration: const InputDecoration(labelText: 'رابط صورة المنتج (URL)', border: OutlineInputBorder(), hintText: 'https://...')),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedProvince,
              decoration: const InputDecoration(labelText: 'نطاق التوصيل للمحافظات', border: OutlineInputBorder()),
              items: provinces.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedProvince = val!;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                if (_titleController.text.isNotEmpty && _priceController.text.isNotEmpty) {
                  setState(() {
                    globalProducts.add(ProductItem(
                      title: _titleController.text,
                      price: _priceController.text,
                      commission: '5,000 د.ع',
                      sellerName: widget.merchantName,
                      imageUrl: _imageController.text.isNotEmpty ? _imageController.text : 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
                      province: _selectedProvince,
                    ));
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نشر المنتج بنجاح! سيتم خصم 3,000 د.ع عند كل عملية بيع.')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء إكمال اسم المنتج والسعر')));
                }
              },
              child: const Text('نشر المنتج في المنصة'),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. الدعم والشكاوى بالذكاء الاصطناعي
class SupportAIScreen extends StatefulWidget {
  const SupportAIScreen({super.key});

  @override
  State<SupportAIScreen> createState() => _SupportAIScreenState();
}

class _SupportAIScreenState extends State<SupportAIScreen> {
  final List> _messages = [
    {'text': 'أهلاً بكِ في المساعد الذكي لمنصة رزقي 🤖.\nحسابكِ الحالي يبدأ بـ (0 دينار). كيف يمكنني مساعدتكِ اليوم في الطلبات أو الشحن لكافة المحافظات؟', 'isUser': false},
  ];
  final _textController = TextEditingController();

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;
    final userText = _textController.text;
    setState(() {
      _messages.add({'text': userText, 'isUser': true});
      _textController.clear();
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      String aiReply = 'تم تسجيل شكواكِ ومعالجتها آلياً. التوصيل متوفر لجميع المحافظات ورسوم البيع ثابتة (3,000 د.ع).';
      if (userText.contains('محافظة') || userText.contains('توصيل')) {
        aiReply = 'نحن نغطي جميع محافظات العراق (بغداد، البصرة، أربيل، وسائر المحافظات) بخدمة توصيل سريعة.';
      } else if (userText.contains('ماستر') || userText.contains('دفع')) {
        aiReply = 'يمكنكِ ربط بطاقة الماستر كارد من تبويب "الماستر كارد" لتسوية الرسوم بكل أمان وسلاسة.';
      }

      setState(() {
        _messages.add({'text': aiReply, 'isUser': false});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الدعم والشكاوى الذكي'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'] as bool;
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.teal : Colors.teal[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(msg['text'], style: TextStyle(color: isUser ? Colors.white : Colors.black87)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'اكتبي استفساركِ أو شكواكِ هنا...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('جميع المنتجات'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.58),
        itemCount: globalProducts.length,
        itemBuilder: (context, index) => ProductCard(product: globalProducts[index], isMerchant: false),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  final String userName;
  final bool isMerchant;

  const ProfileScreen({super.key, required this.userName, required this.isMerchant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حسابي'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, backgroundColor: Colors.teal, child: Icon(Icons.person, size: 50, color: Colors.white)),
            const SizedBox(height: 12),
            Text(userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('رصيد الحساب: 0 دينار عراقي', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            if (isMerchant) ...[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductMerchantScreen(merchantName: userName))),
                child: const Text('إضافة منتج جديد (رسم البيع: 3,000 د.ع)'),
              ),
            ] else ...[
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('أنتِ مسجلة في منصة رزقي. تصفحي المنتجات وشاركي روابط الترويج لكافة المحافظات لزيادة أرباحكِ!'),
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductItem product;
  final bool isMerchant;
  const ProductCard({super.key, required this.product, required this.isMerchant});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.teal[50],
                  child: const Center(child: Icon(Icons.shopping_bag, size: 40, color: Colors.teal)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1),
                const SizedBox(height: 4),
                Text(product.price, style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 2),
                Text('رسوم المنصة: 3,000 د.ع', style: const TextStyle(color: Colors.orange, fontSize: 10)),
                const SizedBox(height: 2),
                Text('الشحن: ${product.province}', style: const TextStyle(color: Colors.blueGrey, fontSize: 9)),
                const SizedBox(height: 2),
                Text('التاجر: ${product.sellerName}', style: const TextStyle(color: Colors.grey, fontSize: 9)),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  height: 28,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[50], foregroundColor: Colors.teal, elevation: 0, padding: EdgeInsets.zero),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: 'https://rizqi-app.com/share?product=${product.title}'));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ رابط الترويج بنجاح!')));
                    },
                    child: const Text('نسخ رابط الترويج', style: TextStyle(fontSize: 10)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
