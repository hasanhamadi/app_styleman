import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // انتقال خودکار بعد از 3 ثانیه
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 1) پس‌زمینه مینیمال و مدرن (گرادینت)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // لوگوی فرضی یا آیکون برند
              Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.white),
              SizedBox(height: 20),

              // 3) پیام خوش‌آمدگویی شیک
              Text(
                "سلام؛ خوش آمدید",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "تجربه‌ای نو در خرید آنلاین",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),

              SizedBox(height: 50),

              // 2) انیمیشن لودینگ نرم
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// صفحه اصلی مقصد
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("صفحه اصلی فروشگاه")),
      body: Center(child: Text("به فروشگاه ما خوش آمدید!")),
    );
  }
}