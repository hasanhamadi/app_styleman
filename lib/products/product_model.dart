class ProductModel {
  final String id;
  final String collectionId; // برای ساخت لینک تصویر الزامی است
  final String name;
  final String description;
  final int price;
  final String image; // تصویر اصلی
  final List<String> images; // گالری تصاویر
  final List<String> sizes;
  final List<String> colors;
  final int stock;
  final String material;
  final String fit;
  final String sleeveGuide;
  final String sizeGuide;
  // موجودی تفکیکی سایزها (در صورت نیاز به مدیریت دقیق)
  final String s, m, l, xl;

  ProductModel({
    required this.id,
    required this.collectionId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.images,
    required this.sizes,
    required this.colors,
    required this.stock,
    required this.material,
    required this.fit,
    required this.sleeveGuide,
    required this.sizeGuide,
    required this.s,
    required this.m,
    required this.l,
    required this.xl,
  });

  // تبدیل JSON از PocketBase به مدل دارت
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      collectionId: json['collectionId'] ?? '',
      name: json['name'] ?? 'بدون نام',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toInt(),
      image: json['image'] ?? '',
      // در PocketBase لیست‌ها معمولاً به صورت List<dynamic> می‌آیند
      images: List<String>.from(json['images'] ?? []),
      sizes: List<String>.from(json['sizes'] ?? []),
      colors: List<String>.from(json['colors'] ?? []),
      stock: (json['stock'] ?? 0).toInt(),
      material: json['Mateial'] ?? '', // دقت به غلط املایی در فیلد بک‌اندر
      fit: json['Fit'] ?? '',
      sleeveGuide: json['SleeGuide'] ?? '',
      sizeGuide: json['SizeGuide'] ?? '',
      s: json['S'] ?? '0',
      m: json['M'] ?? '0',
      l: json['L'] ?? '0',
      xl: json['XL'] ?? '0',
    );
  }

  // متد کمکی برای دریافت آدرس تصویر اصلی
  String get mainImageUrl =>
      'https://styleman.chbk.dev/api/files/$collectionId/$id/$image';

  // متد کمکی برای دریافت لیست آدرس‌های گالری تصاویر
  List<String> get galleryUrls => images
      .map((img) => 'https://styleman.chbk.dev/api/files/$collectionId/$id/$img')
      .toList();
}