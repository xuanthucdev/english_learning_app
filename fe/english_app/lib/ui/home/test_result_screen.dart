import 'dart:convert';
import 'package:english_app/models/test_history_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:english_app/ui/home/home_screen.dart';

class TestResultScreen extends StatefulWidget {
  final String testTitle;
  final int score;
  final int totalQuestions;
  final int durationSeconds;

  const TestResultScreen({
    Key? key,
    required this.testTitle,
    required this.score,
    required this.totalQuestions,
    required this.durationSeconds,
  }) : super(key: key);

  @override
  State<TestResultScreen> createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> {
  @override
  void initState() {
    super.initState();
    _saveTestHistory();
  }

  Future<void> _saveTestHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final newEntry = TestHistoryModel(
      testTitle: widget.testTitle,
      score: widget.score,
      totalQuestions: widget.totalQuestions,
      durationSeconds: widget.durationSeconds,
      completedAt: DateTime.now(),
    );

    final historyList = prefs.getStringList('testHistory') ?? [];
    historyList.insert(0, jsonEncode(newEntry.toJson()));

    await prefs.setStringList('testHistory', historyList);
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final percentage =
        (widget.score / widget.totalQuestions * 100).toStringAsFixed(1);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/onboarding/onboarding2.jpg',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              Text("Test Completed!",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green)),
              SizedBox(height: 10),
              Text(widget.testTitle,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text("Your Score",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text("${widget.score} / ${widget.totalQuestions}",
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                      Text("$percentage%",
                          style: TextStyle(fontSize: 24, color: Colors.blue)),
                      SizedBox(height: 10),
                      Text(
                          "Time Taken: ${_formatDuration(widget.durationSeconds)}"),
                      Text("Correct Answers: ${widget.score}"),
                      Text(
                          "Incorrect Answers: ${widget.totalQuestions - widget.score}"),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text("Back to Home"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
