import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HashtagExploreScreen extends StatelessWidget {
  const HashtagExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> trendingTags = [
      {'tag': '#FlutterDev', 'posts': '12.5k'},
      {'tag': '#ChattingUs', 'posts': '8.2k'},
      {'tag': '#Glassmorphism', 'posts': '5.4k'},
      {'tag': '#PremiumDesign', 'posts': '3.9k'},
      {'tag': '#DartLang', 'posts': '2.1k'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search hashtags, users...',
                  prefixIcon: Icon(Icons.search, color: Colors.white38),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Trending Hashtags',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: trendingTags.length,
              itemBuilder: (context, index) {
                final tag = trendingTags[index];
                return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tag['tag']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppTheme.primaryIndigo,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${tag['posts']} posts',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.trending_up,
                              color: AppTheme.electricViolet,
                            ),
                          ],
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: (index * 100).ms)
                    .slideX(begin: 0.1, end: 0);
              },
            ),
          ),
        ],
      ),
    );
  }
}
