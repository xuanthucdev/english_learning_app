import 'dart:convert';
import 'dart:io';
import 'package:english_app/config/config.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ExamService {
  static const String _baseUrl = '${Config.baseUrl}/api';

  static Future<Map<String, dynamic>> exportExam(String testId) async {
    try {
      final response =
          await http.get(Uri.parse('$_baseUrl/tests/$testId/export'));

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/exported_exam_$testId.csv';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        return {
          'success': true,
          'filePath': filePath,
          'content': utf8.decode(response.bodyBytes),
        };
      } else {
        return {'success': false, 'message': 'Failed to export exam.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error during export: $e'};
    }
  }

  static Future<Map<String, dynamic>> importExam(String filePath) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$_baseUrl/tests/import'),
      );
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      var response = await request.send();

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        return {'success': false, 'message': 'Failed to import exam.'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error during import: $e'};
    }
  }
}
