import 'dart:convert';
import 'package:english_app/config/config.dart';
import 'package:english_app/models/grammar_model.dart';
import 'package:http/http.dart' as http;

class GrammarService {
  static const String baseUrl = '${Config.baseUrl}/api/vocabularies';

  static Future<List<Grammar>> fetchGrammarTopics() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((e) => Grammar.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load vocabularies');
    }
  }
}
