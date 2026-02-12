import 'package:app_styleman/products/api_service.dart';
import 'package:app_styleman/products/product_bloc.dart';
import 'package:app_styleman/products/product_repository.dart';
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
    final apiService = ApiService();
    final productRepository = ProductRepository(apiService);

    return MultiBlocProvider(
      providers: [
        // بلاک محصولات (از قبل داشتید)
        BlocProvider<ProductBloc>(
          create: (context) => ProductBloc(productRepository)..add(LoadProductsEvent()),
        ),
        // کیوبیت ناوبری (جدید)
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
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
          '/home': (context) => const MainWrapper(), // تغییر مسیر به Wrapper
        },
      ),
    );
  }
}