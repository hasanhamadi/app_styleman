import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageHelper {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<void> saveAuthData(String token, String userId) async {
    await _storage.write(key: 'token', value: token);
    await _storage.write(key: 'userId', value: userId);
  }

  static Future<String?> getToken() async => await _storage.read(key: 'token');
  static Future<void> clearAll() async => await _storage.deleteAll();
}