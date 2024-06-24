class GameResult {
  final String studentId;
  final List<bool> nombresGameCompleted;
  final List<bool> voyellesGameCompleted;
  final List<bool> familleGameCompleted;

  GameResult({
    required this.studentId,
    List<bool>? nombresGameCompleted,
    List<bool>? voyellesGameCompleted,
    List<bool>? familleGameCompleted,
  })  : nombresGameCompleted = nombresGameCompleted ?? [false, false, false],
        voyellesGameCompleted = voyellesGameCompleted ?? [false, false, false],
        familleGameCompleted = familleGameCompleted ?? [false, false, false];

  Map<String, dynamic> toJson() {
    return {
      'studentId': studentId,
      'nombresGameCompleted': nombresGameCompleted,
      'voyellesGameCompleted': voyellesGameCompleted,
      'familleGameCompleted': familleGameCompleted,
    };
  }

  factory GameResult.fromJson(Map<String, dynamic> json) {
    return GameResult(
      studentId: json['studentId'],
      nombresGameCompleted: List<bool>.from(json['nombresGameCompleted']),
      voyellesGameCompleted: List<bool>.from(json['voyellesGameCompleted']),
      familleGameCompleted: List<bool>.from(json['familleGameCompleted']),
    );
  }
}
