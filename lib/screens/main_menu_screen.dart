import 'package:exam/screens/category_quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'quiz_screen.dart';
import 'stats_screen.dart';

class MainMenuScreen extends StatefulWidget {
  @override
  _MainMenuScreenState createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  late VideoPlayerController _controller;

  final List<CategoryItem> categories = [
    CategoryItem(
      title: 'Histoire',
      icon: Icons.history,
      color: Colors.blue,
      category: 'histoire',
    ),
    CategoryItem(
      title: 'Culture',
      icon: Icons.music_note,
      color: Colors.red,
      category: 'culture',
    ),
    CategoryItem(
      title: 'Géographie',
      icon: Icons.map,
      color: Colors.green,
      category: 'geographie',
    ),
    CategoryItem(
      title: 'Politique',
      icon: Icons.policy,
      color: Colors.orange,
      category: 'politique',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/background.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Video Background
          _controller.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                )
              : Container(color: Colors.black),

          // Dark overlay to make buttons more visible
          Container(
            color: Colors.black.withOpacity(0.5),
          ),

          // Menu Content
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 50),
                Text(
                  'Mali Culture',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Choisissez une catégorie',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: EdgeInsets.all(16),
                    children: categories.map((category) {
                      return CategoryCard(
                        category: category,
                        onTap: () => _startQuiz(context, category.category),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      backgroundColor: Colors.blue.withOpacity(0.7),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => StatsScreen()),
                      );
                    },
                    child: Text('Statistiques'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _startQuiz(BuildContext context, String category) {
    print('Starting quiz for category: $category');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(category: category),
      ),
    );
  }
}

class CategoryItem {
  final String title;
  final IconData icon;
  final Color color;
  final String category;

  CategoryItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.category,
  });
}

class CategoryCard extends StatelessWidget {
  final CategoryItem category;
  final VoidCallback onTap;

  const CategoryCard({
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: category.color.withOpacity(0.7),
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category.icon,
              size: 50,
              color: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              category.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
