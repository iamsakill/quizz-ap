import 'package:flutter/material.dart';
import 'package:quizz_me/views/quizz_screen.dart';

class CustomQuizScreen extends StatefulWidget {
  const CustomQuizScreen({super.key});

  @override
  State<CustomQuizScreen> createState() => _CustomQuizScreenState();
}

class _CustomQuizScreenState extends State<CustomQuizScreen> {
  String _selectedCategory = '9'; // Default: General Knowledge
  String _selectedDifficulty = 'medium';
  int _selectedNumber = 10;

  final List<Map<String, String>> categories = [
    {"id": "9", "name": "General Knowledge"},
    {"id": "10", "name": "Books"},
    {"id": "11", "name": "Film"},
    {"id": "12", "name": "Music"},
    {"id": "13", "name": "Musicals & Theatres"},
    {"id": "14", "name": "Television"},
    {"id": "15", "name": "Video Games"},
    {"id": "16", "name": "Board Games"},
    {"id": "17", "name": "Science & Nature"},
    {"id": "18", "name": "Computers"},
    {"id": "19", "name": "Mathematics"},
    {"id": "20", "name": "Mythology"},
    {"id": "21", "name": "Sports"},
    {"id": "22", "name": "Geography"},
    {"id": "23", "name": "History"},
    {"id": "24", "name": "Politics"},
    {"id": "25", "name": "Art"},
    {"id": "26", "name": "Celebrities"},
    {"id": "27", "name": "Animals"},
    {"id": "28", "name": "Vehicles"},
    {"id": "29", "name": "Comics"},
    {"id": "30", "name": "Gadgets"},
    {"id": "31", "name": "Anime & Manga"},
    {"id": "32", "name": "Cartoon & Animations"},
  ];

  final List<String> difficulties = ['easy', 'medium', 'hard'];
  final List<int> questionCounts = [5, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Custom Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Category", style: TextStyle(fontSize: 18)),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: categories
                  .map(
                    (cat) => DropdownMenuItem(
                      value: cat['id'],
                      child: Text(cat['name']!),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() {
                _selectedCategory = value!;
              }),
            ),
            const SizedBox(height: 20),

            const Text("Difficulty", style: TextStyle(fontSize: 18)),
            DropdownButtonFormField<String>(
              value: _selectedDifficulty,
              items: difficulties
                  .map(
                    (level) => DropdownMenuItem(
                      value: level,
                      child: Text(level[0].toUpperCase() + level.substring(1)),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() {
                _selectedDifficulty = value!;
              }),
            ),
            const SizedBox(height: 20),

            const Text("Number of Questions", style: TextStyle(fontSize: 18)),
            DropdownButtonFormField<int>(
              value: _selectedNumber,
              items: questionCounts
                  .map(
                    (num) => DropdownMenuItem(
                      value: num,
                      child: Text(num.toString()),
                    ),
                  )
                  .toList(),
              onChanged: (value) => setState(() {
                _selectedNumber = value!;
              }),
            ),
            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _startQuiz,
                child: const Text("Start Quiz"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startQuiz() {
    final selectedCategoryName = categories.firstWhere(
      (cat) => cat['id'] == _selectedCategory,
    )['name']!;
    final apiUrl =
        'https://opentdb.com/api.php?amount=$_selectedNumber&category=$_selectedCategory&difficulty=$_selectedDifficulty&type=multiple';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            QuizScreen(category: selectedCategoryName, apiUrl: apiUrl),
      ),
    );
  }
}
