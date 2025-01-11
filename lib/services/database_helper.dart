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

    await deleteDatabase(path);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onOpen: (db) async {
        print('Database opened');
        final questions = await db.query('questions');
        print('Number of questions: ${questions.length}');
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE questions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        questionText TEXT NOT NULL,
        options TEXT NOT NULL,
        correctAnswerIndex INTEGER NOT NULL,
        category TEXT NOT NULL
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
    final List<Question> sampleQuestions = [
      // Histoire
      Question(
        questionText: 'En quelle année le Mali a-t-il obtenu son indépendance?',
        options: ['1958', '1959', '1960', '1961'],
        correctAnswerIndex: 2,
        category: 'histoire',
      ),
      Question(
        questionText: 'Qui était le premier président du Mali?',
        options: [
          'Amadou Toumani Touré',
          'Modibo Keïta',
          'Moussa Traoré',
          'Alpha Oumar Konaré'
        ],
        correctAnswerIndex: 1,
        category: 'histoire',
      ),
      Question(
        questionText:
            'Quel empire a dominé le Mali avant la colonisation française?',
        options: [
          'Empire du Ghana',
          'Empire du Mali',
          'Empire Songhaï',
          'Empire Bambara'
        ],
        correctAnswerIndex: 1,
        category: 'histoire',
      ),
      Question(
        questionText:
            'En quelle année a eu lieu le coup d\'État de Moussa Traoré?',
        options: ['1968', '1970', '1972', '1974'],
        correctAnswerIndex: 0,
        category: 'histoire',
      ),
      Question(
        questionText: 'Quel était le nom du Mali avant l\'indépendance?',
        options: [
          'Soudan français',
          'Haute-Volta',
          'Dahomey',
          'Côte d\'Ivoire'
        ],
        correctAnswerIndex: 0,
        category: 'histoire',
      ),
      Question(
        questionText: 'Qui était Soundiata Keïta?',
        options: [
          'Fondateur de l\'Empire du Mali',
          'Premier président du Mali',
          'Un musicien célèbre',
          'Un chef religieux'
        ],
        correctAnswerIndex: 0,
        category: 'histoire',
      ),

      // Culture
      Question(
        questionText:
            'Quel est l\'instrument de musique traditionnel le plus connu du Mali?',
        options: ['Kora', 'Djembé', 'Balafon', 'Ngoni'],
        correctAnswerIndex: 0,
        category: 'culture',
      ),
      Question(
        questionText:
            'Quelle est la plus grande fête musulmane célébrée au Mali?',
        options: ['Tabaski', 'Ramadan', 'Maouloud', 'Achoura'],
        correctAnswerIndex: 0,
        category: 'culture',
      ),
      Question(
        questionText: 'Quel est le plat national du Mali?',
        options: ['Tô', 'Thiéboudienne', 'Yassa', 'Mafé'],
        correctAnswerIndex: 0,
        category: 'culture',
      ),
      Question(
        questionText: 'Qui est Salif Keïta?',
        options: [
          'Un célèbre musicien malien',
          'Un ancien président',
          'Un footballeur',
          'Un écrivain'
        ],
        correctAnswerIndex: 0,
        category: 'culture',
      ),
      Question(
        questionText: 'Quelle est la tenue traditionnelle masculine au Mali?',
        options: ['Boubou', 'Dashiki', 'Kaftan', 'Agbada'],
        correctAnswerIndex: 0,
        category: 'culture',
      ),
      Question(
        questionText: 'Quel est l\'art textile traditionnel du Mali?',
        options: ['Bogolan', 'Kente', 'Adinkra', 'Batik'],
        correctAnswerIndex: 0,
        category: 'culture',
      ),

      // Géographie
      Question(
        questionText: 'Quelle est la capitale du Mali?',
        options: ['Sikasso', 'Bamako', 'Ségou', 'Kayes'],
        correctAnswerIndex: 1,
        category: 'geographie',
      ),
      Question(
        questionText: 'Quel fleuve traverse le Mali?',
        options: ['Le Niger', 'Le Nil', 'Le Congo', 'Le Sénégal'],
        correctAnswerIndex: 0,
        category: 'geographie',
      ),
      Question(
        questionText: 'Quel est le plus grand désert du Mali?',
        options: ['Sahara', 'Kalahari', 'Namib', 'Atacama'],
        correctAnswerIndex: 0,
        category: 'geographie',
      ),
      Question(
        questionText: 'Quelle est la plus grande ville après Bamako?',
        options: ['Sikasso', 'Ségou', 'Mopti', 'Kayes'],
        correctAnswerIndex: 0,
        category: 'geographie',
      ),
      Question(
        questionText:
            'Avec combien de pays le Mali partage-t-il ses frontières?',
        options: ['5', '7', '8', '6'],
        correctAnswerIndex: 1,
        category: 'geographie',
      ),
      Question(
        questionText: 'Quelle est la principale région agricole du Mali?',
        options: ['Sikasso', 'Mopti', 'Ségou', 'Kayes'],
        correctAnswerIndex: 0,
        category: 'geographie',
      ),

      // Politique
      Question(
        questionText: 'Quelle est la langue officielle du Mali?',
        options: ['Bambara', 'Français', 'Peul', 'Songhaï'],
        correctAnswerIndex: 1,
        category: 'politique',
      ),
      Question(
        questionText: 'Combien de régions administratives compte le Mali?',
        options: ['8', '10', '12', '14'],
        correctAnswerIndex: 1,
        category: 'politique',
      ),
      Question(
        questionText: 'Quel est le système politique du Mali?',
        options: ['Monarchie', 'République', 'Empire', 'Fédération'],
        correctAnswerIndex: 1,
        category: 'politique',
      ),
      Question(
        questionText: 'Quelle est la durée du mandat présidentiel au Mali?',
        options: ['4 ans', '5 ans', '6 ans', '7 ans'],
        correctAnswerIndex: 1,
        category: 'politique',
      ),
      Question(
        questionText: 'Quel est l\'organe législatif du Mali?',
        options: [
          'Assemblée nationale',
          'Sénat',
          'Conseil national',
          'Parlement'
        ],
        correctAnswerIndex: 0,
        category: 'politique',
      ),
      Question(
        questionText:
            'En quelle année a été adoptée la constitution actuelle du Mali?',
        options: ['1991', '1992', '1993', '1994'],
        correctAnswerIndex: 1,
        category: 'politique',
      ),
    ];

    for (var question in sampleQuestions) {
      await db.insert('questions', question.toMap());
    }
  }

  Future<List<Question>> getAllQuestions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('questions');
    print('Total questions found: ${maps.length}');
    final questions =
        List.generate(maps.length, (i) => Question.fromMap(maps[i]));
    questions.shuffle();
    return questions;
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

  Future<List<Question>> getQuestionsByCategory(String category) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'questions',
      where: 'category = ?',
      whereArgs: [category],
    );
    print('Questions found for $category: ${maps.length}');
    final questions =
        List.generate(maps.length, (i) => Question.fromMap(maps[i]));
    questions.shuffle();
    return questions;
  }
}
