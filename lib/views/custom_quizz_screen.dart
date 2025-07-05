import 'package:flutter/material.dart';
import 'package:quizz_me/views/quizz_screen.dart';

class CustomQuizScreen extends StatefulWidget {
  const CustomQuizScreen({super.key});

  @override
  State<CustomQuizScreen> createState() => _CustomQuizScreenState();
}

class _CustomQuizScreenState extends State<CustomQuizScreen> {
  // Configuration options
  int _questionCount = 10;
  String? _selectedCategory;
  String? _selectedDifficulty;
  String? _selectedType;

  // Available categories with IDs
  final Map<String, int> _categories = {
    'Any Category': 0,
    'General Knowledge': 9,
    'Entertainment: Books': 10,
    'Entertainment: Film': 11,
    'Entertainment: Music': 12,
    'Entertainment: Musicals & Theatres': 13,
    'Entertainment: Television': 14,
    'Entertainment: Video Games': 15,
    'Entertainment: Board Games': 16,
    'Science & Nature': 17,
    'Science: Computers': 18,
    'Science: Mathematics': 19,
    'Mythology': 20,
    'Sports': 21,
    'Geography': 22,
    'History': 23,
    'Politics': 24,
    'Art': 25,
    'Celebrities': 26,
    'Animals': 27,
    'Vehicles': 28,
    'Entertainment: Comics': 29,
    'Science: Gadgets': 30,
    'Entertainment: Japanese Anime & Manga': 31,
    'Entertainment: Cartoon & Animations': 32,
  };

  final List<String> _difficulties = [
    'Any Difficulty',
    'Easy',
    'Medium',
    'Hard',
  ];
  final List<String> _types = ['Any Type', 'Multiple Choice', 'True/False'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Quiz Setup')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Number of Questions
            const Text(
              'Number of Questions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _questionCount.toDouble(),
                    min: 5,
                    max: 50,
                    divisions: 9,
                    label: _questionCount.toString(),
                    onChanged: (value) {
                      setState(() {
                        _questionCount = value.toInt();
                      });
                    },
                  ),
                ),
                Container(
                  width: 50,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$_questionCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Category Selection
            const Text(
              'Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              hint: const Text('Select a category'),
              items: _categories.keys.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Difficulty Selection
            const Text(
              'Difficulty',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedDifficulty,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              hint: const Text('Select difficulty'),
              items: _difficulties.map((String difficulty) {
                return DropdownMenuItem<String>(
                  value: difficulty,
                  child: Text(difficulty),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDifficulty = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // Question Type
            const Text(
              'Question Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
              hint: const Text('Select question type'),
              items: _types.map((String type) {
                return DropdownMenuItem<String>(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),
            const SizedBox(height: 32),

            // Start Quiz Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _startCustomQuiz(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Start Custom Quiz',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _startCustomQuiz(BuildContext context) {
    // Build the API URL based on selections
    String apiUrl = 'https://opentdb.com/api.php?amount=$_questionCount';

    // Add category if selected
    if (_selectedCategory != null && _selectedCategory != 'Any Category') {
      final categoryId = _categories[_selectedCategory];
      apiUrl += '&category=$categoryId';
    }

    // Add difficulty if selected
    if (_selectedDifficulty != null &&
        _selectedDifficulty != 'Any Difficulty') {
      apiUrl += '&difficulty=${_selectedDifficulty!.toLowerCase()}';
    }

    // Add type if selected
    if (_selectedType != null && _selectedType != 'Any Type') {
      if (_selectedType == 'Multiple Choice') {
        apiUrl += '&type=multiple';
      } else if (_selectedType == 'True/False') {
        apiUrl += '&type=boolean';
      }
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizScreen(
          category: _selectedCategory ?? 'Custom Quiz',
          apiUrl: apiUrl,
        ),
      ),
    );
  }
}
