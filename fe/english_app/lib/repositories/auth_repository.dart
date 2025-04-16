// repositories/auth_repository.dart
import '../core/services/auth_service.dart';

class AuthRepository {
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      return {'success': false, 'message': 'Mật khẩu xác nhận không khớp'};
    }

    return await _authService.signUp(
      fullName: fullName,
      email: email,
      phone: phone,
      password: password,
    );
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    return await _authService.login(
      email: email,
      password: password,
    );
  }
}
