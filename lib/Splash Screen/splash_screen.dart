import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    // ۳ ثانیه توقف برای نمایش اسپلش
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    // چک کردن اینکه آیا برای بار اول است یا خیر
    final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (mounted) {
      if (isFirstTime) {
        // اگر بار اول است -> برو به آنبوردینگ
        Navigator.pushReplacementNamed(context, '/onboarding');
      } else {
        // اگر قبلاً دیده -> مستقیم برو به خانه
        Navigator.pushReplacementNamed(context, '/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF1e3c72),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("فروشگاه من", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}