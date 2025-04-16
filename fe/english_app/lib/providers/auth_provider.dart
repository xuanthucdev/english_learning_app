// providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  String? _userId;
  String? _email;
  String? get userId => _userId;
  String? get email => _email;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    setLoading(true);
    setError(null);

    try {
      final result = await _authService.signUp(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );

      setLoading(false);

      if (result['success'] == true) {
        return true;
      } else {
        setError(result['message']);
        return false;
      }
    } catch (e) {
      setLoading(false);
      setError('Có lỗi xảy ra, vui lòng thử lại');
      return false;
    }
  }

  Future<bool> login(
    String email,
    String password,
  ) async {
    setLoading(true);
    setError(null);

    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );

      setLoading(false);

      if (result['success'] == true) {
        _userId = result['data']['user']['id'].toString();
        _email = result['data']['user']['email'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', _userId!);
        await prefs.setString('email', _email!);
        notifyListeners();

        return true;
      } else {
        setError(result['message']);
        return false;
      }
    } catch (e) {
      setLoading(false);
      setError('Có lỗi xảy ra, vui lòng thử lại');
      return false;
    }
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
    _email = prefs.getString('email');
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('email');
    _userId = null;
    _email = null;
    notifyListeners();
  }
}
