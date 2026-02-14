import 'package:dio/dio.dart';

class CartRemoteService {
  final Dio _dio;

  final String _cartColl = 'collections/carts/records';
  final String _itemsColl = 'collections/cart_items/records';

  CartRemoteService(this._dio);

  // دریافت سبد خرید فعال کاربر
  Future<Response> getActiveCart(String userId) async {
    // جلوگیری از ارسال درخواست با آیدی خالی که باعث خطای 400 می‌شود
    if (userId.isEmpty) {
      throw Exception("User ID is empty. Please login first.");
    }

    return await _dio.get(
      _cartColl,
      queryParameters: {
        // استفاده از تک کوتیشن (') داخل دابل کوتیشن (") برای مقادیر رشته‌ای در فیلتر
        'filter': 'user="$userId" && status="active"',
      },
    );
  }

  // ایجاد سبد خرید جدید
  Future<Response> createCart(String userId) async {
    if (userId.isEmpty) throw Exception("User ID is required");

    return await _dio.post(
      _cartColl,
      data: {
        'user': userId,
        'status': 'active',
      },
    );
  }

  // دریافت تمام آیتم‌های یک سبد خاص با جزئیات محصول
  Future<Response> getItemsByCartId(String cartId) async {
    if (cartId.isEmpty) throw Exception("Cart ID is required");

    return await _dio.get(
      _itemsColl,
      queryParameters: {
        // اصلاح فیلتر برای مطابقت با مستندات PocketBase
        'filter': 'cart="$cartId"',
        'expand': 'product',
      },
    );
  }

  // افزودن آیتم جدید به سبد
  Future<Response> addItem(String cartId, String productId, int quantity) async {
    return await _dio.post(
      _itemsColl,
      data: {
        'cart': cartId,
        'product': productId,
        'quantity': quantity,
      },
    );
  }

  // بروزرسانی تعداد (PATCH)
  Future<Response> updateItemQuantity(String itemId, int quantity) async {
    return await _dio.patch(
      '$_itemsColl/$itemId',
      data: {'quantity': quantity},
    );
  }

  // حذف آیتم از سبد
  Future<Response> deleteItem(String itemId) async {
    return await _dio.delete('$_itemsColl/$itemId');
  }
}