// core/providers/file_provider.dart
import 'dart:io';
import 'package:english_app/core/services/file_service.dart';
import 'package:flutter/foundation.dart';

class FileProvider with ChangeNotifier {
  final FileService _fileService;

  FileProvider(this._fileService);

  Future<Map<String, dynamic>> uploadFile(File file) async {
    final result = await _fileService.uploadFile(file);
    if (result['success']) {
      notifyListeners();
    }
    return result;
  }

  Future<Map<String, dynamic>> deleteFile(String fileId) async {
    final result = await _fileService.deleteFile(fileId);
    if (result['success']) {
      notifyListeners();
    }
    return result;
  }
}
