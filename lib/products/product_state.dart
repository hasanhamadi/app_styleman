part of 'product_bloc.dart';

@immutable
sealed class ProductState {}

// وضعیت در حال انتظار (قبل از شروع هر کاری)
class ProductInitial extends ProductState {}

// وضعیت بارگذاری (نمایش Spinner)
class ProductLoading extends ProductState {}

// وضعیت موفقیت‌آمیز (دریافت لیست محصولات)
class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  ProductLoaded(this.products);
}

// وضعیت خطا (نمایش پیام خطا به کاربر)
class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}