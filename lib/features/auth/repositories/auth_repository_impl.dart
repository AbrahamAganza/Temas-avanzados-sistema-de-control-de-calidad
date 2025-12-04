import 'package:tads/core/network/json_service.dart';
import 'package:tads/features/auth/data_sources/auth_local_data_source.dart';
import 'package:tads/features/auth/data_sources/auth_remote_data_source.dart';
import 'package:tads/features/auth/repositories/auth_repository.dart';
import 'package:tads/features/auth/models/login_response.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<LoginResponse> login(String email, String password) async {
    final loginResponse = await remoteDataSource.login(email, password);
    await localDataSource.saveAuthToken(loginResponse.token);
    await localDataSource.saveUserData(loginResponse.user);
    return loginResponse;
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.clearAuthData();
  }
}
