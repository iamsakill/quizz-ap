import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/model.dart';
import '../views/custom_quizz_screen.dart';
import '../views/quizz_screen.dart';
import '../models/auth_service.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

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
    QuizCategory(
      title: 'Custom Quiz',
      apiUrl: '',
      icon: Icons.settings,
      color: Colors.deepOrange,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Quiz Master',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.3),
                          theme.colorScheme.primary.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.person_outline),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => context.read<AuthService>().signOut(),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserCard(user, theme),
                      const SizedBox(height: 24),
                      Text(
                        'Explore Categories',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        _buildCategoryCard(context, categories[index]),
                    childCount: categories.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserCard(User? user, ThemeData theme) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.05),
              theme.colorScheme.primary.withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundImage: user?.photoURL != null
                    ? NetworkImage(user!.photoURL!)
                    : null,
                backgroundColor: theme.colorScheme.surface,
                child: user?.photoURL == null
                    ? Icon(
                        Icons.person,
                        size: 32,
                        color: theme.colorScheme.onSurface,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${user?.displayName ?? user?.email?.split('@').first ?? 'Quizzer'}!',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Ready to test your knowledge?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, QuizCategory category) {
    return GestureDetector(
      onTap: () => _navigateToScreen(context, category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [category.color.withOpacity(0.9), category.color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: category.color.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(category.icon, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              category.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScreen(BuildContext context, QuizCategory category) {
    if (category.title == 'Custom Quiz') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const CustomQuizScreen()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              QuizScreen(category: category.title, apiUrl: category.apiUrl),
        ),
      );
    }
  }
}
