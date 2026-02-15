import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ایمپورت‌های سرویس و ریپازیتوری
import 'package:app_styleman/products/api_service.dart';
import 'package:app_styleman/products/product_repository.dart';
import 'package:app_styleman/uesr/auth_repository.dart';
import 'package:app_styleman/Card/cart_repository.dart';
import 'package:app_styleman/Card/cart_remote_service.dart';

// ایمپورت‌های بلاک (Logic)
import 'package:app_styleman/products/product_bloc.dart';
import 'package:app_styleman/uesr/auth_bloc.dart';
import 'package:app_styleman/Card/cart_bloc.dart';
import 'package:app_styleman/BottomNavBar/navigation_cubit.dart';

// ایمپورت صفحات (UI)
import 'package:app_styleman/uesr/auth_page.dart';
import 'package:app_styleman/BottomNavBar/main_wrapper.dart';
import 'package:app_styleman/Splash Screen/onboarding_screen.dart';
import 'package:app_styleman/Splash Screen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ۱. مقداردهی اولیه‌ی سرویس‌ها و ریپازیتوری‌ها
    final apiService = ApiService();
    final productRepository = ProductRepository(apiService);
    final authRepository = AuthRepository();
    final cartService = CartRemoteService(apiService.dio);
    final cartRepository = CartRepositoryImpl(cartService);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>.value(value: productRepository),
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<CartRepository>.value(value: cartRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository),
          ),
          BlocProvider<ProductBloc>(
            create: (context) => ProductBloc(productRepository)..add(LoadProductsEvent()),
          ),
          BlocProvider<NavigationCubit>(
            create: (context) => NavigationCubit(),
          ),
          BlocProvider<CartBloc>(
            create: (context) => CartBloc(cartRepository),
          ),
        ],
        // ۲. استفاده از BlocListener برای هماهنگی Auth و Cart
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              // به محض لاگین موفق، سبد خرید را با آیدی کاربر استارت می‌زنیم
              print("🟢 [Main] User Authenticated: ${state.user.id}. Starting Cart...");
              context.read<CartBloc>().add(CartStarted(userId: state.user.id));
            }
          },
          child: MaterialApp(
            title: 'Styleman App',
            debugShowCheckedModeBanner: false,

            // ۳. تنظیمات زبان و فونت فارسی
            theme: ThemeData(
              fontFamily: 'Vazir',
              useMaterial3: true,
              scaffoldBackgroundColor: Colors.white,
            ),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('fa', 'IR')],
            locale: const Locale('fa', 'IR'),

            // ۴. مسیرها (Routes)
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/auth': (context) => AuthPage(),
              '/home': (context) => const MainWrapper(),
            },
          ),
        ),
      ),
    );
  }
}