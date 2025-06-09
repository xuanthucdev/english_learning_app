import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - Quản lý TOEIC'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildFunctionCard(
              context,
              icon: Icons.add_circle,
              title: 'Thêm câu hỏi',
              route: '/add_question',
            ),
            _buildFunctionCard(
              context,
              icon: Icons.upload_file,
              title: 'Import đề thi',
              route: '/import_exam',
            ),
            _buildFunctionCard(
              context,
              icon: Icons.question_answer,
              title: 'Thêm câu trả lời',
              route: '/add_answer',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFunctionCard(BuildContext context,
      {required IconData icon, required String title, required String route}) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
