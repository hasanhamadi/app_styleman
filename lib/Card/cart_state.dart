part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

/// وضعیت اولیه قبل از هر گونه پردازش
final class CartInitial extends CartState {}

/// وضعیت بارگذاری (نمایش Spinner در UI)
final class CartLoading extends CartState {}

/// وضعیت موفقیت که شامل لیست کامل آیتم‌های ترکیب شده از هر دو کالکشن است
final class CartLoaded extends CartState {
  final List<CartItemModel> items;

  CartLoaded({required this.items});

  // محاسبه مجموع قیمت کل سبد خرید
  double get totalPrice => items.fold(0, (sum, item) => sum + ((item.product?.price ?? 0) * item.quantity));

  // تعداد کل کالاهای موجود (برای نمایش روی Badge آیکون سبد)
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
}

/// وضعیت بروزرسانی موقت (برای مدیریت Optimistic UI یا نمایش Loadingهای کوچک روی هر آیتم)
final class CartUpdating extends CartState {
  final List<CartItemModel> items;
  CartUpdating({required this.items});
}

/// وضعیت خطا همراه با پیام مناسب برای کاربر
final class CartError extends CartState {
  final String message;
  CartError(this.message);
}