import 'package:flutter/material.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String category;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions * 100).round();
    String message;
    Color color;

    if (percentage >= 80) {
      message = 'Excellent!';
      color = Colors.green;
    } else if (percentage >= 60) {
      message = 'Good Job!';
      color = Colors.blue;
    } else if (percentage >= 40) {
      message = 'Not Bad!';
      color = Colors.orange;
    } else {
      message = 'Keep Trying!';
      color = Colors.red;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz Result')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 30),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: score / totalQuestions,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade300,
                    color: color,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '$score/$totalQuestions',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '($percentage%)',
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text('Category: $category', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () =>
                      Navigator.popUntil(context, (route) => route.isFirst),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  child: const Text('Back to Home'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
