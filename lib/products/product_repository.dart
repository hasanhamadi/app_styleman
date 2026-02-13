import 'package:app_styleman/products/product_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'api_service.dart';

class ProductRepository {
  final ApiService apiService;

  ProductRepository(this.apiService);

  // دریافت همه محصولات
  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final response = await apiService.getProducts();
      final List data = response.data['items'];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("خطا در دریافت لیست محصولات: $e");
    }
  }

  // متد جستجوی اصلاح شده (فقط بر اساس نام)
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final String cleanQuery = query.trim();
      if (cleanQuery.isEmpty) return [];

      // حذف فیلد description و جستجو فقط در فیلد name
      final String filter = 'name ~ "$cleanQuery"';

      final response = await apiService.dio.get(
        '/collections/product/records',
        queryParameters: {
          'filter': filter,
        },
      );

      if (response.statusCode == 200) {
        final List data = response.data['items'];
        return data.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception("خطا در پاسخ سرور");
      }

    } on DioException catch (e) {
      debugPrint("❌ PocketBase Detail Error: ${e.response?.data}");

      String errorMessage = "خطایی در عملیات جستجو رخ داد";
      if (e.response != null) {
        // نمایش پیام دقیق سرور برای عیب‌یابی راحت‌تر
        errorMessage = "خطا: ${e.response?.data['message'] ?? 'Bad Request'}";
      }
      throw Exception(errorMessage);
    } catch (e) {
      throw Exception("خطای غیرمنتظره: $e");
    }
  }
}