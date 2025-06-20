import 'package:english_app/core/services/exam_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ImportExamScreen extends StatefulWidget {
  const ImportExamScreen({super.key});

  @override
  _ImportExamScreenState createState() => _ImportExamScreenState();
}

class _ImportExamScreenState extends State<ImportExamScreen> {
  String? _filePath;
  final _picker = FilePicker.platform;

  Future<void> _pickFile() async {
    final result = await _picker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json', 'csv'],
    );
    if (result != null) {
      setState(() {
        _filePath = result.files.single.path;
      });
    }
  }

  Future<void> _importFile() async {
    if (_filePath == null) return;

    final result = await ExamService.importExam(_filePath!);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exam Imported Successfully!')),
      );
      setState(() {
        _filePath = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Failed to import exam.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Exam'),
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Container(
        color: Colors.purple.shade50,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _pickFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Select File',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                if (_filePath != null)
                  Text(
                    'Selected File: $_filePath',
                    style:
                        TextStyle(fontSize: 14, color: Colors.purple.shade900),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _filePath == null ? null : _importFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Import',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
