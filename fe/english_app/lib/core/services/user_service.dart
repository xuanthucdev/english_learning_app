// lib/services/user_service.dart
import 'dart:convert';
import 'package:english_app/config/config.dart';
import 'package:english_app/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';
import 'package:http_parser/http_parser.dart'; // để chỉ định MIME type
import 'dart:io'; // để sử dụng File

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

  static Future<String?> uploadAvatar({
    required int userId,
    required File avatarFile,
  }) async {
    final url = Uri.parse('$baseUrl/$userId/avatar');

    final request = http.MultipartRequest('POST', url)
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          avatarFile.path,
          contentType: MediaType('image', 'jpeg'), // hoặc 'png' nếu cần
        ),
      );

    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final json = jsonDecode(body);
      return json['avatar']; // assuming response contains { "avatar": "url" }
    } else {
      print('Upload failed: ${response.statusCode}');
      return null;
    }
  }

  Future<bool> updateUser({
    required int userId,
    required String fullName,
    required String phone,
    String? avatarUrl,
    String? email,
  }) async {
    final url = Uri.parse('$baseUrl/$userId');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'fullName': fullName,
        'phone': phone,
        'avatar': avatarUrl,
        'email': email,
      }),
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}
