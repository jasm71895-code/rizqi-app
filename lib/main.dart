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

  ProductItem({
    required this.title,
    required this.price,
    required this.commission,
    required this.sellerName,
    required this.imageUrl,
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

// قائمة المنتجات الابتدائية
List<ProductItem> globalProducts = [
  ProductItem(
    title: 'سماعات بلوتوث ذكية',
    price: '35,000 د.ع',
    commission: '5,000 د.ع',
    sellerName: 'متجر التقنية',
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=500',
  ),
  ProductItem(
    title: 'حقيبة ظهر أنيقة',
    price: '25,000 د.ع',
    commission: '4,000 د.ع',
    sellerName: 'أزياء بغداد',
    imageUrl: 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=500',
  ),
];

List<AdBanner> globalAds = [
  AdBanner(title: '🔥 عروض الشهر للمسوقين', description: 'ضاعفي أرباحكِ هذا الأسبوع مع نسب عمولة مضاعفة.', backgroundColor: Colors.teal),
  AdBanner(title: '📢 إشعار هام للتجار', description: 'تخفيض رسم عرض المنتجات لفترة محدودة عبر منصة رزقي.', backgroundColor: Colors.orange),
];

List<AppNotification> globalNotifications = [
  AppNotification(title: 'طلب جديد!', description: 'تم تسجيل طلب جديد على منتج: سماعات بلوتوث.', time: 'منذ 5 دقائق'),
  AppNotification(title: 'مرحباً بكِ في رزقي', description: 'تم تفعيل حسابكِ بنجاح في المنصة التجارية.', time: 'منذ ساعة'),
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
              const Text('منصة رزقي التجارية | RIZQI', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal)),
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
                        const SnackBar(content: Text('الرجاء إدخال الاسم أو اسم المتجر')),
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
      if (widget.isMerchant) const MerchantAnalyticsScreen() else const MarketerWalletScreen(),
      const SupportAIScreen(), // الدعم والشكاوى بالذكاء الاصطناعي
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
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'الرئيسية'),
          const BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), activeIcon: Icon(Icons.shopping_bag), label: 'المنتجات'),
          BottomNavigationBarItem(
            icon: Icon(widget.isMerchant ? Icons.analytics_outlined : Icons.account_balance_wallet_outlined),
            activeIcon: Icon(widget.isMerchant ? Icons.analytics : Icons.account_balance_wallet),
            label: widget.isMerchant ? 'التحليلات' : 'محفظتي',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.smart_toy_outlined), activeIcon: Icon(Icons.smart_toy), label: 'الدعم الذكي'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'حسابي'),
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
        title: Text('أهلاً، $userName ${isMerchant ? '(تاجر)' : '(مسوق)'}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
                        Text(ad.title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(ad.description, style: const TextStyle(color: Colors.white70, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text('أحدث المنتجات المتوفرة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.60,
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

// 1. لوحة تحليل المبيعات والأرباح الخاصة بالتجار
class MerchantAnalyticsScreen extends StatelessWidget {
  const MerchantAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة تحليلات المبيعات والأرباح'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('ملخص الأداء التجاري لهذا الشهر:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildMetricCard('إجمالي المبيعات', '1,450,000 د.ع', Icons.trending_up, Colors.teal)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricCard('الطلبات النشطة', '14 طلباً', Icons.shopping_cart, Colors.orange)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildMetricCard('المنتجات المعروضة', '${globalProducts.length} منتجات', Icons.inventory, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildMetricCard('أرباح الصافي', '1,220,000 د.ع', Icons.account_balance_wallet, Colors.green)),
              ],
            ),
            const SizedBox(height: 24),
            const Text('المنتجات الأكثر طلباً:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...globalProducts.map((p) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: const Icon(Icons.star, color: Colors.amber),
                title: Text(p.title),
                subtitle: Text('السعر: ${p.price}'),
                trailing: const Text('مبيع ممتاز', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

// 2. محفظة الأرباح للمسوقين وروابط الترويج
class MarketerWalletScreen extends StatelessWidget {
  const MarketerWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('محفظة الأرباح والعمولات'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.teal, borderRadius: BorderRadius.circular(16)),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('إجمالي الأرباح القابلة للسحب', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 8),
                  Text('45,000 د.ع', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text('العمولات المعلقة: 15,000 د.ع', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تقديم طلب سحب الأرباح بنجاح عبر زين كاش!')));
              },
              icon: const Icon(Icons.payment),
              label: const Text('طلب سحب الأرباح'),
            ),
            const SizedBox(height: 24),
            const Text('روابط منتجاتك للتسويق بالعمولة:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...globalProducts.map((p) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('عمولتك: ${p.commission}', style: const TextStyle(color: Colors.orange)),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: 'https://rizqi-app.com/share?product=${p.title}'));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ رابط الترويج الخاص بك بنجاح!')));
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('نسخ رابط الترويج الخاص بي'),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}

// 3. شاشة إضافة المنتجات والأسعار والصور (خاصة بالتجار)
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
  final _imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة منتج جديد (الرسم: 3,000 د.ع)'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('أدخل تفاصيل المنتج الجديد لعرضه للتاجر والمسوقين:', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'اسم المنتج', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'سعر المنتج (مثال: 40,000 د.ع)', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _commissionController, decoration: const InputDecoration(labelText: 'عمولة المسوق (مثال: 5,000 د.ع)', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _imageController, decoration: const InputDecoration(labelText: 'رابط صورة المنتج (URL)', border: OutlineInputBorder(), hintText: 'https://...')),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                if (_titleController.text.isNotEmpty && _priceController.text.isNotEmpty) {
                  setState(() {
                    globalProducts.add(ProductItem(
                      title: _titleController.text,
                      price: _priceController.text,
                      commission: _commissionController.text.isNotEmpty ? _commissionController.text : '5,000 د.ع',
                      sellerName: widget.merchantName,
                      imageUrl: _imageController.text.isNotEmpty ? _imageController.text : 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=500',
                    ));
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تمت إضافة المنتج بنجاح ونشره في المنصة!')));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('الرجاء إكمال الحقول الأساسية')));
                }
              },
              child: const Text('نشر المنتج ودفع الرسم (3,000 د.ع)'),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. شاشة الشكاوي والدعم بالذكاء الاصطناعي
class SupportAIScreen extends StatefulWidget {
  const SupportAIScreen({super.key});

  @override
  State<SupportAIScreen> createState() => _SupportAIScreenState();
}

class _SupportAIScreenState extends State<SupportAIScreen> {
  final List<ChatMessage> _messages = [
    ChatMessage(text: 'أهلاً بكِ في مركز الشكاوى والدعم الذكي لمنصة رزقي 🤖.\nكيف يمكنني مساعدتكِ اليوم في حل أي مشكلة أو استفسار؟', isUser: false),
  ];
  final _textController = TextEditingController();

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;
    final userText = _textController.text;
    setState(() {
      _messages.add(ChatMessage(text: userText, isUser: true));
      _textController.clear();
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      String aiReply = 'تم تسجيل شكواكِ بنجاح والتحقق منها آلياً. نعمل على معالجة طلبكِ وحله في أسرع وقت.';
      if (userText.contains('توصيل') || userText.contains('شحن')) {
        aiReply = 'بخصوص الشحن والتوصيل: يتم تحديث حالة الطلبات خلال 24 ساعة عبر فريق العمل في بغداد والمحافظات.';
      } else if (userText.contains('فلوس') || userText.contains('أرباح') || userText.contains('عمولة')) {
        aiReply = 'أرباحكِ وعمولاتكِ مسجلة بنظام العمولة في حسابكِ، ويمكنكِ سحبها بكل سهولة من تبويب المحفظة.';
      }

      setState(() {
        _messages.add(ChatMessage(text: aiReply, isUser: false));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الشكاوى والدعم بالذكاء الاصطناعي'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
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
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 280),
                    decoration: BoxDecoration(
                      color: msg.isUser ? Colors.teal : Colors.teal[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
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
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'اكتبي شكواكِ أو استفساركِ هنا...',
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

// 5. الإعلانات والتنبيهات
class AddAdScreen extends StatefulWidget {
  const AddAdScreen({super.key});

  @override
  State<AddAdScreen> createState() => _AddAdScreenState();
}

class _AddAdScreenState extends State<AddAdScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة إعلان جديد للمنصة'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: 'عنوان الإعلان', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _descController, decoration: const InputDecoration(labelText: 'تفاصيل الإعلان', border: OutlineInputBorder())),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  setState(() {
                    globalAds.add(AdBanner(title: _titleController.text, description: _descController.text, backgroundColor: Colors.blueGrey));
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نشر الإعلان بنجاح')));
                }
              },
              child: const Text('نشر الإعلان'),
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

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('جميع المنتجات'), backgroundColor: Colors.teal, foregroundColor: Colors.white),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.60),
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
            Text(isMerchant ? 'حساب تاجر معتمد' : 'حساب مسوق معتمد', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),
            if (isMerchant) ...[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddProductMerchantScreen(merchantName: userName))),
                child: const Text('إضافة منتج جديد (مع السعر والصورة)'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddAdScreen())),
                child: const Text('إضافة إعلان تجاري'),
              ),
            ] else ...[
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('أنتِ مسجلة كمسوقة في منصة رزقي. تصفحي المنتجات، انسخي روابط الترويج، وضاعفي أرباحكِ الشهرية بسهولة!'),
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
                Text('عمولة المسوق: ${product.commission}', style: const TextStyle(color: Colors.orange, fontSize: 10)),
                const SizedBox(height: 2),
                Text('التاجر: ${product.sellerName}', style: const TextStyle(color: Colors.grey, fontSize: 9)),
                if (!isMerchant) ...[
                  const SizedBox(height: 6),
                  SizedBox(
                    width: double.infinity,
                    height: 28,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[50], foregroundColor: Colors.teal, elevation: 0, padding: EdgeInsets.zero),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: 'https://rizqi-app.com/share?product=${product.title}'));
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ رابط المنتج للتسويق!')));
                      },
                      child: const Text('نسخ رابط الترويج', style: TextStyle(fontSize: 10)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
