import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:quizz_me/models/model.dart';

class QuizService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<QuizQuestion>> fetchQuizQuestions(String apiUrl) async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      return results.map((result) {
        return QuizQuestion(
          question: _decodeHtml(result['question']),
          correctAnswer: _decodeHtml(result['correct_answer']),
          incorrectAnswers: List<String>.from(
            result['incorrect_answers'],
          ).map(_decodeHtml).toList(),
        );
      }).toList();
    } else {
      throw Exception('Failed to load quiz questions');
    }
  }

  String _decodeHtml(String htmlString) {
    return htmlString
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&eacute;', 'é')
        .replaceAll('&ouml;', 'ö');
  }

  Future<void> saveQuizResult({
    required String userId,
    required String category,
    required int score,
    required int totalQuestions,
  }) async {
    await _firestore.collection('quiz_results').add({
      'userId': userId,
      'category': category,
      'score': score,
      'totalQuestions': totalQuestions,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getUserQuizResults(String userId) {
    return _firestore
        .collection('quiz_results')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
