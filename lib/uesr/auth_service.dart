import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://styleman.chbk.dev/api/'));

  // ورود با استفاده از identity (موبایل) و پسورد
  Future<Response> login(String mobile, String password) async {
    return await _dio.post('collections/users/auth-with-password', data: {
      'identity': mobile,
      'password': password,
    });
  }

  // ثبت‌نام کاربر جدید
  Future<Response> signUp(String mobile, String password) async {
    return await _dio.post('collections/users/records', data: {
      'username': mobile,
      'password': password,
      'passwordConfirm': password,
      'name': 'کاربر جدید',
    });
  }
}