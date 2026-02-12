import 'package:app_styleman/products/product_model.dart';

import 'api_service.dart';

class ProductRepository {
  final ApiService apiService;

  ProductRepository(this.apiService);

  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final response = await apiService.getProducts();

      // در PocketBase لیست داده‌ها در فیلد 'items' قرار دارد
      final List data = response.data['items'];

      // تبدیل لیست JSON به لیستی از ProductModel
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      // بهتر است خطاها را اینجا مدیریت کنید یا به لایه بالاتر (Bloc) بفرستید
      throw Exception("خطا در دریافت لیست محصولات: $e");
    }
  }
}