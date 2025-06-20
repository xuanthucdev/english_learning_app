class TestHistoryModel {
  final String testTitle;
  final int score;
  final int totalQuestions;
  final int durationSeconds;
  final DateTime completedAt;

  TestHistoryModel({
    required this.testTitle,
    required this.score,
    required this.totalQuestions,
    required this.durationSeconds,
    required this.completedAt,
  });

  Map<String, dynamic> toJson() => {
        'testTitle': testTitle,
        'score': score,
        'totalQuestions': totalQuestions,
        'durationSeconds': durationSeconds,
        'completedAt': completedAt.toIso8601String(),
      };

  factory TestHistoryModel.fromJson(Map<String, dynamic> json) {
    return TestHistoryModel(
      testTitle: json['testTitle'],
      score: json['score'],
      totalQuestions: json['totalQuestions'],
      durationSeconds: json['durationSeconds'],
      completedAt: DateTime.parse(json['completedAt']),
    );
  }
}
