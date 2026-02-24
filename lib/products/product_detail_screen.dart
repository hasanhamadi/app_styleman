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

  // تابع تبدیل نام فارسی به رنگ
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

  // بررسی موجودی سایز
  bool _isSizeAvailable(String size) {
    String stockValue = "";
    switch (size.toUpperCase()) {
      case 'S': stockValue = widget.product.s; break;
      case 'M': stockValue = widget.product.m; break;
      case 'L': stockValue = widget.product.l; break;
      case 'XL': stockValue = widget.product.xl; break;
      default: return true;
    }
    if (stockValue.isEmpty) return true;
    int? stock = int.tryParse(stockValue);
    return (stock == null) ? true : stock > 0;
  }

  // نمایش راهنمای اندازه (BottomSheet)
  void _showSizeGuide() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("راهنمای اندازه (سانتی‌متر)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // تصویر راهنمای اندازه‌گیری
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(15)),
                      child: Image.network(
                        "https://img.freepik.com/free-vector/t-shirt-design-template_1035-10145.jpg",
                        height: 180,
                      ),
                    ),
                    const SizedBox(height: 25),

                    // جدول با داده‌های زنده از ProductModel
                    Table(
                      border: TableBorder.all(color: Colors.grey.shade200, width: 1, borderRadius: BorderRadius.circular(8)),
                      children: [
                        _buildTableRow(["سایز", "مقدار اندازه (cm)"], isHeader: true),
                        _buildTableRow(["S", widget.product.s]),
                        _buildTableRow(["M", widget.product.m]),
                        _buildTableRow(["L", widget.product.l]),
                        _buildTableRow(["XL", widget.product.xl]),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "* مقادیر بالا بر اساس سانتیمتر و مربوط به ابعاد اصلی کالا می‌باشد.",
                      style: TextStyle(color: Colors.black38, fontSize: 12),
                    )
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[100],
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("متوجه شدم", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(color: isHeader ? Colors.grey[50] : Colors.white),
      children: cells.map((cell) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(cell, textAlign: TextAlign.center, style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        )),
      )).toList(),
    );
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
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(allImages),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 30, 20, 140),
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
                        const SizedBox(height: 10),
                        // دکمه راهنمای اندازه آبی رنگ
                        GestureDetector(
                          onTap: _showSizeGuide,
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("راهنمای اندازه", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                              Icon(Icons.chevron_left, color: Colors.blue, size: 20),
                            ],
                          ),
                        ),
                        const SizedBox(height: 35),
                        _buildSectionTitle("ویژگی‌های کالا"),
                        _buildSpecCard(),
                        const SizedBox(height: 30),
                        _buildSectionTitle("توضیحات"),
                        Text(widget.product.description, style: const TextStyle(color: Colors.black54, fontSize: 14, height: 1.8)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            _buildStickyBottomAction(),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicSectionTitle(String title, String? value) {
    return Row(
      children: [
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        const SizedBox(width: 8),
        Text(value ?? "انتخاب کنید", style: TextStyle(fontSize: 16, color: value != null ? Colors.black87 : Colors.black26, fontWeight: FontWeight.w600)),
      ],
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

  Widget _buildSizeSelector() {
    return Wrap(
      spacing: 12, runSpacing: 12,
      children: widget.product.sizes.map((size) {
        bool available = _isSizeAvailable(size);
        bool isSelected = selectedSize == size;
        return GestureDetector(
          onTap: available ? () => setState(() => selectedSize = size) : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 46, height: 46, padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: isSelected ? Colors.black : Colors.transparent, width: 1.5)),
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? Colors.black : (available ? Colors.white : Colors.grey.shade50), border: Border.all(color: isSelected ? Colors.black : (available ? Colors.black12 : Colors.grey.shade200))),
              child: Center(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Text(size, style: TextStyle(color: isSelected ? Colors.white : (available ? Colors.black87 : Colors.grey.shade300), fontWeight: FontWeight.bold, fontSize: 13, decoration: available ? null : TextDecoration.lineThrough)),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // بقیه متدهای UI (_buildSliverAppBar, _buildTitleSection, _buildSpecCard, _buildStickyBottomAction, ...)
  Widget _buildSliverAppBar(List<String> images) {
    return SliverAppBar(
      expandedHeight: MediaQuery.of(context).size.height * 0.55,
      backgroundColor: Colors.white,
      pinned: true,
      leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
      actions: [
        IconButton(icon: const Icon(Icons.share_outlined, size: 22), onPressed: () {}),
        IconButton(icon: const Icon(Icons.shopping_bag_outlined, size: 22), onPressed: () {}),
        const SizedBox(width: 10),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: PageView.builder(
          onPageChanged: (i) => setState(() => activeIndex = i),
          itemCount: images.length,
          itemBuilder: (context, index) => Image.network(images[index], fit: BoxFit.cover),
        ),
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
            Text(widget.product.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            IconButton(icon: const Icon(Icons.favorite_border, size: 28), onPressed: () {}),
          ],
        ),
        const Divider(height: 30),
      ],
    );
  }

  Widget _buildSpecCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(22)),
      child: Column(
        children: [
          _buildRowInfo("جنس کار", widget.product.material),
          const Divider(height: 30),
          _buildRowInfo("تن‌خور", widget.product.fit),
        ],
      ),
    );
  }

  Widget _buildRowInfo(String label, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.black45)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold))]);
  }

  Widget _buildStickyBottomAction() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        color: Colors.white,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black, minimumSize: const Size(double.infinity, 65), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("افزودن به سبد خرید", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("${widget.product.price} تومان", style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(padding: const EdgeInsets.only(bottom: 18), child: Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)));
  }
}