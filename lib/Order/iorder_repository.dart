// اینترفیس مخزن برای تست‌پذیری (Mocking)
import 'package:dio/dio.dart';

import 'order_model.dart';
import 'order_service.dart';

abstract class IOrderRepository {
  Future<List<OrderModel>> getOrders({int page = 1, int perPage = 20});
  Future<void> saveNewOrder(OrderModel order);
  Future<void> updateStatus(String orderId, String newStatus);
}

// پیاده‌سازی مخزن
class OrderRepository implements IOrderRepository {
  final OrderService service;
  OrderRepository(this.service);

  @override
  Future<List<OrderModel>> getOrders({int page = 1, int perPage = 20}) async {
    try {
      final response = await service.fetchOrders(page, perPage);

      // تبدیل لیست ارسالی از سمت سرور به لیستی از مدل‌های OrderModel
      final List items = response.data['items'];
      return items.map((json) => OrderModel.fromJson(json)).toList();
    } on DioException catch (e) {
      // مدیریت حرفه‌ای خطاها
      throw _handleError(e);
    }
  }

  @override
  Future<void> saveNewOrder(OrderModel order) async {
    try {
      await service.createOrder(order);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> updateStatus(String orderId, String newStatus) async {
    try {
      await service.updateOrderStatus(orderId, newStatus);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // متد کمکی برای بومی‌سازی خطاها
  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) return "خطا در اتصال به شبکه";
    return e.response?.data['message'] ?? "خطایی در عملیات سفارش رخ داد";
  }
}
