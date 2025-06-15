// core/services/auth_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:english_app/core/utils/logger.dart';
import 'package:http/http.dart' as http;
import '../../config/config.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthService {
  static const String _baseUrl = '${Config.baseUrl}/auth';
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'auth_token';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    AppLogger.info('Token saved successfully');
  }

  static Future<String?> getToken() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null) {
      AppLogger.warning('No token found in storage');
    }
    return token;
  }

  static Future<int?> getUserId() async {
    final token = await getToken();
    if (token == null) return null;
    try {
      final payload = Jwt.parseJwt(token);
      return payload['userId'] as int?;
    } catch (e) {
      AppLogger.error('Failed to decode token: $e');
      return null;
    }
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    AppLogger.info('Token deleted successfully');
  }

  Future<Map<String, dynamic>> signUp({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      AppLogger.info('Attempting to sign up user: $email');
      AppLogger.debug('Request data: $fullName, $email, $phone, $password');
      final response = await http
          .post(
            Uri.parse('$_baseUrl/signup'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(
              {
                'fullName': fullName,
                'email': email,
                'phone': phone,
                'password': password,
              },
            ),
          )
          .timeout(const Duration(seconds: 30));

      AppLogger.debug(
          'API Response: ${response.statusCode} - ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        AppLogger.info('Sign up successful for: $email');
        return {'success': true, 'data': responseData};
      } else {
        final errorMsg = responseData['message'] ?? 'Registration failed';
        AppLogger.error('Sign up failed: $errorMsg');
        return {'success': false, 'message': errorMsg};
      }
    } on http.ClientException catch (e) {
      AppLogger.error('HTTP Client Exception', e);
      return {'success': false, 'message': 'Không thể kết nối đến máy chủ'};
    } on TimeoutException catch (e) {
      AppLogger.error('Request timeout', e);
      return {'success': false, 'message': 'Kết nối quá lâu, vui lòng thử lại'};
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error', e, stackTrace);
      return {'success': false, 'message': 'Có lỗi xảy ra: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Attempting to log in user: $email');
      AppLogger.debug('Request data: $email, $password');
      final response = await http
          .post(
            Uri.parse('$_baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 30));

      AppLogger.debug(
          'API Response: ${response.statusCode} - ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final token =
            responseData['accessToken']; // Giả sử token nằm trong 'accessToken'
        if (token != null) {
          await saveToken(token); // Lưu token vào secure storage
          AppLogger.info('Login successful for: $email, token saved');
        }
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        final errorMsg = responseData['message'] ?? 'Login failed';
        AppLogger.error('Login failed: $errorMsg');
        return {
          'success': false,
          'message': errorMsg,
        };
      }
    } on http.ClientException catch (e) {
      AppLogger.error('HTTP Client Exception', e);
      return {'success': false, 'message': 'Không thể kết nối đến máy chủ'};
    } on TimeoutException catch (e) {
      AppLogger.error('Request timeout', e);
      return {'success': false, 'message': 'Kết nối quá lâu, vui lòng thử lại'};
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error', e, stackTrace);
      return {'success': false, 'message': 'Có lỗi xảy ra: ${e.toString()}'};
    }
  }
}
