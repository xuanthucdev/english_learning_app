import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin management'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 30,
            ),
            _buildFunctionCard(
              context,
              icon: Icons.upload_file,
              title: 'Import Exam',
              route: '/import_exam',
            ),
            _buildFunctionCard(
              context,
              icon: Icons.download,
              title: 'Export Exam',
              route: '/export_exam',
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
            Icon(icon, size: 50, color: Colors.purple),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
