class Grammar {
  final int id;
  final String word;
  final String definition;
  final String example;
  final String topic;
  final String difficulty;
  final String toeicFrequency;

  Grammar({
    required this.id,
    required this.word,
    required this.definition,
    required this.example,
    required this.topic,
    required this.difficulty,
    required this.toeicFrequency,
  });

  factory Grammar.fromJson(Map<String, dynamic> json) {
    return Grammar(
      id: json['id'],
      word: json['word'] ?? '',
      definition: json['definition'] ?? '',
      example: json['example'] ?? '',
      topic: json['topic'] ?? '',
      difficulty: json['difficulty'] ?? '',
      toeicFrequency: json['toeicFrequency'] ?? '',
    );
  }
}
