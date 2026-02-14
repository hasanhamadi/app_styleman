import 'cart_item_model.dart';
import 'cart_remote_service.dart';

abstract class CartRepository {
  Future<List<CartItemModel>> fetchCart(String userId);
  Future<void> addToCart(String userId, String productId, int quantity);
  Future<void> updateQuantity(String itemId, int newQuantity);
  Future<void> deleteItem(String itemId);
}

class CartRepositoryImpl implements CartRepository {
  final CartRemoteService remoteService;

  CartRepositoryImpl(this.remoteService);

  @override
  Future<List<CartItemModel>> fetchCart(String userId) async {
    // اگر یوزر آیدی خالی باشد، اصلاً درخواستی نمی‌فرستیم
    if (userId.isEmpty) return [];

    try {
      // ۱. دریافت سبد فعال
      final cartRes = await remoteService.getActiveCart(userId);

      // بررسی وجود فیلد items در پاسخ PocketBase
      final List cartItemsList = cartRes.data['items'] ?? [];

      String cartId;

      if (cartItemsList.isEmpty) {
        // ۲. اگر سبدی وجود نداشت، یکی ایجاد می‌کنیم
        final newCartRes = await remoteService.createCart(userId);
        cartId = newCartRes.data['id'];
      } else {
        // دریافت آیدی اولین سبد خرید فعال
        cartId = cartItemsList[0]['id'];
      }

      // ۳. دریافت آیتم‌های داخل سبد با Expand محصول
      final itemsRes = await remoteService.getItemsByCartId(cartId);
      final List data = itemsRes.data['items'] ?? [];

      return data.map((json) => CartItemModel.fromJson(json)).toList();
    } catch (e) {
      // لاگ کردن خطا برای دیباگ راحت‌تر
      print("Error in fetchCart: $e");
      throw Exception("لیست سبد خرید دریافت نشد.");
    }
  }

  @override
  Future<void> addToCart(String userId, String productId, int quantity) async {
    if (userId.isEmpty) throw Exception("لطفاً ابتدا وارد حساب کاربری خود شوید.");

    try {
      final cartRes = await remoteService.getActiveCart(userId);
      final List cartItemsList = cartRes.data['items'] ?? [];

      String cartId;

      if (cartItemsList.isEmpty) {
        final newCart = await remoteService.createCart(userId);
        cartId = newCart.data['id'];
      } else {
        cartId = cartItemsList[0]['id'];
      }

      // ۴. افزودن آیتم به کالکشن cart_items
      await remoteService.addItem(cartId, productId, quantity);
    } catch (e) {
      print("Error in addToCart: $e");
      throw Exception("کالا به سبد خرید اضافه نشد.");
    }
  }

  @override
  Future<void> updateQuantity(String itemId, int newQuantity) async {
    try {
      await remoteService.updateItemQuantity(itemId, newQuantity);
    } catch (e) {
      throw Exception("تغییر تعداد با خطا مواجه شد.");
    }
  }

  @override
  Future<void> deleteItem(String itemId) async {
    try {
      await remoteService.deleteItem(itemId);
    } catch (e) {
      throw Exception("حذف کالا انجام نشد.");
    }
  }
}