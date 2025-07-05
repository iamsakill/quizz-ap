import 'package:flutter/material.dart';

class QuizCategory {
  final String title;
  final String apiUrl;
  final IconData icon;
  final Color color;

  QuizCategory({
    required this.title,
    required this.apiUrl,
    required this.icon,
    required this.color,
  });
}

class QuizQuestion {
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;

  QuizQuestion({
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
  });

  List<String> get allAnswers {
    final all = List<String>.from(incorrectAnswers);
    all.add(correctAnswer);
    all.shuffle();
    return all;
  }
}
