import 'package:flutter/material.dart';

class ControlButtonScreen extends StatefulWidget {
  const ControlButtonScreen({Key? key}) : super(key: key);

  @override
  State<ControlButtonScreen> createState() => _ControlButtonScreenState();
}

class _ControlButtonScreenState extends State<ControlButtonScreen> {
  // متغير الحالة للتحكم في ظهور أو تغيير العنصر/الصورة
  bool _isActivated = false;

  // دالة زر التحكم المحدثة لتجنب مشاكل ثبات الواجهة
  void _toggleState() {
    setState(() {
      _isActivated = !_isActivated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم - تطبيق رزقي'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // حاوية لتغيير الصورة أو العنصر بسلاسة عند الضغط
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: _isActivated ? Colors.green.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _isActivated ? Colors.green : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    _isActivated ? Icons.check_circle_outline : Icons.image_outlined,
                    size: 80,
                    color: _isActivated ? Colors.green : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // نص توضيحي لتأكيد تغير الحالة
              Text(
                _isActivated ? 'تم تفعيل التحكم وتحديث الواجهة بنجاح!' : 'الصورة بالحالة الافتراضية، اضغط للتحكم.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _isActivated ? Colors.green.shade700 : Colors.black87,
                ),
              ),
              const SizedBox(height: 32),
              // زر التحكم المحدث
              ElevatedButton.icon(
                onPressed: _toggleState,
                icon: Icon(_isActivated ? Icons.refresh : Icons.play_arrow),
                label: Text(_isActivated ? 'إعادة ضبط الحالة' : 'اضغط للتحكم'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isActivated ? Colors.orange : Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
