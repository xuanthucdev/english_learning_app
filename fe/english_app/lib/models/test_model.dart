import 'package:english_app/models/question_model.dart';

class Test {
  final int id;
  final String title;
  final String? description;
  final String testType;
  final int durationMinutes;
  final int questionCount;
  final DateTime createdAt;
  final bool free;
  final List<Question> questions;

  Test({
    required this.id,
    required this.title,
    this.description,
    required this.testType,
    required this.durationMinutes,
    required this.questionCount,
    required this.createdAt,
    required this.free,
    required this.questions,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'],
      testType: json['testType'] ?? '',
      durationMinutes: json['durationMinutes'] ?? 0,
      questionCount: json['questionCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      free: json['free'] ?? true,
      questions: (json['questions'] as List<dynamic>? ?? [])
          .map((q) => Question.fromJson(q))
          .toList(),
    );
  }
}
