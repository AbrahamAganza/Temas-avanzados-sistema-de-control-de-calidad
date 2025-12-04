import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Auth Token
  static Future<void> setAuthToken(String token) async {
    await _storage.write(key: 'authToken', value: token);
  }

  static Future<String?> getAuthToken() async {
    return await _storage.read(key: 'authToken');
  }

  // User Data
  static Future<void> setUserData({
    required int id,
    required String fullName,
    required String avatar,
  }) async {
    await Future.wait([
      _storage.write(key: 'id', value: id.toString()),
      _storage.write(key: 'fullName', value: fullName),
      _storage.write(key: 'avatar', value: avatar),
    ]);
  }

  static Future<Map<String, String?>> getUserData() async {
    final results = await Future.wait([
      _storage.read(key: 'id'),
      _storage.read(key: 'fullName'),
      _storage.read(key: 'avatar'),
    ]);

    return {
      'id': results[0],
      'fullName': results[1],
      'avatar': results[2],
    };
  }

  static Future<int?> getMyId() async {
    final storedId = await _storage.read(key: 'id');
    if (storedId == null) return null;
    return int.tryParse(storedId);
  }

  // Check if the given userId is the current user
  static Future<bool> isCurrentUser(int userId) async {
    final myId = await getMyId();
    return myId != null && myId == userId;
  }

  // Clear all data (logout)
  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  // Clear specific keys
  static Future<void> clearUserData() async {
    await Future.wait([
      _storage.delete(key: 'id'),
      _storage.delete(key: 'authToken'),
      _storage.delete(key: 'fullName'),
      _storage.delete(key: 'avatar'),
    ]);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }
}
