import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_styleman/products/product_bloc.dart';
import 'package:app_styleman/products/product_detail_screen.dart';
import '../Order/order_list_page.dart';

// نکته: فرض شده BannerBloc را برای دریافت بنرها از API پیاده‌سازی کرده‌اید
// import 'package:app_styleman/banner/banner_bloc.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final PageController _bannerController = PageController(viewportFraction: 0.9);
  int _currentBannerPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // تایمر اسلایدر خودکار برای بنرها
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_bannerController.hasClients) {
        _currentBannerPage = (_currentBannerPage + 1) % 3; // تعداد بنرهای فرضی
        _bannerController.animateToPage(
          _currentBannerPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<ProductBloc>().add(RefreshProductsEvent());
            // context.read<BannerBloc>().add(BannerLoadStarted()); // اگر بنر دارید
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // --- ۱. AppBar حرفه‌ای و مینیمال ---
              _buildAppBar(context),

              // --- ۲. اسلایدر بنر مدرن ---
              SliverToBoxAdapter(child: _buildBannerSection()),

              // --- ۳. عنوان بخش محصولات جدید ---
              SliverToBoxAdapter(child: _buildSectionTitle("جدیدترین محصولات")),

              // --- ۴. گرید محصولات با BlocBuilder ---
              _buildProductGrid(),

              const SliverToBoxAdapter(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      floating: true,
      elevation: 0,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
        onPressed: () {}, // بخش اعلانات
      ),
      title: const Text(
        "Setayesh",
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
          fontSize: 22,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.receipt_long_rounded, color: Colors.black87),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OrderListPage()),
          ),
        ),
      ],
    );
  }

  Widget _buildBannerSection() {
    return Column(
      children: [
        const SizedBox(height: 15),
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (index) => setState(() => _currentBannerPage = index),
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: NetworkImage("https://picsum.photos/800/400"), // آدرس از مدل بنر
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 6,
            width: _currentBannerPage == index ? 18 : 6,
            decoration: BoxDecoration(
              color: _currentBannerPage == index ? Colors.black : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10),
            ),
          )),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 30, 16, 15),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Container(width: 35, height: 3, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10))),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
        } else if (state is ProductError) {
          return SliverFillRemaining(child: Center(child: Text(state.message)));
        } else if (state is ProductLoaded) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) => _ProductCard(product: state.products[index]),
                childCount: state.products.length,
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final dynamic product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 5)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.network(
                      product.mainImageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withAlpha(200),
                      radius: 15,
                      child: const Icon(Icons.favorite_border_rounded, size: 16, color: Colors.black87),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("${product.price} تومان", style: TextStyle(color: Colors.blueGrey.shade700, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}