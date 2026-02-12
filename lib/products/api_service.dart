import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://styleman.chbk.dev/api/'));

  Future<Response> getProducts() async {
    try {
      return await _dio.get('collections/product/records');
    } on DioException catch (e) {
      throw e.message ?? "خطای شبکه رخ داده است";
    }
  }
}