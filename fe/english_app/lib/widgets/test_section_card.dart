import 'package:flutter/material.dart';
import '../models/test_section.dart';

class TestSectionCard extends StatelessWidget {
  final TestSection section;

  const TestSectionCard({Key? key, required this.section}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: section.color.withOpacity(0.2),
          child: Icon(section.icon, color: section.color),
        ),
        title:
            Text(section.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(section.description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books, size: 18, color: Colors.grey),
            SizedBox(height: 4),
            Text("${section.testCount} Bài", style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
