import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ImportExamScreen extends StatefulWidget {
  @override
  _ImportExamScreenState createState() => _ImportExamScreenState();
}

class _ImportExamScreenState extends State<ImportExamScreen> {
  String _message = '';

  Future<void> _importExam() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json', 'csv'],
      );

      if (result != null) {
        setState(() {
          _message = 'Đã chọn file: ${result.files.single.name}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Lỗi khi import: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Import đề thi')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Import đề thi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _importExam,
              icon: Icon(Icons.upload_file),
              label: Text('Chọn file đề thi (JSON/CSV)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            Text(
              _message,
              style: TextStyle(
                color: _message.contains('Lỗi') ? Colors.red : Colors.green,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
