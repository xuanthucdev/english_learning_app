// core/services/file_service.dart
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:english_app/core/utils/logger.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';

class FileService {
  static const String _baseUrl = 'http://192.168.0.107:8083/api/files';

  Future<Map<String, dynamic>> uploadFile(File file) async {
    try {
      AppLogger.info('Attempting to upload file: ${file.path}');

      // Get file info
      final filename = basename(file.path);
      final extension = filename.split('.').last.toLowerCase();
      final mimeType = _getMimeType(extension);
      final fileSize = await file.length();

      AppLogger.debug('File info: $filename, $mimeType, ${fileSize} bytes');

      // Create multipart request
      var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/upload'))
        ..files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType.parse(mimeType),
        ));

      // Send request with timeout
      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));

      final response = await http.Response.fromStream(streamedResponse);
      AppLogger.debug(
          'API Response: ${response.statusCode} - ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        AppLogger.info(
            'File uploaded successfully: ${responseData['filename']}');
        return {
          'success': true,
          'data': {
            'id': responseData['id'].toString(),
            'filename': responseData['filename'],
            'originalFilename': responseData['originalFilename'],
            'contentType': responseData['contentType'],
            'size': responseData['size'],
            'url': responseData['url'],
          }
        };
      } else {
        final errorMsg = responseData['message'] ?? 'Upload file thất bại';
        AppLogger.error('Upload failed: $errorMsg');
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

  Future<Map<String, dynamic>> deleteFile(String fileId) async {
    try {
      AppLogger.info('Attempting to delete file: $fileId');

      final response = await http.delete(
        Uri.parse('$_baseUrl/$fileId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      AppLogger.debug(
          'API Response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 204) {
        AppLogger.info('File deleted successfully: $fileId');
        return {'success': true};
      } else {
        final responseData = jsonDecode(response.body);
        final errorMsg = responseData['message'] ?? 'Xóa file thất bại';
        AppLogger.error('Delete failed: $errorMsg');
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

  String _getMimeType(String extension) {
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      default:
        return 'application/octet-stream';
    }
  }
}
