part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}
class CartStarted extends CartEvent {
  final String userId;
  // تعریف پارامتر برای رفع خطای Named Parameter
  CartStarted({required this.userId});
}

class CartItemAdded extends CartEvent {
  final ProductModel product;
  CartItemAdded({required this.product});
}

class CartItemRemoved extends CartEvent {
  final String itemId;
  CartItemRemoved({required this.itemId});
}

class CartUpdateQuantity extends CartEvent {
  final String itemId;
  final int quantity;
  CartUpdateQuantity({required this.itemId, required this.quantity});
}