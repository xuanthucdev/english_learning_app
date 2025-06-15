import 'package:flutter/material.dart';
import 'package:english_app/core/services/tests_service.dart';
import 'package:english_app/models/test_model.dart';
import 'package:english_app/ui/home/test_detail_screen.dart';

class FullTestScreen extends StatefulWidget {
  @override
  _FullTestScreenState createState() => _FullTestScreenState();
}

class _FullTestScreenState extends State<FullTestScreen> {
  final TestApiService _testService = TestApiService();
  List<Test> tests = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadTests();
  }

  Future<void> _loadTests() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final fetchedTests = await _testService.getFullTests();
      setState(() {
        tests = fetchedTests;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = _getUserFriendlyError(e.toString());
      });
      print('Error loading tests: $e');
    }
  }

  String _getUserFriendlyError(String error) {
    if (error.contains('timeout')) {
      return 'Request timeout. Please check your connection.';
    } else if (error.contains('Network')) {
      return 'Network unavailable. Please check your internet.';
    } else {
      return 'Failed to load tests. Please try again later.';
    }
  }

  Future<void> _navigateToTestDetail(Test test) async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final testWithQuestions = await _testService.getTestDetail(test.id);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TestDetailScreen(test: testWithQuestions),
        ),
      );
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load test details';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Full Tests",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.purple,
        elevation: 0,
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadTests,
        child: const Icon(Icons.refresh),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadTests,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (tests.isEmpty) {
      return const Center(
        child: Text(
          'No full tests available',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tests.length,
      itemBuilder: (context, index) {
        final test = tests[index];
        return Card(
          elevation: 4,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _navigateToTestDetail(test),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    test.title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text('${test.questionCount} questions'),
                        backgroundColor: Colors.purple.shade100,
                      ),
                      Chip(
                        label: Text('${test.durationMinutes} min'),
                        backgroundColor: Colors.purple.shade100,
                      ),
                      Chip(
                        label: Text(test.free ? 'Free' : 'Premium'),
                        backgroundColor: test.free
                            ? Colors.green.shade100
                            : Colors.amber.shade100,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
