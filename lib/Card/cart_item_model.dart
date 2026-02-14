import '../products/product_model.dart';

class CartItemModel {
  final String id;
  final String cartId;
  final String productId;
  int quantity;
  final ProductModel? product; // اطلاعات کامل محصول که از سمت سرور Expand شده

  CartItemModel({
    required this.id,
    required this.cartId,
    required this.productId,
    required this.quantity,
    this.product,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      cartId: json['cart'],
      productId: json['product'],
      quantity: json['quantity'] is int ? json['quantity'] : int.parse(json['quantity'].toString()),
      // استخراج محصول از بخش expand دیتابیس
      product: json['expand']?['product'] != null
          ? ProductModel.fromJson(json['expand']['product'])
          : null,
    );
  }

  // ایجاد نسخه جدید برای Optimistic Update در BLoC
  CartItemModel copyWith({int? quantity}) {
    return CartItemModel(
      id: id,
      cartId: cartId,
      productId: productId,
      quantity: quantity ?? this.quantity,
      product: product,
    );
  }
}