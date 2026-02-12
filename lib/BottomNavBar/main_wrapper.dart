import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../products/product_list_screen.dart';
import 'custom_bottom_navbar.dart';
import 'navigation_cubit.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const ProductListScreen(), // صفحه اول: لیست محصولات
      const Center(child: Text('صفحه جستجو')), // صفحه دوم
      const Center(child: Text('صفحه پروفایل')), // صفحه سوم
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