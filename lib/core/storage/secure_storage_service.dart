import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static String jwtKey = "jwt";

  static Future<void> writeValue({
    required String key,
    required String? value,
  }) async {
    await FlutterSecureStorage().write(key: key, value: value);
  }

  static Future<String?> readValue({required String key}) async {
    return await FlutterSecureStorage().read(key: key);
  }
}
