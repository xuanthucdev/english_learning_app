// lib/services/user_service.dart
import 'dart:convert';
import 'package:english_app/config/config.dart';
import 'package:english_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class UserService {
  static const String baseUrl = '${Config.baseUrl}/users';

  static Future<UserModel> fetchUserInfo(int userId) async {
    final token = await AuthService.getToken();
    if (token == null) {
      throw Exception('No authentication token found. Please log in.');
    }

    final url = Uri.parse('$baseUrl/$userId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return UserModel.fromJson(data);
    } else if (response.statusCode == 401) {
      await AuthService.deleteToken();
      throw Exception('Session expired. Please log in again.');
    } else {
      throw Exception('Failed to load user info: ${response.statusCode}');
    }
  }
}
