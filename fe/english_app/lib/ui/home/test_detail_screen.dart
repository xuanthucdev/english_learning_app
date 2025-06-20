import 'dart:async';
import 'package:english_app/core/services/tests_service.dart';
import 'package:english_app/core/services/user_service.dart';
import 'package:english_app/models/question_model.dart';
import 'package:english_app/models/test_model.dart';
import 'package:english_app/models/user_model.dart';
import 'package:english_app/ui/home/test_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final TestApiService _testService = TestApiService();
  late DateTime startTime;
  int? userId;
  UserModel? user;
  int currentPage = 0;
  final int questionsPerPage = 5;
  final ScrollController _scrollController = ScrollController();

  // Audio state
  bool _isPlaying = false;
  String? _currentAudioUrl;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.test.durationMinutes * 60;
    startTime = DateTime.now();
    _fetchUserIdAndInfo();
    startTimer();
  }

  List<Question> _getPaginatedQuestions() {
    final start = currentPage * questionsPerPage;
    final end = start + questionsPerPage;
    return widget.test.questions.sublist(
      start,
      end > widget.test.questions.length ? widget.test.questions.length : end,
    );
  }

  Future<void> _fetchUserIdAndInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fetchedUserId = prefs.getString('userId');
      final int? userIdInt =
          fetchedUserId != null ? int.tryParse(fetchedUserId) : null;
      if (fetchedUserId == null) {
        throw Exception('User ID not found. Please log in.');
      }
      final fetchedUser = await UserService.fetchUserInfo(userIdInt!);
      setState(() {
        userId = userIdInt;
        user = fetchedUser;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user info: ${e.toString()}')),
      );
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Future<void> _submitTest() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('User ID not available. Please log in again.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final durationSeconds =
          widget.test.durationMinutes * 60 - remainingSeconds;

      await _testService.submitTestResults(
        testId: widget.test.id,
        selectedAnswers: selectedAnswers,
        durationSeconds: durationSeconds,
        userId: userId!,
        startTime: startTime,
      );

      int score = 0;
      for (var entry in selectedAnswers.entries) {
        if (entry.value != null && entry.value! % 2 == 0) {
          score++;
        }
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TestResultScreen(
            testTitle: widget.test.title,
            score: score,
            totalQuestions: widget.test.questionCount,
            durationSeconds: durationSeconds,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit test: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _stopAudio() async {
    try {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
        _currentAudioUrl = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to stop audio: ${e.toString()}')),
      );
    }
  }

  Future<void> _playAudio(String? url) async {
    if (url == null) return;

    try {
      if (_isPlaying && _currentAudioUrl == url) {
        await _stopAudio();
      } else {
        await _audioPlayer.stop();
        await _audioPlayer.play(UrlSource(url));
        setState(() {
          _isPlaying = true;
          _currentAudioUrl = url;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to play audio: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = (widget.test.questions.length / questionsPerPage).ceil();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.test.title),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                formatTime(remainingSeconds),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTestInfo(),
            const SizedBox(height: 20),
            ..._getPaginatedQuestions().asMap().entries.map((entry) {
              final index = currentPage * questionsPerPage + entry.key;
              final question = entry.value;
              return _buildQuestionCard(question, index);
            }).toList(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 0
                      ? () {
                          setState(() => currentPage--);
                          _scrollToTop();
                        }
                      : null,
                  child: const Text('Previous'),
                ),
                Text('Page ${currentPage + 1} of $totalPages'),
                ElevatedButton(
                  onPressed: (currentPage + 1) * questionsPerPage <
                          widget.test.questions.length
                      ? () {
                          setState(() => currentPage++);
                          _scrollToTop();
                        }
                      : null,
                  child: const Text('Next'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: _isSubmitting
                  ? null
                  : () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Submit Test'),
                          content: const Text(
                              'Are you sure you want to submit your answers?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                _submitTest();
                              },
                              child: const Text('Submit'),
                            ),
                          ],
                        ),
                      );
                    },
              icon: const Icon(Icons.check),
              label: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Test'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTestInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
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
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${questionIndex + 1} (Part ${question.part})',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              question.content,
              style: const TextStyle(fontSize: 16),
            ),
            if (question.audioUrl != null) ...[
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _playAudio(question.audioUrl),
                icon: Icon(
                  _isPlaying && _currentAudioUrl == question.audioUrl
                      ? Icons.stop
                      : Icons.play_arrow,
                ),
                label: Text(
                  _isPlaying && _currentAudioUrl == question.audioUrl
                      ? 'Stop Audio'
                      : 'Play Audio',
                ),
              ),
            ],
            if (question.imageUrl != null) ...[
              const SizedBox(height: 12),
              Image.network(
                question.imageUrl!,
                height: 150,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 50),
              ),
            ],
            const SizedBox(height: 12),
            ...question.answers.map((answer) {
              return RadioListTile<int>(
                title: Text(answer.content),
                value: answer.id,
                groupValue: selectedAnswers[question.id],
                onChanged: (value) {
                  setState(() {
                    selectedAnswers[question.id] = value;
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
