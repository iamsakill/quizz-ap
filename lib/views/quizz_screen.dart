import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizz_me/models/model.dart';
import 'package:quizz_me/models/quizz_service.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  final String apiUrl;

  const QuizScreen({super.key, required this.category, required this.apiUrl});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late Future<List<QuizQuestion>> _questionsFuture;
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isAnswered = false;
  String? _selectedAnswer;
  final QuizService _quizService = QuizService();

  @override
  void initState() {
    super.initState();
    _questionsFuture = _quizService.fetchQuizQuestions(widget.apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: FutureBuilder<List<QuizQuestion>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No questions available'));
          }

          final questions = snapshot.data!;
          final currentQuestion = questions[_currentQuestionIndex];
          final isLastQuestion = _currentQuestionIndex == questions.length - 1;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Progress Indicator
                LinearProgressIndicator(
                  value: (_currentQuestionIndex + 1) / questions.length,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                const SizedBox(height: 16),

                // Question Counter
                Text(
                  'Question ${_currentQuestionIndex + 1}/${questions.length}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // Question Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      currentQuestion.question,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Answers List
                Expanded(
                  child: ListView.builder(
                    itemCount: currentQuestion.allAnswers.length,
                    itemBuilder: (context, index) {
                      final answer = currentQuestion.allAnswers[index];
                      final isCorrect = answer == currentQuestion.correctAnswer;

                      return AnswerCard(
                        answer: answer,
                        isSelected: _selectedAnswer == answer,
                        isAnswered: _isAnswered,
                        isCorrect: isCorrect,
                        onTap: () => _selectAnswer(answer, isCorrect),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // Next Button
                if (_isAnswered)
                  ElevatedButton(
                    onPressed: () => _nextQuestion(questions, isLastQuestion),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      isLastQuestion ? 'Finish Quiz' : 'Next Question',
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _selectAnswer(String answer, bool isCorrect) {
    if (_isAnswered) return;

    setState(() {
      _selectedAnswer = answer;
      _isAnswered = true;
      if (isCorrect) _score++;
    });
  }

  void _nextQuestion(List<QuizQuestion> questions, bool isLastQuestion) {
    if (isLastQuestion) {
      // Save result to Firebase
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        _quizService.saveQuizResult(
          userId: user.uid,
          category: widget.category,
          score: _score,
          totalQuestions: questions.length,
        );
      }

      // Navigate to results screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizResultScreen(
            score: _score,
            totalQuestions: questions.length,
            category: widget.category,
          ),
        ),
      );
    } else {
      setState(() {
        _currentQuestionIndex++;
        _isAnswered = false;
        _selectedAnswer = null;
      });
    }
  }
}

class AnswerCard extends StatelessWidget {
  final String answer;
  final bool isSelected;
  final bool isAnswered;
  final bool isCorrect;
  final VoidCallback onTap;

  const AnswerCard({
    super.key,
    required this.answer,
    required this.isSelected,
    required this.isAnswered,
    required this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.grey;
    Color backgroundColor = Colors.transparent;
    Color textColor = Colors.black;

    if (isAnswered) {
      if (isSelected && isCorrect) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
      } else if (isSelected && !isCorrect) {
        borderColor = Colors.red;
        backgroundColor = Colors.red.withOpacity(0.1);
        textColor = Colors.red;
      } else if (isCorrect) {
        borderColor = Colors.green;
        backgroundColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
      }
    } else if (isSelected) {
      borderColor = Theme.of(context).primaryColor;
      backgroundColor = Theme.of(context).primaryColor.withOpacity(0.1);
      textColor = Theme.of(context).primaryColor;
    }

    return Card(
      elevation: 0,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: 2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(answer, style: TextStyle(fontSize: 16, color: textColor)),
        ),
      ),
    );
  }
}
