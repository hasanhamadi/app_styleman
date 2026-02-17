import 'package:dio/dio.dart';

class BannerService {
  final Dio _dio;
  BannerService(this._dio);

  Future<Response> fetchBanners() async {
    try {
      return await _dio.get(
        '/collections/banner/records',
        options: Options(receiveTimeout: const Duration(seconds: 10)),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) return "خطا در اتصال به سرور";
    return "مشکلی در دریافت اطلاعات پیش آمد";
  }
}