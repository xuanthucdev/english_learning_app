class RankedUser {
  final int rank;
  final String userName;
  final int score;
  final int testId;

  RankedUser({
    required this.rank,
    required this.userName,
    required this.score,
    required this.testId,
  });

  factory RankedUser.fromJson(Map<String, dynamic> json) {
    return RankedUser(
      rank: json['rank'],
      userName: json['userName'],
      score: json['score'],
      testId: json['testId'],
    );
  }
}
