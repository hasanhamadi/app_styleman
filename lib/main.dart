import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- ایمپورت‌های جدید بنر ---
import 'package:app_styleman/banner/banner_service.dart';
import 'package:app_styleman/banner/banner_repository.dart';
import 'package:app_styleman/banner/banner_bloc.dart';

// ایمپورت‌های سرویس و ریپازیتوری قبلی
import 'package:app_styleman/products/api_service.dart';
import 'package:app_styleman/products/product_repository.dart';
import 'package:app_styleman/uesr/auth_repository.dart';
import 'package:app_styleman/Card/cart_repository.dart';
import 'package:app_styleman/Card/cart_remote_service.dart';
import 'package:app_styleman/Order/order_service.dart';
import 'package:app_styleman/Order/iorder_repository.dart';

// ایمپورت‌های بلاک (Logic)
import 'package:app_styleman/products/product_bloc.dart';
import 'package:app_styleman/uesr/auth_bloc.dart';
import 'package:app_styleman/Card/cart_bloc.dart';
import 'package:app_styleman/BottomNavBar/navigation_cubit.dart';
import 'package:app_styleman/Order/order_bloc.dart';

// ایمپورت صفحات (UI)
import 'package:app_styleman/uesr/auth_page.dart';
import 'package:app_styleman/BottomNavBar/main_wrapper.dart';
import 'package:app_styleman/Splash Screen/onboarding_screen.dart';
import 'package:app_styleman/Splash Screen/splash_screen.dart';
import 'package:app_styleman/Order/order_list_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ۱. مقداردهی اولیه‌ی سرویس‌ها و ریپازیتوری‌ها
    final apiService = ApiService(); // حاوی Dio برای استفاده مشترک

    // سرویس و ریپازیتوری بنر
    final bannerService = BannerService(apiService.dio);
    final bannerRepository = BannerRepository(bannerService);

    final productRepository = ProductRepository(apiService);
    final authRepository = AuthRepository();
    final cartService = CartRemoteService(apiService.dio);
    final cartRepository = CartRepositoryImpl(cartService);
    final orderService = OrderService();
    final orderRepository = OrderRepository(orderService);

    return MultiRepositoryProvider(
      providers: [
        // تزریق ریپازیتوری بنر (حل مشکل لایه داده)
        RepositoryProvider<BannerRepository>.value(value: bannerRepository),
        RepositoryProvider<ProductRepository>.value(value: productRepository),
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<CartRepository>.value(value: cartRepository),
        RepositoryProvider<IOrderRepository>.value(value: orderRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          // تزریق بلاک بنر (حل قطعی خطای قرمز تصویر شما)
          BlocProvider<BannerBloc>(
            create: (context) => BannerBloc(bannerRepository),
          ),
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
          BlocProvider<OrderBloc>(
            create: (context) => OrderBloc(orderRepository),
          ),
        ],
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthAuthenticated) {
              context.read<CartBloc>().add(CartStarted(userId: state.user.id));
              context.read<OrderBloc>().add(LoadOrdersEvent());
            }
          },
          child: MaterialApp(
            title: 'Setayesh Styleman',
            debugShowCheckedModeBanner: false,
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
            initialRoute: '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/onboarding': (context) => const OnboardingScreen(),
              '/auth': (context) => AuthPage(),
              '/home': (context) => const MainWrapper(),
              '/orders': (context) => const OrderListPage(),
            },
          ),
        ),
      ),
    );
  }
}