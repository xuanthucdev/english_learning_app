import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ExportExamScreen extends StatefulWidget {
  const ExportExamScreen({super.key});

  @override
  _ExportExamScreenState createState() => _ExportExamScreenState();
}

class _ExportExamScreenState extends State<ExportExamScreen> {
  String _exportData =
      'Sample Exam Data: TOEIC Test #001\nQuestions: 100\nDuration: 120 min';
  String? _testId;
  final _idController = TextEditingController();

  Future<void> _exportFile() async {
    if (_testId == null || _testId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a test ID.')),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.107:8083/api/tests/$_testId/export'),
      );
      if (response.statusCode == 200) {
        // Lấy đường dẫn thư mục tải về
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/exported_exam_$_testId.csv';

        // Lưu file CSV
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          _exportData = utf8.decode(response.bodyBytes); // Cập nhật preview
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Exam exported and saved to $filePath!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to export exam.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during export.')),
      );
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Exam'),
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
                Text(
                  'Enter Test ID',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade900),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _idController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter test ID (e.g., 31)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _testId = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Preview Data',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade900),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Text(
                    _exportData,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _exportFile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Export',
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
