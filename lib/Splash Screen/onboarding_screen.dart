import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // لیست داده‌های اسلایدها
  final List<OnboardingData> _slides = [
    OnboardingData(
      title: "جستجوی هوشمند",
      description: "هر چی لازم داری رو با یک کلیک پیدا کن و لذت ببر.",
      icon: Icons.search_rounded,
    ),
    OnboardingData(
      title: "پرداخت امن",
      description: "با خیال راحت و با درگاه‌های بانکی معتبر خرید کن.",
      icon: Icons.account_balance_wallet_rounded,
    ),
    OnboardingData(
      title: "ارسال سریع",
      description: "ما سفارشت رو در کمترین زمان به دستت می‌رسونیم.",
      icon: Icons.local_shipping_rounded,
    ),
  ];

  // تابع ذخیره‌سازی و خروج
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false); // علامت‌گذاری به عنوان دیده شده

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLastPage = _currentPage == _slides.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // دکمه رد کردن (فقط اگر صفحه آخر نباشد)
          if (!isLastPage)
            TextButton(
              onPressed: _completeOnboarding, // مستقیم به خانه و ذخیره وضعیت
              child: const Text(
                "رد کردن",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentPage = index),
              itemCount: _slides.length,
              itemBuilder: (context, index) => _buildSlide(_slides[index]),
            ),
          ),

          // نقاط وضعیت (Indicator)
          _buildBullets(),

          const SizedBox(height: 50),

          // دکمه عملیاتی (بعدی / بزن بریم)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1e3c72),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                onPressed: () {
                  if (isLastPage) {
                    _completeOnboarding();
                  } else {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                child: Text(
                  isLastPage ? "بزن بریم!" : "بعدی",
                  style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildBullets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        _slides.length,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 8,
          width: _currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == index ? const Color(0xFF1e3c72) : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildSlide(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color(0xFF1e3c72).withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(data.icon, size: 100, color: const Color(0xFF1e3c72)),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF333333)),
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          ),
        ],
      ),
    );
  }
}