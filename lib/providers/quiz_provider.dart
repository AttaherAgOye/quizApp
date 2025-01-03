import 'package:flutter/foundation.dart';
import '../models/question.dart';
import '../services/database_helper.dart';
import 'dart:async';

class QuizProvider with ChangeNotifier {
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isQuizComplete = false;
  int _timeRemaining = 30; // 30 seconds per question
  Timer? _timer;

  List<Question> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  bool get isQuizComplete => _isQuizComplete;
  Question get currentQuestion => _questions[_currentQuestionIndex];
  int get timeRemaining => _timeRemaining;

  Future<void> loadQuestions() async {
    _questions = await DatabaseHelper.instance.getAllQuestions();
    notifyListeners();
  }

  void answerQuestion(int selectedAnswerIndex) {
    if (selectedAnswerIndex == currentQuestion.correctAnswerIndex) {
      _score++;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    } else {
      _isQuizComplete = true;
    }

    notifyListeners();
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _isQuizComplete = false;
    notifyListeners();
  }

  void startTimer() {
    _timer?.cancel();
    _timeRemaining = 30;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        _timeRemaining--;
        notifyListeners();
      } else {
        answerQuestion(-1); // Auto-submit when time runs out
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
