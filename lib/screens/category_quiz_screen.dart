import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../screens/main_menu_screen.dart';
import '../services/audio_service.dart';

class CategoryQuizScreen extends StatelessWidget {
  final CategoryItem category;

  const CategoryQuizScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          QuizProvider()..loadQuestionsByCategory(category.category),
      child: Scaffold(
        appBar: AppBar(
          title: Text(category.title),
          backgroundColor: category.color,
        ),
        body: Consumer<QuizProvider>(
          builder: (context, quizProvider, child) {
            if (quizProvider.questions.isEmpty) {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(category.color),
              ));
            }

            if (quizProvider.isQuizComplete) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Quiz Terminé!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: category.color,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Score: ${quizProvider.score}/${quizProvider.questions.length}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: category.color,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      ),
                      onPressed: () => quizProvider.resetQuiz(),
                      child: Text('Recommencer le Quiz'),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Retour au Menu',
                        style: TextStyle(color: category.color),
                      ),
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
                            ? category.color
                            : Colors.red,
                      ),
                    ),
                  ),
                  Text(
                    'Question ${quizProvider.currentQuestionIndex + 1}/${quizProvider.questions.length}',
                    style: TextStyle(
                      fontSize: 18,
                      color: category.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        currentQuestion.questionText,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentQuestion.options.length,
                      itemBuilder: (context, index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 16,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16),
                              backgroundColor: category.color.withOpacity(0.9),
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
                                        : 'Incorrect',
                                    textAlign: TextAlign.center,
                                  ),
                                  backgroundColor: index ==
                                          currentQuestion.correctAnswerIndex
                                      ? Colors.green
                                      : Colors.red,
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Text(
                              currentQuestion.options[index],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
