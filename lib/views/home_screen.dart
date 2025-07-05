import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizz_me/models/model.dart';
import 'package:quizz_me/views/custom_quizz_screen.dart';
import 'package:quizz_me/views/quizz_screen.dart';
import '../models/auth_service.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<QuizCategory> categories = [
    QuizCategory(
      title: 'Quick Quiz',
      apiUrl: 'https://opentdb.com/api.php?amount=10',
      icon: Icons.flash_on,
      color: Colors.amber,
    ),
    QuizCategory(
      title: 'General Knowledge',
      apiUrl: 'https://opentdb.com/api.php?amount=10&category=9',
      icon: Icons.public,
      color: Colors.blue,
    ),
    QuizCategory(
      title: 'Movies',
      apiUrl: 'https://opentdb.com/api.php?amount=10&category=11',
      icon: Icons.movie,
      color: Colors.deepPurple,
    ),
    QuizCategory(
      title: 'Sports',
      apiUrl: 'https://opentdb.com/api.php?amount=10&category=21',
      icon: Icons.sports_soccer,
      color: Colors.green,
    ),
    QuizCategory(
      title: 'History',
      apiUrl: 'https://opentdb.com/api.php?amount=10&category=23',
      icon: Icons.history,
      color: Colors.brown,
    ),
    QuizCategory(
      title: 'Math',
      apiUrl: 'https://opentdb.com/api.php?amount=10&category=19',
      icon: Icons.calculate,
      color: Colors.teal,
    ),
    QuizCategory(
      title: 'Celebrities',
      apiUrl: 'https://opentdb.com/api.php?amount=10&category=26',
      icon: Icons.people,
      color: Colors.pink,
    ),
    QuizCategory(
      title: 'Computers',
      apiUrl: 'https://opentdb.com/api.php?amount=10&category=18',
      icon: Icons.computer,
      color: Colors.blueGrey,
    ),
    // Add new Custom Quiz category at the end
    QuizCategory(
      title: 'Custom Quiz',
      apiUrl: '', // Will be generated dynamically
      icon: Icons.settings,
      color: Colors.deepOrange,
    ),
  ];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Master'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthService>().signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Welcome Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : null,
                      child: user?.photoURL == null
                          ? const Icon(Icons.person, size: 30)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${user?.displayName ?? user?.email?.split('@').first ?? 'Quizzer'}!',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Ready to test your knowledge?',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Categories Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                'Quiz Categories',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Categories Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _buildCategoryCard(context, category);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, QuizCategory category) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _navigateToScreen(context, category),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                category.color.withOpacity(0.7),
                category.color.withOpacity(0.9),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(category.icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                category.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, QuizCategory category) {
    if (category.title == 'Custom Quiz') {
      // Navigate to custom quiz setup screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CustomQuizScreen()),
      );
    } else {
      // Navigate to regular quiz screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              QuizScreen(category: category.title, apiUrl: category.apiUrl),
        ),
      );
    }
  }
}
