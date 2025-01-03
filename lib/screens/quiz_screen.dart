import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../services/audio_service.dart';

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Consumer<QuizProvider>(
        builder: (context, quizProvider, child) {
          if (quizProvider.questions.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          if (quizProvider.isQuizComplete) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Quiz Complete!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Score: ${quizProvider.score}/${quizProvider.questions.length}',
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => quizProvider.resetQuiz(),
                    child: Text('Restart Quiz'),
                  ),
                ],
              ),
            );
          }

          final currentQuestion = quizProvider.currentQuestion;
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: LinearProgressIndicator(
                    value: quizProvider.timeRemaining / 30,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      quizProvider.timeRemaining > 10
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
                Text(
                  'Question ${quizProvider.currentQuestionIndex + 1}/${quizProvider.questions.length}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Text(
                  currentQuestion.questionText,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ...List.generate(
                  currentQuestion.options.length,
                  (index) => AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        if (index == currentQuestion.correctAnswerIndex) {
                          AudioService.playCorrect();
                        } else {
                          AudioService.playWrong();
                        }
                        quizProvider.answerQuestion(index);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              index == currentQuestion.correctAnswerIndex
                                  ? 'Correct!'
                                  : 'Wrong answer',
                            ),
                            backgroundColor:
                                index == currentQuestion.correctAnswerIndex
                                    ? Colors.green
                                    : Colors.red,
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Text(
                        currentQuestion.options[index],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
