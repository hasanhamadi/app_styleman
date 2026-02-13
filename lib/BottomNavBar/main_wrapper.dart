import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Card/cart_screen.dart';
import '../products/product_list_screen.dart';
import '../search_bar/search_screen.dart';
import '../uesr/auth_bloc.dart';
import '../uesr/auth_page.dart';
import '../uesr/profile_page.dart';
import 'custom_bottom_navbar.dart';
import 'navigation_cubit.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // تعریف صفحات به صورت جداگانه برای خوانایی بیشتر
    final List<Widget> _pages = [
      const ProductListScreen(),
      const SearchScreen(), // حالا این صفحه به RepositoryProvider در main دسترسی دارد
      const CartScreen(),
      // مدیریت هوشمند وضعیت پروفایل
      BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return ProfilePage(user: state.user);
          }
          // اگر کاربر لاگین نکرده باشد، صفحه ورود نمایش داده می‌شود
          return const AuthPage();
        },
      ),
    ];

    return Scaffold(
      // استفاده از SafeArea برای جلوگیری از تداخل با لبه‌های گوشی
      body: SafeArea(
        top: false, // اجازه می‌دهیم محتوا زیر Status Bar برود اگر لازم بود
        child: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            return IndexedStack(
              index: state.currentIndex,
              children: _pages,
            );
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}