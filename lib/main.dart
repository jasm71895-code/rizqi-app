import 'package:flutter/material.dart';

void main() {
  runApp(const RizqiApp());
}

// نموذج بيانات المنتج
class ProductItem {
  final String title;
  final String price;
  final String commission;
  final String platformFee;
  final String sellerName;

  ProductItem({
    required this.title,
    required this.price,
    required this.commission,
    this.platformFee = '3,000 د.ع',
    required this.sellerName,
  });
}

// قائمة المنتجات العامة
List<ProductItem> globalProducts = [
  ProductItem(title: 'سماعات بلوتوث ذكية', price: '35,000 د.ع', commission: 'عمولة المسوق: 5,000 د.ع', sellerName: 'متجر التقنية'),
  ProductItem(title: 'حقيبة ظهر أنيقة', price: '25,000 د.ع', commission: 'عمولة المسوق: 4,000 د.ع', sellerName: 'أزياء بغداد'),
];

// نموذج رسائل الشكاوى مع الذكاء الاصطناعي
class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
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
      home: const LoginScreen(),
    );
  }
}

// 1. شاشة تسجيل الدخول
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  bool _isMerchant = false;

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
              const Text(
                'منصة رزقي | RIZQI',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              const SizedBox(height: 8),
              const Text('سجلي دخولكِ كتاجر أو مسوق وابدئي العمل', style: TextStyle(color: Colors.grey)),
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(userName: _nameController.text, isMerchant: _isMerchant),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('الرجاء إدخال الاسم')),
                      );
                    }
                  },
                  child: const Text('دخول إلى المنصة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. شاشة التنقل الرئيسية والشريط السفلي
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
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: 'المنتجات'),
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy_outlined), activeIcon: Icon(Icons.smart_toy), label: 'الدعم والشكاوى'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'حسابي'),
        ],
      ),
    );
  }
}

// 3. الصفحة الرئيسية
class HomeScreen extends StatelessWidget {
  final String userName;
  final bool isMerchant;

  const HomeScreen({super.key, required this.userName, required this.isMerchant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('أهلاً، $userName ${isMerchant ? '(تاجر)' : ''}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Colors.teal, Colors.tealAccent], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isMerchant ? 'قسم التجار - منصة رزقي' : 'منصة التسويق بالعمولة',
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isMerchant
                        ? 'اعرض منتجاتك الآن برسم ثابت 3,000 د.ع للمنصة لكل منتج ووصلها لآلاف المسوقين.'
                        : 'ضاعفي أرباحكِ بالتسويق لأفضل منتجات التجار المتاحة.',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('أحدث المنتجات المعروضة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.68,
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

// 4. قسم الشكاوى والدعم الفني بالذكاء الاصطناعي
class SupportAIScreen extends StatefulWidget {
  const SupportAIScreen({super.key});

  @override
  State<SupportAIScreen> createState() => _SupportAIScreenState();
}

class _SupportAIScreenState extends State<SupportAIScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'أهلاً بكِ في مركز الدعم والشكاوى لـ منصة رزقي! 🤖\nكيف يمكنني مساعدتك اليوم؟', isUser: false),
  ];
  final _textController = TextEditingController();

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;

    final userText = _textController.text;
    setState(() {
      _messages.add(ChatMessage(text: userText, isUser: true));
      _textController.clear();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      String aiResponse = 'تم استلام شكواكِ/استفساركِ بنجاح. سيقوم الذكاء الاصطناعي وفريق الدعم بمتابعة الحالة فوراً!';
      if (userText.contains('منتج') || userText.contains('إضافة')) {
        aiResponse = 'بخصوص إضافة المنتجات: يتكفل التاجر بدفع رسم منصة قدره 3,000 د.ع عند عرض كل منتج جديد، ويتم إدراجه فوراً للمسوقين.';
      } else if (userText.contains('ربح') || userText.contains('سحب')) {
        aiResponse = 'يمكنك سحب أرباحك فوراً عبر زين كاش أو المحافظ الإلكترونية المتاحة من لوحة حسابك.';
      }

      setState(() {
        _messages.add(ChatMessage(text: aiResponse, isUser: false));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المساعد الذكي للشكاوى والدعم'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isUser ? Colors.teal : Colors.teal[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.text,
                      style: TextStyle(color: msg.isUser ? Colors.white : Colors.black87),
                    ),
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
                    decoration: InputDecoration(
                      hintText: 'اكتبي شكواكِ أو استفساركِ هنا...',
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
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

// 5. شاشة إضافة منتج للتاجر مع اقتطاع ربح المنصة (3,000 د.ع)
class AddProductMerchantScreen extends StatefulWidget {
  final String merchantName;
  const AddProductMerchantScreen({super.key, required this.merchantName});

  @override
  State<AddProductMerchantScreen> createState() => _AddProductMerchantScreenState();
}

class _AddProductMerchantScreenState extends State<AddProductMerchantScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _commissionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة منتج جديد (خاص بالتجار)'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.orange[50], borderRadius: BorderRadius.circular(8)),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'تنبيه: يتم احتساب ربح ورسم منصة رزقي قدره (3,000 د.ع) على كل منتج جديد يعرضه التاجر.',
                      style: TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'اسم المنتج', prefixIcon: Icon(Icons.shopping_bag)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'سعر البيع (مثال: 30,000 د.ع)', prefixIcon: Icon(Icons.money)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commissionController,
              decoration: const InputDecoration(labelText: 'عمولة المسوق (مثال: 5,000 د.ع)', prefixIcon: Icon(Icons.card_giftcard)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                if (_titleController.text.isNotEmpty && _priceController.text.isNotEmpty) {
                  setState(() {
                    globalProducts.add(ProductItem(
                      title: _titleController.text,
                      price: _priceController.text,
                      commission: 'عمولة المسوق: ${_commissionController.text}',
                      sellerName: widget.merchantName,
                    ));
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إضافة المنتج بنجاح واقتطاع رسم المنصة (3,000 د.ع)!')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('نشر المنتج ودفع رسم المنصة (3,000 د.ع)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

// 6. صفحة المنتجات العامة
class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('كافة المنتجات المتاحة'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.68,
          ),
          itemCount: globalProducts.length,
          itemBuilder: (context, index) {
            return ProductCard(product: globalProducts[index]);
          },
        ),
      ),
    );
  }
}

// 7. صفحة حسابي
class ProfileScreen extends StatelessWidget {
  final String userName;
  final bool isMerchant;

  const ProfileScreen({super.key, required this.userName, required this.isMerchant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حسابي والخدمات'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.teal,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Text('$userName ${isMerchant ? "(حساب تاجر)" : "(حساب مسوق)"}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            if (isMerchant)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('إضافة منتج جديد كتاجر (+3,000 د.ع للمنصة)'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddProductMerchantScreen(merchantName: userName)),
                  );
                },
              ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('تسجيل الخروج', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// بطاقة عرض المنتج
class ProductCard extends StatelessWidget {
  final ProductItem product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, spreadRadius: 1)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.teal[50], borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
              child: const Center(child: Icon(Icons.shopping_bag, size: 40, color: Colors.teal)),
            ),
          ),
          Padding(
            padding
