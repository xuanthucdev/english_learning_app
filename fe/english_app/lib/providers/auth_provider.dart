import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_app/core/services/user_service.dart';
import 'package:english_app/models/user_model.dart';
import '../core/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  UserModel? _user;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get user => _user;
  String? get email => _user?.email;
  String? get fullName => _user?.fullName;
  String? get phone => _user?.phone;
  String? get avatar => _user?.avatar;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Setters
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

  // SIGN UP
  Future<bool> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    setLoading(true);
    clearError();

    try {
      final result = await _authService.signUp(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
      );

      setLoading(false);

      if (result['success'] == true) {
        final userId = result['data']['user']['id'].toString();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await loadUserData();
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

  // LOGIN
  Future<bool> login(String email, String password) async {
    setLoading(true);
    clearError();

    try {
      final result = await _authService.login(
        email: email,
        password: password,
      );

      setLoading(false);

      if (result['success'] == true) {
        final userId = result['data']['user']['id'].toString();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);

        // Lưu accessToken nếu có
        final token = result['data']['accessToken'];
        if (token != null) {
          await prefs.setString('accessToken', token);
        }

        await loadUserData();
        return true;
      } else {
        setError(result['message']);
        return false;
      }
    } catch (e) {
      setLoading(false);
      setError('Có lỗi xảy ra, vui lòng thử lại');
      print('Login error: $e');
      return false;
    }
  }

  // LOAD USER DATA
  Future<void> loadUserData() async {
    setLoading(true);
    clearError();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');

      if (userId != null) {
        final user = await UserService.fetchUserInfo(int.parse(userId));
        if (user != null) {
          _user = user;
        } else {
          print('UserService returned null');
          _user = null;
        }
      } else {
        print('UserID not found in SharedPreferences');
        _user = null;
      }

      notifyListeners();
    } catch (e) {
      print('Error loading user data: $e');
      setError('Không thể tải thông tin người dùng');
      _user = null;
    } finally {
      setLoading(false);
    }
  }

  // LOGOUT
  Future<void> logout() async {
    setLoading(true);
    clearError();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      await prefs.remove('accessToken');
      _user = null;
      notifyListeners();
    } catch (e) {
      setError('Có lỗi xảy ra khi đăng xuất');
      print('Logout error: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}
