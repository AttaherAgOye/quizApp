import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/question.dart';
import '../models/quiz_stats.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('quiz.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE questions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        questionText TEXT NOT NULL,
        options TEXT NOT NULL,
        correctAnswerIndex INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE stats(
        totalQuizzes INTEGER,
        totalCorrectAnswers INTEGER,
        bestScore INTEGER,
        averageScore REAL,
        averageTimePerQuestion INTEGER
      )
    ''');

    // Insert some sample questions
    await _insertSampleQuestions(db);
  }

  Future _insertSampleQuestions(Database db) async {
    final sampleQuestions = [
      Question(
        questionText: 'What is the capital of France?',
        options: ['London', 'Berlin', 'Paris', 'Madrid'],
        correctAnswerIndex: 2,
      ),
      Question(
        questionText: 'Which planet is known as the Red Planet?',
        options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
        correctAnswerIndex: 1,
      ),
    ];

    for (var question in sampleQuestions) {
      await db.insert('questions', question.toMap());
    }
  }

  Future<List<Question>> getAllQuestions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('questions');
    return List.generate(maps.length, (i) => Question.fromMap(maps[i]));
  }

  Future<void> saveQuizStats(QuizStats stats) async {
    final db = await database;
    await db.insert('stats', stats.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<QuizStats?> getQuizStats() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('stats');
    if (maps.isEmpty) return null;
    return QuizStats.fromMap(maps.first);
  }
}
