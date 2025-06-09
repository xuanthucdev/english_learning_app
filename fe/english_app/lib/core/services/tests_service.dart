import 'dart:async';
import 'dart:convert';
import 'package:english_app/config/config.dart';
import 'package:english_app/models/test_model.dart';
import 'package:http/http.dart' as http;

class TestApiService {
  static const String baseUrl = '${Config.baseUrl}/api/tests';
  final http.Client client;

  TestApiService({http.Client? client}) : this.client = client ?? http.Client();

  Future<List<Test>> _fetchTests(String endpoint) async {
    try {
      final uri = Uri.parse('$baseUrl/$endpoint');
      print('Requesting API: $uri'); // Debug URL

      final response = await client.get(uri).timeout(Duration(seconds: 15));

      print('API Response Status: ${response.statusCode}');
      print(
          'Response Body Sample: ${response.body.substring(0, 100)}...'); // Xem 100 ký tự đầu

      if (response.statusCode == 200) {
        try {
          final dynamic decoded = json.decode(response.body);

          // Xử lý nhiều định dạng response khác nhau
          if (decoded is List) {
            return decoded.map((json) => Test.fromJson(json)).toList();
          } else if (decoded['data'] is List) {
            return (decoded['data'] as List)
                .map((json) => Test.fromJson(json))
                .toList();
          } else if (decoded['tests'] is List) {
            return (decoded['tests'] as List)
                .map((json) => Test.fromJson(json))
                .toList();
          } else {
            throw FormatException('Unexpected JSON format');
          }
        } on FormatException catch (e) {
          print('JSON Decoding Error: $e');
          print('Full Response Body: ${response.body}');
          throw Exception('Invalid server response format');
        }
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timeout. Please try again.');
    } on http.ClientException catch (e) {
      print('Network Error: $e');
      throw Exception('Network connection failed');
    } catch (e) {
      print('Unexpected Error: $e');
      throw Exception('Failed to load data');
    }
  }

  Future<List<Test>> getFullTests() => _fetchTests('fulltest');
  Future<List<Test>> getAPTests() => _fetchTests('aptitudetest');
  Future<List<Test>> getMiniTests() => _fetchTests('minitest');

  Future<Test> getTestDetail(int testId) async {
    try {
      final uri = Uri.parse('$baseUrl/$testId');
      print('Requesting test detail: $uri');

      final response = await client.get(uri).timeout(Duration(seconds: 15));

      print('Test Detail Response: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final decoded = json.decode(response.body);
          return Test.fromJson(decoded);
        } on FormatException catch (e) {
          print('JSON Decoding Error: $e');
          throw Exception('Invalid test detail format');
        }
      } else {
        throw Exception('Failed to load test detail: ${response.statusCode}');
      }
    } on TimeoutException {
      throw Exception('Request timeout. Please try again.');
    } catch (e) {
      print('Error fetching test detail: $e');
      throw Exception('Failed to load test detail');
    }
  }

  Future<void> submitTestResults({
    required int testId,
    required Map<int, int?> selectedAnswers,
    required int durationSeconds,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/$testId/submit');
      print('Submitting test results to: $uri');

      // Chuẩn bị dữ liệu để gửi
      final answersMap = selectedAnswers.map((questionIndex, answerIndex) =>
          MapEntry(questionIndex.toString(), answerIndex.toString()));

      final body = json.encode({
        'answers': answersMap,
        'duration': durationSeconds,
        'timestamp': DateTime.now().toIso8601String(),
      });

      print('Submission Body: $body');

      final response = await client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: body,
          )
          .timeout(Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception('Submission failed: ${response.statusCode}');
      }

      print('Submission successful');
    } on TimeoutException {
      throw Exception('Submission timeout. Please try again.');
    } catch (e) {
      print('Error submitting test: $e');
      throw Exception('Failed to submit test results');
    }
  }
}
