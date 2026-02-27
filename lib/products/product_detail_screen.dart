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

  // --- پالت رنگی استاندارد ---
  final Color primaryBlue = const Color(0xFF80aad3);
  final Color darkColor = const Color(0xFF1A1A1A); // مشکی استاندارد کمی ملایم‌تر
  final Color lightColor = Colors.white;

  Color _getColorFromText(String colorName) {
    if (colorName.contains("مشکی")) return Colors.black;
    if (colorName.contains("سفید")) return Colors.white;
    if (colorName.contains("طوسی")) return Colors.grey;
    if (colorName.contains("آبی")) return primaryBlue;
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
    if (stockValue.isEmpty || stockValue == "null") return true;
    int? stock = int.tryParse(stockValue);
    return (stock == null) ? true : stock > 0;
  }

  void _showSizeGuideDialog() {
    final p = widget.product;
    final Map<String, String> sizeData = {
      'S': p.s,
      'M': p.m,
      'L': p.l,
      'XL': p.xl,
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: lightColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("راهنمای سایز", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkColor)),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
              const SizedBox(height: 15),
              Table(
                border: TableBorder.all(color: Colors.grey.shade200, width: 1),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: Colors.grey.shade100),
                    children: [
                      TableCell(child: Padding(padding: const EdgeInsets.all(12), child: Text("سایز", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: darkColor)))),
                      TableCell(child: Padding(padding: const EdgeInsets.all(12), child: Text("موجودی", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: darkColor)))),
                    ],
                  ),
                  ...sizeData.entries.map((entry) {
                    return TableRow(
                      children: [
                        TableCell(child: Padding(padding: const EdgeInsets.all(12), child: Text(entry.key, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)))),
                        TableCell(child: Padding(padding: const EdgeInsets.all(12), child: Text(entry.value, textAlign: TextAlign.center))),
                      ],
                    );
                  }).toList(),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSizeGuideButton() {
    return GestureDetector(
      onTap: _showSizeGuideDialog,
      child: Row(
        children: [
          Icon(Icons.straighten_rounded, size: 18, color: primaryBlue),
          const SizedBox(width: 5),
          Text(
            "راهنمای سایز",
            style: TextStyle(
              color: primaryBlue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allImages = [widget.product.mainImageUrl, ...widget.product.galleryUrls];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: lightColor,
        body: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildProductImageHeader(allImages),
                SliverToBoxAdapter(child: _buildThumbnailsGallery(allImages)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 150),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleSection(),
                        const SizedBox(height: 30),

                        _buildSectionTitle("توضیحات"),
                        Text(
                          widget.product.description,
                          style: TextStyle(
                            color: darkColor.withOpacity(0.7),
                            fontSize: 14,
                            height: 1.9,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 25),

                        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                        const SizedBox(height: 25),

                        _buildDynamicSectionTitle("رنگ:", selectedColor),
                        const SizedBox(height: 15),
                        _buildColorSelector(),
                        const SizedBox(height: 30),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildDynamicSectionTitle("سایز:", selectedSize),
                            _buildSizeGuideButton(),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildSizeSelector(),

                        const SizedBox(height: 35),
                        const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
                        const SizedBox(height: 25),
                        _buildPolicySection(),
                        const SizedBox(height: 35),
                        _buildSectionTitle("مشخصات کالا"),
                        _buildSpecCard(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // دکمه‌های بالا
            Positioned(
              top: MediaQuery.of(context).padding.top + 15,
              left: 15,
              right: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleButton(Icons.arrow_back_rounded, () => Navigator.pop(context)),
                  _buildCircleButton(Icons.favorite_border_rounded, () {}),
                ],
              ),
            ),
            _buildStickyBottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicySection() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          _buildPolicyRow(
            icon: Icons.verified_rounded,
            iconColor: primaryBlue,
            text: "ضمانت اصالت و سلامت کالا",
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildPolicyRow(
            icon: Icons.assignment_return_rounded,
            iconColor: primaryBlue,
            text: "بازگشت و مرجوعی تا ۷ روز",
          ),
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          _buildPolicyRow(
            icon: Icons.local_shipping_rounded,
            iconColor: primaryBlue,
            text: "ارسال تا ۱۵ روز کاری",
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyRow({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: darkColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: lightColor.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: IconButton(
        icon: Icon(icon, color: darkColor, size: 22),
        onPressed: onTap,
      ),
    );
  }

  Widget _buildProductImageHeader(List<String> images) {
    return SliverToBoxAdapter(
      child: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.75,
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => activeIndex = i),
                itemCount: images.length,
                itemBuilder: (context, index) => Image.network(images[index], fit: BoxFit.cover),
              ),
            ),
          ),
          // نقطه فعال (Indicator)
          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: activeIndex == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: activeIndex == index ? primaryBlue : lightColor.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnailsGallery(List<String> allImages) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: allImages.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _pageController.animateToPage(index,
              duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
          child: Container(
            width: 70,
            margin: const EdgeInsets.only(left: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: activeIndex == index ? primaryBlue : Colors.transparent,
                  width: 2),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],              image: DecorationImage(
                  image: NetworkImage(allImages[index]), fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSizeSelector() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.product.sizes.length,
        itemBuilder: (context, index) {
          final size = widget.product.sizes[index];
          bool available = _isSizeAvailable(size);
          bool isSelected = selectedSize == size;

          return GestureDetector(
            onTap: () {
              if (available) {
                setState(() => selectedSize = size);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(left: 12),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? primaryBlue : lightColor,
                border: Border.all(
                  color: isSelected
                      ? primaryBlue
                      : (available ? Colors.grey.shade300 : Colors.grey.shade200),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: available
                    ? Text(
                  size,
                  style: TextStyle(
                    color: isSelected
                        ? lightColor
                        : darkColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                )
                    : Icon(Icons.close_rounded, color: Colors.grey.shade300, size: 22),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpecCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          _buildSpecRow("جنس کالا", widget.product.material),
          _buildSpecRow("نوع یقه", widget.product.neckline),
          _buildSpecRow("نوع آستین", widget.product.sleeveType),
          _buildSpecRow("تن‌خور", widget.product.fit),
          _buildSpecRow("کد محصول", widget.product.id.substring(0, 8), isLast: true),
        ],
      ),
    );
  }

  Widget _buildSpecRow(String label, String value, {bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(border: Border(bottom: isLast ? BorderSide.none : BorderSide(color: Colors.grey.shade100, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: darkColor.withOpacity(0.5), fontSize: 14)),
          Text(value.isEmpty ? "نامشخص" : value, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: darkColor)),
        ],
      ),
    );
  }

  Widget _buildColorSelector() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.product.colors.length,
        itemBuilder: (context, index) {
          final colorName = widget.product.colors[index];
          final colorValue = _getColorFromText(colorName);
          bool isSelected = selectedColor == colorName;
          return GestureDetector(
            onTap: () => setState(() => selectedColor = colorName),
            child: Container(
              margin: const EdgeInsets.only(left: 12),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: isSelected ? primaryBlue : Colors.transparent, width: 2)
              ),
              child: CircleAvatar(backgroundColor: colorValue, radius: 18),
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
        Text(widget.product.name, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: darkColor, height: 1.2)),
        const SizedBox(height: 6),
        Text("Styleman Exclusive", style: TextStyle(color: primaryBlue, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildDynamicSectionTitle(String title, String? value) {
    return Row(
      children: [
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: darkColor)),
        const SizedBox(width: 8),
        Text(value ?? "انتخاب کنید", style: TextStyle(fontSize: 15, color: value != null ? primaryBlue : Colors.black45, fontWeight: value != null ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }

  Widget _buildStickyBottomAction() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
        decoration: BoxDecoration(
          color: lightColor,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: darkColor,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 0
          ),
          onPressed: () {
            if (selectedSize == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("لطفاً سایز محصول را انتخاب کنید"),
                  backgroundColor: primaryBlue,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              return;
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("افزودن به سبد خرید", style: TextStyle(color: lightColor, fontWeight: FontWeight.bold, fontSize: 16)),
              Text("${widget.product.price} تومان", style: TextStyle(color: lightColor, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: darkColor))
    );
  }
}