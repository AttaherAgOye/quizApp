import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../services/audio_service.dart';

class QuizScreen extends StatelessWidget {
  final String? category;

  const QuizScreen({Key? key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (category != null) {
        context.read<QuizProvider>().loadQuestionsByCategory(category!);
      } else {
        context.read<QuizProvider>().loadQuestions();
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade900, Colors.purple.shade900],
          ),
        ),
        child: SafeArea(
          child: Consumer<QuizProvider>(
            builder: (context, quizProvider, child) {
              if (quizProvider.questions.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Chargement des questions...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (quizProvider.isQuizComplete) {
                final score = quizProvider.score;
                final total = quizProvider.questions.length;
                final percentage = (score / total) * 100;

                return Center(
                  child: Card(
                    margin: EdgeInsets.all(20),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            percentage >= 70
                                ? Icons.emoji_events
                                : Icons.school,
                            size: 80,
                            color: percentage >= 70
                                ? Colors.amber
                                : Colors.blue.shade700,
                          ),
                          SizedBox(height: 20),
                          Text(
                            percentage >= 70
                                ? 'Félicitations !'
                                : 'Quiz Terminé !',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Score: $score/$total',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: percentage >= 70
                                  ? Colors.green
                                  : Colors.orange,
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            _getScoreMessage(percentage),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                icon: Icon(Icons.refresh),
                                label: Text('Recommencer'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  backgroundColor: Colors.blue.shade700,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () => quizProvider.resetQuiz(),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton.icon(
                                icon: Icon(Icons.home),
                                label: Text('Menu'),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 12,
                                  ),
                                  backgroundColor: Colors.grey.shade200,
                                  foregroundColor: Colors.blue.shade900,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              final currentQuestion = quizProvider.currentQuestion;
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Column(
                          children: [
                            Text(
                              category?.toUpperCase() ?? 'QUIZ',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Question ${quizProvider.currentQuestionIndex + 1}/${quizProvider.questions.length}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Score: ${quizProvider.score}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.timer,
                              color: Colors.white70,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '${quizProvider.timeRemaining} secondes',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: quizProvider.timeRemaining / 30,
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              quizProvider.timeRemaining > 10
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Card(
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(24),
                            width: double.infinity,
                            child: Column(
                              children: [
                                Icon(
                                  _getQuestionIcon(
                                      currentQuestion.questionText),
                                  size: 40,
                                  color: Colors.blue.shade700,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  currentQuestion.questionText,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: List.generate(
                        currentQuestion.options.length,
                        (index) => Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue.shade900,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 4,
                                minimumSize: Size(double.infinity, 60),
                              ),
                              onPressed: () =>
                                  quizProvider.answerQuestion(index),
                              child: Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Center(
                                      child: Text(
                                        String.fromCharCode(65 + index),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade900,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      currentQuestion.options[index],
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _getScoreMessage(double percentage) {
    if (percentage >= 90)
      return 'Excellent ! Vous maîtrisez parfaitement le sujet !';
    if (percentage >= 70) return 'Très bien ! Continuez comme ça !';
    if (percentage >= 50)
      return 'Pas mal ! Avec un peu plus de pratique, vous pouvez faire encore mieux.';
    return 'Continuez à apprendre, la pratique mène à la perfection !';
  }

  IconData _getQuestionIcon(String question) {
    if (question.contains('année')) return Icons.calendar_today;
    if (question.contains('capitale')) return Icons.location_city;
    if (question.contains('président')) return Icons.person;
    if (question.contains('fleuve')) return Icons.water;
    if (question.contains('langue')) return Icons.language;
    if (question.contains('musique')) return Icons.music_note;
    return Icons.quiz;
  }
}
