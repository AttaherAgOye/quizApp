class QuizStats {
  final int totalQuizzes;
  final int totalCorrectAnswers;
  final int bestScore;
  final double averageScore;
  final Duration averageTimePerQuestion;

  QuizStats({
    required this.totalQuizzes,
    required this.totalCorrectAnswers,
    required this.bestScore,
    required this.averageScore,
    required this.averageTimePerQuestion,
  });

  Map<String, dynamic> toMap() {
    return {
      'totalQuizzes': totalQuizzes,
      'totalCorrectAnswers': totalCorrectAnswers,
      'bestScore': bestScore,
      'averageScore': averageScore,
      'averageTimePerQuestion': averageTimePerQuestion.inSeconds,
    };
  }

  factory QuizStats.fromMap(Map<String, dynamic> map) {
    return QuizStats(
      totalQuizzes: map['totalQuizzes'],
      totalCorrectAnswers: map['totalCorrectAnswers'],
      bestScore: map['bestScore'],
      averageScore: map['averageScore'],
      averageTimePerQuestion: Duration(seconds: map['averageTimePerQuestion']),
    );
  }
}
