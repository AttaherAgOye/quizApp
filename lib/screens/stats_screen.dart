import 'package:exam/models/quiz_stats.dart';
import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class StatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Statistics'),
      ),
      body: FutureBuilder<QuizStats?>(
        future: DatabaseHelper.instance.getQuizStats(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('No statistics available yet'));
          }

          final stats = snapshot.data!;
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatCard(
                  title: 'Total Quizzes Completed',
                  value: '${stats.totalQuizzes}',
                ),
                StatCard(
                  title: 'Best Score',
                  value: '${stats.bestScore}',
                ),
                StatCard(
                  title: 'Average Score',
                  value: '${stats.averageScore.toStringAsFixed(1)}%',
                ),
                StatCard(
                  title: 'Average Time per Question',
                  value: '${stats.averageTimePerQuestion.inSeconds}s',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 16, color: Colors.grey[600])),
            SizedBox(height: 8),
            Text(value,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
