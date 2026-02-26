import 'package:flutter/material.dart';
import 'package:app_styleman/products/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? selectedSize;
  String? selectedColor;
  int activeIndex = 0;
  final PageController _pageController = PageController();

  Color _getColorFromText(String colorName) {
    if (colorName.contains("مشکی")) return Colors.black;
    if (colorName.contains("سفید")) return Colors.white;
    if (colorName.contains("طوسی")) return Colors.grey;
    if (colorName.contains("آبی")) return Colors.blue;
    if (colorName.contains("سبز")) return Colors.green;
    if (colorName.contains("قرمز")) return Colors.red;
    if (colorName.contains("کرم")) return const Color(0xFFF5F5DC);
    if (colorName.contains("قهوه‌ای")) return Colors.brown;
    return Colors.grey.shade300;
  }

  bool _isSizeAvailable(String size) {
    String stockValue = "";
    switch (size.toUpperCase()) {
      case 'S': stockValue = widget.product.s; break;
      case 'M': stockValue = widget.product.m; break;
      case 'L': stockValue = widget.product.l; break;
      case 'XL': stockValue = widget.product.xl; break;
      default: return true;
    }
    int? stock = int.tryParse(stockValue);
    return (stock == null) ? false : stock > 0;
  }

  @override
  Widget build(BuildContext context) {
    final allImages = [widget.product.mainImageUrl, ...widget.product.galleryUrls];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // محتوای اصلی اسکرول شونده
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // بخش تصویر محصول (جایگزین SliverAppBar)
                _buildProductImageHeader(allImages),

                // گالری تصاویر کوچک
                SliverToBoxAdapter(
                  child: _buildThumbnailsGallery(allImages),
                ),

                // جزئیات محصول
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleSection(),
                        const SizedBox(height: 30),
                        _buildDynamicSectionTitle("رنگ:", selectedColor),
                        const SizedBox(height: 15),
                        _buildColorSelector(),
                        const SizedBox(height: 30),
                        _buildDynamicSectionTitle("سایز:", selectedSize),
                        const SizedBox(height: 15),
                        _buildSizeSelector(),
                        const SizedBox(height: 35),
                        _buildSectionTitle("مشخصات کالا"),
                        _buildSpecCard(),
                        const SizedBox(height: 35),
                        _buildSectionTitle("توضیحات"),
                        Text(
                          widget.product.description,
                          style: const TextStyle(color: Colors.black54, fontSize: 14, height: 1.8),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // اپ بار ثابت با پس‌زمینه سفید
            _buildFixedAppBar(),

            // دکمه افزودن به سبد خرید ثابت در پایین
            _buildStickyBottomAction(),
          ],
        ),
      ),
    );
  }

  // ویجت اپ بار ثابت
  Widget _buildFixedAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.menu, color: Colors.black, size: 26),
                onPressed: () {},
              ),
              const Spacer(),
              Image.network(
                'https://wigo-mod.com/wp-content/uploads/2023/04/wigo-logo-new.png',
                height: 28,
                errorBuilder: (context, error, stackTrace) => const Text("WIGO",
                    style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ),
              const Spacer(),
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 26),
                    onPressed: () {},
                  ),
                  Positioned(
                    top: 10,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: Color(0xFF0091FF), shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: const Text('۰',
                          style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // بخش نمایش تصویر اصلی محصول
  Widget _buildProductImageHeader(List<String> images) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.65,
        margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 60),
        padding: const EdgeInsets.all(15.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Stack(
            fit: StackFit.expand,
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => activeIndex = i),
                itemCount: images.length,
                itemBuilder: (context, index) => Image.network(images[index], fit: BoxFit.cover),
              ),
              Positioned(
                bottom: 15,
                left: 15,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)]
                  ),
                  child: const Icon(Icons.fullscreen, color: Colors.black, size: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // گالری تصاویر کوچک پایین عکس اصلی
  Widget _buildThumbnailsGallery(List<String> allImages) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: allImages.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
          child: Container(
            width: 85,
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                  color: activeIndex == index ? Colors.black : Colors.transparent,
                  width: 2),
              image: DecorationImage(
                  image: NetworkImage(allImages[index]), fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSizeSelector() {
    return Wrap(
      spacing: 12, runSpacing: 12,
      children: widget.product.sizes.map((size) {
        bool available = _isSizeAvailable(size);
        bool isSelected = selectedSize == size;
        return GestureDetector(
          onTap: available ? () => setState(() => selectedSize = size) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isSelected ? Colors.black : Colors.white,
              border: Border.all(color: available ? Colors.black12 : Colors.grey.shade200),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) const Icon(Icons.check, color: Colors.white, size: 16),
                if (isSelected) const SizedBox(width: 5),
                Text(size, style: TextStyle(
                  color: isSelected ? Colors.white : (available ? Colors.black : Colors.grey.shade300),
                  fontWeight: FontWeight.bold,
                )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSpecCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.black.withOpacity(0.03)),
      ),
      child: Column(
        children: [
          _buildSpecRow("جنس کالا", widget.product.material),
          _buildSpecRow("نوع یقه", widget.product.neckline),
          _buildSpecRow("نوع آستین", widget.product.sleeveType),
          _buildSpecRow("تن‌خور", widget.product.fit),
          _buildSpecRow("کد محصول", widget.product.id.substring(0, 8), isLast: true, isCode: true),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, {bool isLast = false, bool isCode = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: isLast ? BorderSide.none : BorderSide(color: Colors.grey.shade200, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isCode) Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          Text(label, style: const TextStyle(color: Colors.black45, fontSize: 14)),
          if (!isCode) Text(value.isEmpty ? "نامشخص" : value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildColorSelector() {
    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.product.colors.length,
        itemBuilder: (context, index) {
          final colorName = widget.product.colors[index];
          final colorValue = _getColorFromText(colorName);
          bool isSelected = selectedColor == colorName;
          return GestureDetector(
            onTap: () => setState(() => selectedColor = colorName),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(left: 15),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? Colors.black : Colors.transparent, width: 1.5)),
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(color: colorValue, shape: BoxShape.circle, border: Border.all(color: Colors.black12, width: 0.5)),
                child: isSelected ? Icon(Icons.check, size: 18, color: colorValue == Colors.white ? Colors.black : Colors.white) : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(widget.product.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
            const Icon(Icons.favorite_border, size: 26),
          ],
        ),
        const SizedBox(height: 5),
        const Text("Styleman Exclusive", style: TextStyle(color: Colors.black38, fontSize: 14)),
      ],
    );
  }

  Widget _buildDynamicSectionTitle(String title, String? value) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(width: 8),
        Text(value ?? "انتخاب کنید", style: TextStyle(fontSize: 15, color: value != null ? Colors.black87 : Colors.black26)),
      ],
    );
  }

  Widget _buildStickyBottomAction() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 60), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("افزودن به سبد خرید", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Text("${widget.product.price} تومان", style: const TextStyle(color: Colors.white, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)));
  }
}