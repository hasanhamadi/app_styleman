part of 'product_bloc.dart';

@immutable
sealed class ProductEvent {}

// رویداد برای بارگذاری اولیه لیست محصولات
class LoadProductsEvent extends ProductEvent {}

// رویداد برای رفرش کردن لیست (مثلاً Pull-to-refresh)
class RefreshProductsEvent extends ProductEvent {}