import 'package:dio/dio.dart';
import 'order_model.dart';

class OrderService {
  // استفاده از Singleton یا تزریق Dio برای بهینه‌سازی پیشنهاد می‌شود
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://styleman.chbk.dev/api/",
    connectTimeout: const Duration(seconds: 5),
  ));

  // دریافت لیست سفارشات با پشتیبانی از Pagination
  Future<Response> fetchOrders(int page, int perPage) async {
    return await _dio.get("collections/orders/records", queryParameters: {
      "page": page,
      "perPage": perPage,
      "sort": "-created", // نمایش جدیدترین‌ها در ابتدا
    });
  }

  // ثبت سفارش جدید
  Future<Response> createOrder(OrderModel order) async {
    return await _dio.post("collections/orders/records", data: order.toJson());
  }

  // بروزرسانی وضعیت توسط ادمین یا سیستم
  Future<Response> updateOrderStatus(String orderId, String newStatus) async {
    return await _dio.patch("collections/orders/records/$orderId", data: {
      "status": newStatus,
    });
  }
}
