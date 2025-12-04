import 'package:flutter/foundation.dart';
import 'package:tads/features/auth/repositories/auth_repository.dart';
import 'package:tads/providers/auth_provider.dart';

class LoginController extends ChangeNotifier {
  final AuthRepository _authRepository;
  final AuthProvider _authProvider;

  LoginController(this._authRepository, this._authProvider);

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _authRepository.login(email, password);

      await _authProvider.login(response.user.id.toString(), response.token);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      if (kDebugMode) {
        print(_errorMessage);
      }
      notifyListeners();
      return false;
    }
  }
}
