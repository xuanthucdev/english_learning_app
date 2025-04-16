class Test {
  final String title;
  final String description;
  final int durationMinutes;
  final int questionCount;
  final String testType;
  final bool free;

  Test({
    required this.title,
    required this.description,
    required this.durationMinutes,
    required this.questionCount,
    required this.testType,
    required this.free,
  });

  factory Test.fromJson(Map<String, dynamic> json) {
    return Test(
      title: json['title'] ?? 'Untitled Test',
      description: json['description'] ?? 'No description',
      durationMinutes: json['durationMinutes'] ?? 0,
      questionCount: json['questionCount'] ?? 0,
      testType: json['testType'] ?? 'Unknown',
      free: json['free'] ?? false,
    );
  }
}
