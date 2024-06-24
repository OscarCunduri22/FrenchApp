class GameResult {
  final String studentId;
  final String category;
  final int gameNumber;
  final bool isCompleted;

  GameResult({
    required this.studentId,
    required this.category,
    required this.gameNumber,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'category': category,
      'gameNumber': gameNumber,
      'isCompleted': isCompleted,
    };
  }

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      studentId: json['studentId'],
      category: json['category'],
      gameNumber: json['gameNumber'],
      isCompleted: json['isCompleted'],
    );
  }
}
