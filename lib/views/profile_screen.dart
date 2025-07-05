import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quizz_me/models/quizz_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final quizService = QuizService();
    final userId = user?.uid ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ?? 'Quiz Master',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Joined: ${user?.metadata.creationTime?.toString().split(' ').first ?? 'Unknown'}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Quiz History
            const Text(
              'Quiz History',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // History List
            StreamBuilder<QuerySnapshot>(
              stream: quizService.getUserQuizResults(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No quiz history yet'));
                }

                final results = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final result = results[index];
                    final data = result.data() as Map<String, dynamic>;
                    final category = data['category'] as String? ?? 'Unknown';
                    final score = data['score'] as int? ?? 0;
                    final total = data['totalQuestions'] as int? ?? 1;
                    final percentage = (score / total * 100).round();
                    final timestamp =
                        (data['timestamp'] as Timestamp?)?.toDate() ??
                        DateTime.now();

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: _getCategoryColor(category).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _getCategoryIcon(category),
                            color: _getCategoryColor(category),
                          ),
                        ),
                        title: Text(category),
                        subtitle: Text(
                          '${_formatDate(timestamp)} • $score/$total ($percentage%)',
                        ),
                        trailing: Text(
                          '$percentage%',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _getScoreColor(percentage),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Quick Quiz':
        return Icons.flash_on;
      case 'General Knowledge':
        return Icons.public;
      case 'Movies':
        return Icons.movie;
      case 'Sports':
        return Icons.sports_soccer;
      case 'History':
        return Icons.history;
      case 'Math':
        return Icons.calculate;
      case 'Celebrities':
        return Icons.people;
      case 'Computers':
        return Icons.computer;
      default:
        return Icons.quiz;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Quick Quiz':
        return Colors.amber;
      case 'General Knowledge':
        return Colors.blue;
      case 'Movies':
        return Colors.deepPurple;
      case 'Sports':
        return Colors.green;
      case 'History':
        return Colors.brown;
      case 'Math':
        return Colors.teal;
      case 'Celebrities':
        return Colors.pink;
      case 'Computers':
        return Colors.blueGrey;
      default:
        return Colors.grey;
    }
  }

  Color _getScoreColor(int percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.blue;
    if (percentage >= 40) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
