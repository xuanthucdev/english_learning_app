import 'package:english_app/models/answer_model.dart';

class Question {
  final int id;
  final String content;
  final String? audioUrl;
  final String? imageUrl;
  final String? explanation;
  final String part;
  final String difficulty;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.content,
    this.audioUrl,
    this.imageUrl,
    this.explanation,
    required this.part,
    required this.difficulty,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      audioUrl: json['audioUrl'],
      imageUrl: json['imageUrl'],
      explanation: json['explanation'],
      part: json['part'] ?? '',
      difficulty: json['difficulty'] ?? '',
      answers: (json['answers'] as List<dynamic>? ?? [])
          .map((a) => Answer.fromJson(a))
          .toList(),
    );
  }
}
