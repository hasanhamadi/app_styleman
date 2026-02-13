import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://styleman.chbk.dev/api/'));

  Future<Map<String, dynamic>> loginOrSignUp(String mobile, String password) async {
    try {
      // ۱. تلاش برای لاگین
      final response = await _dio.post('collections/users/auth-with-password', data: {
        'identity': mobile,
        'password': password,
      });
      return response.data;
    } on DioException catch (e) {
      // ۲. اگر کاربر یافت نشد (۴۰۴ یا ۴۰۰)، ثبت‌نام کن
      if (e.response?.statusCode == 404 || e.response?.statusCode == 400) {
        await _dio.post('collections/users/records', data: {
          'username': mobile,
          'password': password,
          'passwordConfirm': password,
          'name': 'کاربر جدید',
        });
        // ۳. حالا دوباره لاگین کن تا توکن بگیری
        final retry = await _dio.post('collections/users/auth-with-password', data: {
          'identity': mobile,
          'password': password,
        });
        return retry.data;
      }
      rethrow;
    }
  }
}