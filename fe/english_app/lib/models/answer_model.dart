class Answer {
  final int id;
  final String content;
  final bool isCorrect;
  final int answerOrder;

  Answer({
    required this.id,
    required this.content,
    required this.isCorrect,
    required this.answerOrder,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      content: json['content'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
      answerOrder: json['answerOrder'] ?? 0,
    );
  }
}
