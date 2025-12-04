import 'package:tads/api/endpoints.dart';
import 'package:tads/core/network/json_service.dart';
import 'package:tads/features/auth/models/login_response.dart';
import 'package:tads/features/auth/models/user_dto.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponse> login(String email, String password);
  Future<bool> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final JsonService jsonService;

  AuthRemoteDataSourceImpl(this.jsonService);

  @override
  Future<LoginResponse> login(String email, String password) async {
    // Load the list of users from the simulated backend (JSON file).
    final users = await jsonService.get(Endpoints.login);

    // Find the user that matches both email and password.
    try {
      final user = (users as List).firstWhere(
        (u) => u['email'] == email && u['password'] == password,
      );

      // If found, return a successful response.
      return LoginResponse(
        user: User.fromJson(user),
        token: 'fake-token-for-${user['id']}',
      );
    } catch (e) {
      // If not found, throw a clear error.
      throw Exception('Usuario no encontrado o contraseña incorrecta');
    }
  }

  @override
  Future<bool> logout() async {
    return true;
  }
}
