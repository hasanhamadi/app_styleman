import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// ایمپورت‌های سرویس و ریپازیتوری
import 'package:app_styleman/products/api_service.dart';
import 'package:app_styleman/products/product_repository.dart';
import 'package:app_styleman/uesr/auth_repository.dart';
import 'package:app_styleman/Card/cart_repository.dart';
import 'package:app_styleman/Card/cart_remote_service.dart';
// --- اضافه‌شده برای سفارشات ---
import 'package:app_styleman/Order/order_service.dart';
import 'package:app_styleman/Order/iorder_repository.dart';

// ایمپورت‌های بلاک (Logic)
import 'package:app_styleman/products/product_bloc.dart';
import 'package:app_styleman/uesr/auth_bloc.dart';
import 'package:app_styleman/Card/cart_bloc.dart';
import 'package:app_styleman/BottomNavBar/navigation_cubit.dart';
// --- اضافه‌شده برای سفارشات ---
import 'package:app_styleman/Order/order_bloc.dart';

// ایمپورت صفحات (UI)
import 'package:app_styleman/uesr/auth_page.dart';
import 'package:app_styleman/BottomNavBar/main_wrapper.dart';
import 'package:app_styleman/Splash Screen/onboarding_screen.dart';
import 'package:app_styleman/Splash Screen/splash_screen.dart';
import 'package:app_styleman/Order/order_list_page.dart'; // صفحه لیست سفارشات برای مسیردهی

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

    // --- اضافه‌شده برای سفارشات ---
    final orderService = OrderService(); // سرویسی که قبلاً بروزرسانی کردیم
    final orderRepository = OrderRepository(orderService);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>.value(value: productRepository),
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<CartRepository>.value(value: cartRepository),
        // --- تزریق ریپازیتوری سفارشات ---
        RepositoryProvider<IOrderRepository>.value(value: orderRepository),
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
          // --- تزریق بلاک سفارشات ---
          BlocProvider<OrderBloc>(
            create: (context) => OrderBloc(orderRepository),
          ),
        ],
        // ۲. استفاده از BlocListener برای هماهنگی Auth و Cart
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              print("🟢 [Main] User Authenticated: ${state.user.id}. Starting Cart...");
              context.read<CartBloc>().add(CartStarted(userId: state.user.id));

              // --- اضافه شده: بارگذاری سفارشات کاربر بلافاصله بعد از لاگین ---
              context.read<OrderBloc>().add(LoadOrdersEvent());
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
              // --- مسیر صفحه سفارشات ---
              '/orders': (context) => const OrderListPage(),
            },
          ),
        ),
      ),
    );
  }
}