import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Card/cart_bloc.dart';
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
    // گرفتن وضعیت لاگین برای ارسال آیدی به سبد خرید
    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated) {
      // حالا دیگر خطای 'userId' وجود ندارد چون در فایل ایونت تعریفش کردیم
      context.read<CartBloc>().add(CartStarted(userId: authState.user.id));
    }

    final List<Widget> _pages = [
      const ProductListScreen(),
      const SearchScreen(),
      const CartScreen(),
      BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            return ProfilePage(user: state.user);
          }
          return const AuthPage();
        },
      ),
    ];

    return Scaffold(
      body: SafeArea(
        top: false,
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
