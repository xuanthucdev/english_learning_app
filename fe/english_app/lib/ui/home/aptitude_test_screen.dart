import 'package:flutter/material.dart';
import 'package:english_app/core/services/tests_service.dart';
import 'package:english_app/models/test_model.dart';
import 'package:english_app/ui/home/test_detail_screen.dart';

class AptitudeTestScreen extends StatefulWidget {
  @override
  _AptitudeTestScreenState createState() => _AptitudeTestScreenState();
}

class _AptitudeTestScreenState extends State<AptitudeTestScreen> {
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
      final fetchedTests = await _testService.getAPTests();
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
        title: Text(
          "Aptitude Tests",
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
        child: Icon(Icons.refresh),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage,
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadTests,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (tests.isEmpty) {
      return Center(
        child: Text(
          'No aptitude tests available',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: tests.length,
      itemBuilder: (context, index) {
        final test = tests[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _navigateToTestDetail(test),
            child: Padding(
              padding: EdgeInsets.all(16),
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
                  SizedBox(height: 8),
                  Text(
                    test.description ?? 'No description available',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  SizedBox(height: 12),
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
