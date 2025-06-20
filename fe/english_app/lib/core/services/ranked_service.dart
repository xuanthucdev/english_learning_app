import 'dart:convert';
import 'package:english_app/config/config.dart';
import 'package:english_app/models/ranked_model.dart';
import 'package:http/http.dart' as http;

class RankService {
  static const String baseUrl = '${Config.baseUrl}/api/rank/top10';

  static Future<List<RankedUser>> fetchRanking() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => RankedUser.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load ranking data');
    }
  }
}
