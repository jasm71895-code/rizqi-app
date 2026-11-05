import 'package:flutter/material.dart';

void main() {
  runApp(const RizqiApp());
}

class ProductItem {
  final String title;
  final String price;
  final String commission;
  final String sellerName;

  ProductItem({
    required this.title,
    required this.price,
    required this.commission,
    required this.sellerName,
  });
}

class AdBanner {
  final String title;
  final String description;
  final Color backgroundColor;

  AdBanner({required this.title, required this.description, required this.backgroundColor});
}

class AppNotification {
  final String title;
  final String description;
  final String time;

  AppNotification({required this.title, required this.description, required this.time});
}

List<ProductItem> globalProducts = [
  ProductItem(title: 'سماعات بلوتوث ذكية', price: '35,000 د.ع', commission: 'عمولة المسوق: 5,000 د.ع', sellerName: 'متجر التقنية'),
  ProductItem(title: 'حقيبة ظهر أنيقة', price: '25,000 د.ع', commission: 'عمولة المسوق: 4,000 د.ع', sellerName: 'أزياء بغداد'),
];

List<AdBanner> globalAds = [
  AdBanner(title: '🔥 عروض الشهر للمسوقين', description: 'ضاعفي أرباحكِ هذا الأسبوع مع نسب عمولة مضاعفة.', backgroundColor: Colors.teal),
  AdBanner(title: '📢 إشعار هام للتجار', description: 'تخفيض رسم عرض المنتجات لفترة محدودة.', backgroundColor: Colors.orange),
];

List<AppNotification> globalNotifications = [
  AppNotification(title: 'طلب جديد!', description: 'تم تسجيل طلب جديد على منتج: سماعات بلوتوث.', time: 'منذ 5 دقائق'),
  AppNotification(title: 'مرحباً بكِ في رزقي', description: 'تم تفعيل حسابكِ بنجاح في المنصة.', time: 'منذ ساعة'),
];

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
              const Text('منصة رزقي | RIZQI', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal)),
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
          BottomNavigationBarItem(icon: Icon(Icons.smart_toy_outlined), activeIcon: Icon(Icons.smart_toy), label: 'الدعم'),
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
        title: Text('أهلاً، $userName ${isMerchant ? '(تاجر)' : ''}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('الإعلانات والعروض', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                        Text(ad.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(ad.description, style: const TextStyle(color: Colors.white70, fontSize: 12), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text('أحدث المنتجات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الإشعارات'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: globalNotifications.length,
        itemBuilder: (context, index) {
          final notif = globalNotifications[index];
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.teal, child: Icon(Icons.notifications, color: Colors.white)),
              title: Text(notif.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(notif.description),
                  const SizedBox(height: 4),
                  Text(notif.time, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class SupportAIScreen extends StatefulWidget {
  const SupportAIScreen({super.key});

  @override
  State<SupportAIScreen> createState() => _SupportAIScreenState();
}

class _SupportAIScreenState extends State<SupportAIScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'أهلاً بكِ في المساعد الذكي لـ منصة رزقي! 🤖', isUser: false),
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
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: 'تم استلام استفسارك وسيتم الرد فوريًا.', isUser: false));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المساعد الذكي'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
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
                    decoration: BoxDecoration(color: msg.isUser ? Colors.teal : Colors.teal[50], borderRadius: BorderRadius.circular(12)),
                    child: Text(msg.text, style: TextStyle(color: msg.isUser ? Colors.white : Colors.black87)),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _textController, decoration: const InputDecoration(hintText: 'اكتبي استفسارك...'))),
                IconButton(icon: const Icon(Icons.send, color: Colors.teal), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AddProductMerchantScreen extends StatefulWidget {
  final String merchantName;
  const AddProductMerchantScreen({super.key, required this.merchantName});

  @override
  State<AddProductMerchantScreen> createState() => _AddProductMerchantScreenState();
}

class _AddProductMerchantScreenState extends State<AddProductMerchantScreen> {
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة منتج جديد (الرسم: 3,000 د.ع)'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'اسم المنتج')),
            const SizedBox(height: 12),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'السعر')),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  setState(() {
                    globalProducts.add(ProductItem(title: _titleController.text, price: _priceController.text, commission: '5,000 د.ع', sellerName: widget.merchantName));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('نشر المنتج ودفع الرسم'),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('المنتجات'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.68),
        itemCount: globalProducts.length,
        itemBuilder: (context, index) => ProductCard(product: globalProducts[index]),
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
            const SizedBox(height: 24),
            if (isMerchant) ...[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductMerchantScreen(merchantName: userName))),
                child: const Text('إضافة منتج جديد (3,000 د.ع)'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductItem product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Container(decoration: BoxDecoration(color: Colors.teal[50], borderRadius: const BorderRadius.vertical(top: Radius.circular(12))), child: const Center(child: Icon(Icons.shopping_bag, size: 40, color: Colors.teal)))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1),
                Text(product.price, style: const TextStyle(color: Colors.teal, fontSize: 12)),
                Text('التاجر: ${product.sellerName}', style: const TextStyle(color: Colors.grey, fontSize: 9)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
