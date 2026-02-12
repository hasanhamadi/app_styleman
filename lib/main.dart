import 'package:app_styleman/products/api_service.dart';
import 'package:app_styleman/products/product_bloc.dart';
import 'package:app_styleman/products/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // اضافه شد



// ایمپورت صفحات
import 'Splash Screen/onboarding_screen.dart';
import 'Splash Screen/splash_screen.dart';
import 'home_screen.dart';
import 'products/product_list_screen.dart'; // مسیر صفحه لیست محصولات شما

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ایجاد نمونه‌های مورد نیاز برای تزریق به Bloc
    final apiService = ApiService();
    final productRepository = ProductRepository(apiService);

    return MultiBlocProvider(
      // تعریف Bloc در بالاترین سطح برای دسترسی در کل اپلیکیشن
      providers: [
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(productRepository)..add(LoadProductsEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Vazir',
          useMaterial3: true, // استفاده از تم مدرن نسخه ۳
        ),
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
          '/home': (context) => const ProductListScreen(), // صفحه اصلی شما لیست محصولات است
        },
      ),
    );
  }
}