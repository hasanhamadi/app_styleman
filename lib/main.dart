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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ۱. ایجاد نمونه‌های ریپازیتوری
    final apiService = ApiService();
    final productRepository = ProductRepository(apiService);
    final authRepository = AuthRepository();

    return MultiRepositoryProvider(
      // ۲. تزریق ریپازیتوری‌ها (برای حل خطای ProviderNotFound در صفحه جستجو)
      providers: [
        RepositoryProvider<ProductRepository>.value(value: productRepository),
        RepositoryProvider<AuthRepository>.value(value: authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(productRepository)..add(LoadProductsEvent()),
          ),
          BlocProvider<NavigationCubit>(
            create: (context) => NavigationCubit(),
          ),
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
            '/auth': (context) => AuthPage(),
            '/home': (context) => const MainWrapper(),
          },
        ),
      ),
    );
  }
}
