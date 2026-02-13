import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



import '../products/product_list_screen.dart';
import '../uesr/auth_bloc.dart';
import '../uesr/auth_page.dart';
import '../uesr/profile_page.dart';
import 'custom_bottom_navbar.dart';
import 'navigation_cubit.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // ایجاد لیست صفحات به صورت داینامیک برای چک کردن وضعیت لاگین
    final List<Widget> pages = [
      const ProductListScreen(), // صفحه اول
      const Center(child: Text('صفحه جستجو')), // صفحه دوم

      // صفحه سوم: مدیریت هوشمند بین پروفایل و صفحه ورود
      BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return ProfilePage(user: state.user);
          } else {
            return AuthPage();
          }
        },
      ),
    ];

    return Scaffold(
      body: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          return IndexedStack(
            index: state.currentIndex,
            children: pages,
          );
        },
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}