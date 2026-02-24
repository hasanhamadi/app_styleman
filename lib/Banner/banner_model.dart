import 'package:flutter/foundation.dart';

@immutable
class BannerModel {
  final String id;
  final List<String> images;

  const BannerModel({
    required this.id,
    required this.images,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    final String recordId = json['id'] ?? '';
    const String collectionName = "banner";
    // آدرس پایه سرور شما
    const String baseUrl = "https://styleman.chbk.dev";

    final dynamic imageField = json['image'];
    List<String> fileNames = [];

    if (imageField is List) {
      fileNames = imageField.map((e) => e.toString()).toList();
    } else if (imageField is String && imageField.isNotEmpty) {
      fileNames = [imageField];
    }

    // اصلاح فرمت URL طبق استاندارد PocketBase
    final List<String> fullUrls = fileNames.map((fileName) {
      return "$baseUrl/api/files/$collectionName/$recordId/$fileName";
    }).toList();

    return BannerModel(
      id: recordId,
      images: fullUrls,
    );
  }
}