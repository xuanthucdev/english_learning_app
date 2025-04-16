import 'dart:convert';
import 'package:english_app/models/test_model.dart';
import 'package:http/http.dart' as http;

class TestApiService {
  static const String baseUrl = 'http://192.168.0.101:8083/api/tests';

  Future<List<Test>> getFullTests() async {
    final response = await http.get(Uri.parse('$baseUrl/fulltest'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((test) => Test.fromJson(test)).toList();
    } else {
      throw Exception('Failed to load tests');
    }
  }

  Future<List<Test>> getAPTests() async {
    final response = await http.get(Uri.parse('$baseUrl/aptitudetest'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((test) => Test.fromJson(test)).toList();
    } else {
      throw Exception('Failed to load tests');
    }
  }

  Future<List<Test>> getMiniTests() async {
    final response = await http.get(Uri.parse('$baseUrl/minitest'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((test) => Test.fromJson(test)).toList();
    } else {
      throw Exception('Failed to load tests');
    }
  }
}
