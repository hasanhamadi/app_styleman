import 'package:dio/dio.dart';
import 'package:app_styleman/uesr/storage_helper.dart';

class AuthRepository {
  // تنظیمات پایه Dio
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://styleman.chbk.dev/api/',
    validateStatus: (status) => status! < 500, // اجازه عبور برای کدهای 400 جهت بررسی ثبت‌نام
  ));

  /// متد ورود یا ثبت‌نام خودکار
  Future<Map<String, dynamic>> loginOrSignUp(String mobile, String password) async {
    try {
      // ۱. تلاش برای لاگین
      final loginResponse = await _dio.post('collections/users/auth-with-password', data: {
        'identity': mobile,
        'password': password,
      });

      if (loginResponse.statusCode == 200) {
        return loginResponse.data;
      }

      // ۲. اگر کاربر یافت نشد (400 یا 404)، ثبت‌نام انجام شود
      if (loginResponse.statusCode == 400 || loginResponse.statusCode == 404) {
        final signUpResponse = await _dio.post('collections/users/records', data: {
          'username': mobile,
          'password': password,
          'passwordConfirm': password,
          'name': mobile,
          'emailVisibility': true,
        });

        if (signUpResponse.statusCode == 200 || signUpResponse.statusCode == 201) {
          // ۳. لاگین مجدد بلافاصله بعد از ثبت‌نام موفق
          final retryLogin = await _dio.post('collections/users/auth-with-password', data: {
            'identity': mobile,
            'password': password,
          });
          return retryLogin.data;
        } else {
          throw Exception(signUpResponse.data['message'] ?? "خطا در ایجاد حساب کاربری");
        }
      }

      throw Exception("خطای احراز هویت: ${loginResponse.data['message']}");
    } catch (e) {
      throw Exception("اختلال در برقراری ارتباط با سرور");
    }
  }

  /// متد بروزرسانی اطلاعات کاربری (حل مشکل ذخیره نشدن مشخصات)
  Future<Map<String, dynamic>> updateUserProfile({
    required String userId,
    required Map<String, dynamic> updatedData,
  }) async {
    try {
      // دریافت توکن از حافظه داخلی جهت تایید هویت برای PocketBase
      final String? token = await StorageHelper.getToken();

      if (token == null) {
        throw Exception("توکن معتبر یافت نشد. لطفا دوباره وارد شوید.");
      }

      // ارسال درخواست PATCH با هدر Authorization
      final response = await _dio.patch(
        'collections/users/records/$userId',
        data: updatedData,
        options: Options(
          headers: {
            'Authorization': token, // ارسال توکن برای تایید Update Rule در دیتابیس
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        // نمایش خطای دقیق سرور (مثل نام تکراری یا فرمت اشتباه)
        final errorMsg = response.data['message'] ?? "خطا در بروزرسانی اطلاعات";
        throw Exception(errorMsg);
      }
    } on DioException catch (e) {
      throw Exception("خطا در شبکه: ${e.message}");
    } catch (e) {
      throw Exception("بروزرسانی با شکست مواجه شد: $e");
    }
  }
}