class ProductModel {
  final String id;
  final String collectionId;
  final String name;
  final String description;
  final int price;
  final String image;
  final List<String> images;
  final List<String> sizes;
  final List<String> colors;
  final int stock;
  final String material;
  final String neckline;
  final String sleeveType;
  final String fit;
  final String sizeGuide;
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
    required this.neckline,
    required this.sleeveType,
    required this.fit,
    required this.sizeGuide,
    required this.s,
    required this.m,
    required this.l,
    required this.xl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      collectionId: json['collectionId'] ?? '',
      name: json['name'] ?? 'بدون نام',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toInt(),
      image: json['image'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      sizes: List<String>.from(json['sizes'] ?? []),
      colors: List<String>.from(json['colors'] ?? []),
      stock: (json['stock'] ?? 0).toInt(),
      // هماهنگ شده با حروف کوچک دیتابیس شما
      material: json['material'] ?? '',
      fit: json['fit'] ?? '',
      neckline: json['neckline'] ?? '',
      sleeveType: json['sleeveType'] ?? '',
      sizeGuide: json['sizeGuide'] ?? '',
      s: json['S'] ?? '0',
      m: json['M'] ?? '0',
      l: json['L'] ?? '0',
      xl: json['XL'] ?? '0',
    );
  }

  String get mainImageUrl =>
      'https://styleman.chbk.dev/api/files/$collectionId/$id/$image';

  List<String> get galleryUrls => images
      .map((img) => 'https://styleman.chbk.dev/api/files/$collectionId/$id/$img')
      .toList();
}