import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tads/core/network/json_service.dart';
import 'package:tads/features/auth/data_sources/auth_local_data_source.dart';
import 'package:tads/features/auth/data_sources/auth_remote_data_source.dart';
import 'package:tads/features/auth/repositories/auth_repository.dart';
import 'package:tads/features/auth/repositories/auth_repository_impl.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AuthRepository authRepository;
  String? _userId;
  String? _token;
  bool _isLoading = true;

  String? get userId => _userId;
  String? get token => _token;
  bool get isLoggedIn => _token != null && _token!.isNotEmpty;
  bool get isLoading => _isLoading;

  AuthProvider() : authRepository = AuthRepositoryImpl(
          remoteDataSource: AuthRemoteDataSourceImpl(JsonService()),
          localDataSource: AuthLocalDataSourceImpl(),
        ) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _token = await _storage.read(key: 'authToken');
    _userId = await _storage.read(key: 'userId');
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String userId, String token) async {
    _userId = userId;
    _token = token;
    await _storage.write(key: 'userId', value: userId);
    await _storage.write(key: 'authToken', value: token);
    notifyListeners();
  }

  Future<void> logout() async {
    _userId = null;
    _token = null;
    await _storage.delete(key: 'userId');
    await _storage.delete(key: 'authToken');
    notifyListeners();
  }
}
