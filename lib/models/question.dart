class Question {
  final int? id;
  final String questionText;
  final List<String> options;
  final int correctAnswerIndex;

  Question({
    this.id,
    required this.questionText,
    required this.options,
    required this.correctAnswerIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'questionText': questionText,
      'options': options.join('|||'),
      'correctAnswerIndex': correctAnswerIndex,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      questionText: map['questionText'],
      options: map['options'].split('|||'),
      correctAnswerIndex: map['correctAnswerIndex'],
    );
  }
}
