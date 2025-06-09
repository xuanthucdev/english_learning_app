import 'dart:async';
import 'package:english_app/core/services/tests_service.dart';
import 'package:english_app/models/question_model.dart';
import 'package:flutter/material.dart';
import 'package:english_app/models/test_model.dart';
import 'package:audioplayers/audioplayers.dart';

class TestDetailScreen extends StatefulWidget {
  final Test test;

  const TestDetailScreen({required this.test, Key? key}) : super(key: key);

  @override
  _TestDetailScreenState createState() => _TestDetailScreenState();
}

class _TestDetailScreenState extends State<TestDetailScreen> {
  late int remainingSeconds;
  Timer? timer;
  Map<int, int?> selectedAnswers = {};
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.test.durationMinutes * 60;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds <= 0) {
        timer.cancel();
        _submitTest();
      } else {
        setState(() {
          remainingSeconds--;
        });
      }
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _submitTest() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final durationSeconds =
          widget.test.durationMinutes * 60 - remainingSeconds;
      final testService = TestApiService();
      await testService.submitTestResults(
        testId: widget.test.id,
        selectedAnswers: selectedAnswers,
        durationSeconds: durationSeconds,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Test submitted successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _playAudio(String? url) async {
    if (url == null) return;

    try {
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to play audio: $e')),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.test.title),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                formatTime(remainingSeconds),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTestInfo(),
            SizedBox(height: 20),
            ...widget.test.questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              return _buildQuestionCard(question, index);
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Submit Test'),
              content: Text('Are you sure you want to submit your answers?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _submitTest();
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          );
        },
        child: _isSubmitting
            ? CircularProgressIndicator(color: Colors.white)
            : Icon(Icons.check),
      ),
    );
  }

  Widget _buildTestInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            Text('Type: ${widget.test.testType}'),
            Text('Duration: ${widget.test.durationMinutes} minutes'),
            Text('Questions: ${widget.test.questionCount}'),
            Text('Status: ${widget.test.free ? 'Free' : 'Premium'}'),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard(Question question, int questionIndex) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${questionIndex + 1} (Part ${question.part})',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            SizedBox(height: 8),
            Text(
              question.content,
              style: TextStyle(fontSize: 16),
            ),
            if (question.audioUrl != null) ...[
              SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _playAudio(question.audioUrl),
                icon: Icon(Icons.volume_up),
                label: Text('Play Audio'),
              ),
            ],
            if (question.imageUrl != null) ...[
              SizedBox(height: 12),
              Image.network(
                question.imageUrl!,
                height: 150,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, size: 50),
              ),
            ],
            SizedBox(height: 12),
            ...question.answers.map((answer) {
              final answerIndex = question.answers.indexOf(answer);
              return RadioListTile<int>(
                title: Text(answer.content),
                value: answerIndex,
                groupValue: selectedAnswers[questionIndex],
                onChanged: (value) {
                  setState(() {
                    selectedAnswers[questionIndex] = value;
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
