import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio(BaseOptions(baseUrl: 'https://styleman.chbk.dev/api/'));

  Future<Response> getProducts() async {
    try {
      return await dio.get('collections/product/records');
    } on DioException catch (e) {
      throw e.message ?? "خطای شبکه رخ داده است";
    }
  }
}
