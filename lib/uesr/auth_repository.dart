import 'package:dio/dio.dart';

class AuthRepository {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://styleman.chbk.dev/api/',
    validateStatus: (status) => status! < 500, // اجازه عبور برای بررسی کد 400
  ));

  Future<Map<String, dynamic>> loginOrSignUp(String mobile, String password) async {
    // ۱. مرحله لاگین
    final loginResponse = await _dio.post('collections/users/auth-with-password', data: {
      'identity': mobile, // PocketBase موبایل را در فیلد یوزرنیم چک می‌کند
      'password': password,
    });

    if (loginResponse.statusCode == 200) {
      return loginResponse.data;
    }

    // ۲. اگر لاگین ناموفق بود (کد 400 یا 404)، یعنی احتمالا کاربر وجود ندارد
    if (loginResponse.statusCode == 400 || loginResponse.statusCode == 404) {
      final signUpResponse = await _dio.post('collections/users/records', data: {
        'username': mobile, // فیلد اجباری طبق عکس شما
        'password': password,
        'passwordConfirm': password,
        'name': mobile,
        'emailVisibility': true,
      });

      if (signUpResponse.statusCode == 200 || signUpResponse.statusCode == 201) {
        // ۳. لاگین مجدد بعد از ساخت موفق اکانت
        final retryLogin = await _dio.post('collections/users/auth-with-password', data: {
          'identity': mobile,
          'password': password,
        });
        return retryLogin.data;
      } else {
        // اگر ثبت نام هم خطا داد (مثلا یوزرنیم تکراری یا رمز کوتاه)
        throw Exception(signUpResponse.data['message'] ?? "خطا در ایجاد حساب");
      }
    }

    throw Exception("خطای احراز هویت: ${loginResponse.data['message']}");
  }
}