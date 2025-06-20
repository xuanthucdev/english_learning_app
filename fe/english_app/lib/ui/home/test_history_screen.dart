import 'dart:convert';
import 'package:english_app/models/test_history_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_app/ui/home/home_screen.dart';
import 'package:intl/intl.dart';

class TestHistoryScreen extends StatefulWidget {
  const TestHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TestHistoryScreen> createState() => _TestHistoryScreenState();
}

class _TestHistoryScreenState extends State<TestHistoryScreen> {
  List<TestHistoryModel> _testHistory = [];

  @override
  void initState() {
    super.initState();
    _loadTestHistory();
  }

  Future<void> _loadTestHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyList = prefs.getStringList('testHistory') ?? [];

    setState(() {
      _testHistory = historyList
          .map((e) => TestHistoryModel.fromJson(jsonDecode(e)))
          .toList();
    });
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _formatDateTime(DateTime dt) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test History'),
        backgroundColor: Colors.purple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
      ),
      body: _testHistory.isEmpty
          ? Center(child: Text('No test history found'))
          : ListView.builder(
              itemCount: _testHistory.length,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final item = _testHistory[index];
                final percentage =
                    (item.score / item.totalQuestions * 100).toStringAsFixed(1);

                return Card(
                  elevation: 4,
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.testTitle,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple)),
                        SizedBox(height: 8),
                        Text(
                            'Score: ${item.score} / ${item.totalQuestions} ($percentage%)'),
                        Text(
                            'Time Taken: ${_formatDuration(item.durationSeconds)}'),
                        Text('Completed: ${_formatDateTime(item.completedAt)}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
