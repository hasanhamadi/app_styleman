import 'banner_model.dart';
import 'banner_service.dart';

class BannerRepository {
  final BannerService _service;

  // لایه کش ساده برای جلوگیری از درخواست‌های تکراری به شبکه
  List<BannerModel>? _cache;

  BannerRepository(this._service);

  /// متد اصلی برای دریافت بنرها
  /// [refresh]: اگر true باشد، کش نادیده گرفته شده و درخواست جدید به سرور ارسال می‌شود.
  Future<List<BannerModel>> getBanners({bool refresh = false}) async {
    // 1. چک کردن کش: اگر داده موجود است و نیازی به ریفرش نیست، داده کش شده را برگردان
    if (_cache != null && !refresh) {
      return _cache!;
    }

    try {
      // 2. فراخوانی سرویس شبکه
      final response = await _service.fetchBanners();

      // 3. استخراج لیست آیتم‌ها از فیلد 'items' (مختص PocketBase)
      // استفاده از casting ایمن به List<dynamic>
      final List<dynamic> items = response.data['items'] ?? [];

      // 4. تبدیل داده‌های خام به مدل‌های BannerModel
      // در اینجا ورودی هر مدل را به صورت Map<String, dynamic> کست می‌کنیم
      final List<BannerModel> banners = items.map((json) {
        return BannerModel.fromJson(json as Map<String, dynamic>);
      }).toList();

      // 5. ذخیره در کش برای استفاده‌های بعدی
      _cache = banners;

      return banners;

    } catch (e) {
      // 6. مدیریت هوشمند خطا (Fail-safe)
      // اگر خطایی رخ داد اما قبلاً داده‌ای در کش داشتیم، همان را برمی‌گردانیم تا اپلیکیشن خالی نماند
      if (_cache != null) {
        return _cache!;
      }

      // در غیر این صورت، خطا را به لایه بالاتر (BLoC) می‌فرستیم
      throw Exception("عدم موفقیت در دریافت بنرها: ${e.toString()}");
    }
  }

  /// متد کمکی برای پاک کردن دستی کش (مثلاً زمان خروج از حساب کاربری)
  void clearCache() {
    _cache = null;
  }
}
