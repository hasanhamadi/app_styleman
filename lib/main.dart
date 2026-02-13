import 'package:app_styleman/products/api_service.dart';
import 'package:app_styleman/products/product_bloc.dart';
import 'package:app_styleman/products/product_repository.dart';
import 'package:app_styleman/uesr/auth_bloc.dart';
import 'package:app_styleman/uesr/auth_page.dart';
import 'package:app_styleman/uesr/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



// ایمپورت صفحات
import 'BottomNavBar/main_wrapper.dart';
import 'BottomNavBar/navigation_cubit.dart';
import 'Splash Screen/onboarding_screen.dart';
import 'Splash Screen/splash_screen.dart';
import 'products/product_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ایجاد نمونه‌های مورد نیاز
    final apiService = ApiService();
    final productRepository = ProductRepository(apiService);
    final authRepository = AuthRepository(); // اضافه شدن ریپازیتوری احراز هویت

    return MultiBlocProvider(
      providers: [
        // ۱. بلاک محصولات (بدون تغییر)
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(productRepository)..add(LoadProductsEvent()),
        ),
        // ۲. کیوبیت ناوبری (بدون تغییر)
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
        // ۳. اضافه شدن بلاک احراز هویت (هماهنگ شده)
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Vazir', useMaterial3: true),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('fa', 'IR')],
        locale: const Locale('fa', 'IR'),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/auth': (context) => AuthPage(), // روت جدید برای صفحه ورود
          '/home': (context) => const MainWrapper(),
        },
      ),
    );
  }
}