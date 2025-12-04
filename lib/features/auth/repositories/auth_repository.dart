import 'package:tads/features/auth/models/login_response.dart';

abstract class AuthRepository {
  Future<LoginResponse> login(String email, String password);
  Future<void> logout();
}
