import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tads/features/auth/models/user_dto.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> saveUserData(User user);
  Future<User?> getUserData();
  Future<void> clearAuthData();
  Future<bool> isLoggedIn();

  Future<String?> getUserId();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: 'authToken', value: token);
  }

  @override
  Future<String?> getAuthToken() async {
    return await _storage.read(key: 'authToken');
  }

  @override
  Future<void> saveUserData(User user) async {
    await _storage.write(key: 'userId', value: user.id.toString());
    await _storage.write(key: 'fullName', value: user.fullName);
    await _storage.write(key: 'avatar', value: user.avatar);
  }

  @override
  Future<User?> getUserData() async {
    try {
      final id = await _storage.read(key: 'userId');
      final fullName = await _storage.read(key: 'fullName');
      final avatar = await _storage.read(key: 'avatar');
      final email = await _storage.read(key: 'email');

      if (id != null && fullName != null && avatar != null && email != null) {
        return User(
          id: int.parse(id),
          fullName: fullName,
          email: email,
          avatar: avatar,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> getUserId() async {
    return await _storage.read(key: 'userId');
  }

  @override
  Future<void> clearAuthData() async {
    await _storage.delete(key: 'authToken');
    await _storage.delete(key: 'userId');
    await _storage.delete(key: 'fullName');
    await _storage.delete(key: 'avatar');
    await _storage.delete(key: 'email');
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }
}
