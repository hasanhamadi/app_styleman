import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_styleman/products/product_model.dart';
import 'package:app_styleman/Card/cart_bloc.dart';

import 'package:app_styleman/uesr/auth_bloc.dart';
import 'package:app_styleman/BottomNavBar/navigation_cubit.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? selectedSize;
  int activeIndex = 0;

  // تابع مدیریت افزودن به سبد خرید با دیباگ کامل
  void _handleAddToCart() {
    print("🔘 [UI] دکمه افزودن کلیک شد");

    final authState = context.read<AuthBloc>().state;

    if (authState is AuthAuthenticated) {
      print("👤 [UI] کاربر لاگین است: ${authState.user.id}");

      // ارسال ایونت به بلاک
      context.read<CartBloc>().add(
        CartItemAdded(product: widget.product),
      );

      // نمایش پیام موفقیت
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.product.name} به سبد خرید اضافه شد'),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'مشاهده سبد',
            textColor: Colors.white,
            onPressed: () {
              context.read<NavigationCubit>().updateIndex(2);
              Navigator.pop(context);
            },
          ),
        ),
      );
    } else {
      print("⚠️ [UI] کاربر لاگین نیست");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("لطفاً ابتدا وارد حساب کاربری خود شوید")),
      );
      Navigator.pushNamed(context, '/auth');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white.withOpacity(0.9),
            child: const BackButton(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSlider(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        "${widget.product.price} تومان",
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(widget.product.fit, style: TextStyle(color: Colors.grey.shade600, fontSize: 16)),
                  const Divider(height: 40, thickness: 1),
                  _buildSectionTitle("مشخصات فنی"),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildInfoBadge(Icons.checkroom_outlined, widget.product.material),
                      const SizedBox(width: 10),
                      _buildInfoBadge(Icons.straighten, widget.product.sizeGuide),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildSectionTitle("انتخاب سایز"),
                  const SizedBox(height: 15),
                  _buildSizeSelector(),
                  const SizedBox(height: 30),
                  _buildSectionTitle("توضیحات محصول"),
                  const SizedBox(height: 10),
                  Text(
                    widget.product.description,
                    style: TextStyle(color: Colors.grey.shade700, height: 1.6, fontSize: 15),
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAction(),
    );
  }

  Widget _buildImageSlider() {
    final allImages = [widget.product.mainImageUrl, ...widget.product.galleryUrls];
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.55,
          child: PageView.builder(
            onPageChanged: (index) => setState(() => activeIndex = index),
            itemCount: allImages.length,
            itemBuilder: (context, index) {
              return Image.network(allImages[index], fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image));
            },
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Row(
            children: List.generate(allImages.length, (index) => _buildDot(index)),
          ),
        ),
      ],
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(left: 5),
      height: 6,
      width: activeIndex == index ? 20 : 6,
      decoration: BoxDecoration(
        color: activeIndex == index ? Colors.black : Colors.black26,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
  }

  Widget _buildInfoBadge(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSizeSelector() {
    return Wrap(
      spacing: 12,
      children: widget.product.sizes.map((size) {
        bool isSelected = selectedSize == size;
        return GestureDetector(
          onTap: () => setState(() => selectedSize = size),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.white,
              border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              size,
              style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  // بررسی وضعیت لودینگ برای دکمه
                  bool isLoading = state is CartLoading;

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: (selectedSize == null || isLoading) ? null : _handleAddToCart,
                    child: isLoading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                        : Text(
                      selectedSize == null ? "سایز را انتخاب کنید" : "افزودن به سبد خرید",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}