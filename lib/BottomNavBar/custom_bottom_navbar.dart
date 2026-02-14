import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_cubit.dart';
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, NavigationState>(
      builder: (context, state) {
        return BottomNavigationBar(
          currentIndex: state.currentIndex,
          onTap: (index) => context.read<NavigationCubit>().updateIndex(index),
          // تنظیم نوع برای نمایش بهتر وقتی تعداد آیتم‌ها زیاد می‌شود
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'خانه'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'جستجو'),

            // آیتم جدید: سبد خرید
            BottomNavigationBarItem(
                icon: Badge( // اضافه کردن بج برای تعداد محصولات (اختیاری)
                  label: Text('۰'),
                  child: Icon(Icons.shopping_cart_outlined),
                ),
                activeIcon: Icon(Icons.shopping_cart),
                label: 'سبد خرید'
            ),

            BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'پروفایل'),
          ],
        );
      },
    );
  }
}
