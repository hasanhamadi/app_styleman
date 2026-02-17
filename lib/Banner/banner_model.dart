import 'package:flutter/foundation.dart';

@immutable
class BannerModel {
  final String id;
  final List<String> images;

  const BannerModel({
    required this.id,
    required this.images,
  });

  /// متد تبدیل JSON به مدل با مدیریت خطای Type Casting
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    // 1. استخراج فیلد آیدی رکورد
    final String recordId = json['id'] ?? '';

    // 2. نام کالکشن طبق تنظیمات شما در PocketBase
    const String collectionName = "banner";

    // 3. دریافت لیست تصاویر (PocketBase لیست نام فایل‌ها را برمی‌گرداند)
    // استفاده از کستینگ ایمن برای جلوگیری از خطای List<dynamic>
    final dynamic imageField = json['image'];
    List<String> fileNames = [];

    if (imageField is List) {
      fileNames = imageField.map((e) => e.toString()).toList();
    }

    // 4. تبدیل نام فایل‌ها به URL کامل و مستقیم برای نمایش در اپلیکیشن
    // فرمول: base_url/api/files/collection_id/record_id/filename
    final List<String> fullUrls = fileNames.map((fileName) {
      return "https://styleman.chbk.dev/api/files/$collectionName/$recordId/$fileName";
    }).toList();

    return BannerModel(
      id: recordId,
      images: fullUrls,
    );
  }

  /// متد تبدیل مدل به JSON (برای عملیات احتمالی در آینده)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': images,
    };
  }

  /// متد کپی برای حفظ Immutability
  BannerModel copyWith({
    String? id,
    List<String>? images,
  }) {
    return BannerModel(
      id: id ?? this.id,
      images: images ?? this.images,
    );
  }
}