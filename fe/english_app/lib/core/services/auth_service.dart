// core/services/auth_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:english_app/core/utils/logger.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'http://192.168.0.101:8083/auth';

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
        final errorMsg = responseData['message'] ?? 'Đăng ký thất bại';
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

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print(responseData);
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Đăng nhập thất bại'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Có lỗi xảy ra: ${e.toString()}'};
    }
  }
}
