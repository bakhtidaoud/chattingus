import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/premium_button.dart';
import '../../../../core/widgets/glass_text_field.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HighlightManager extends StatefulWidget {
  const HighlightManager({super.key});

  @override
  State<HighlightManager> createState() => _HighlightManagerState();
}

class _HighlightManagerState extends State<HighlightManager> {
  final List<Map<String, String>> _mockHighlights = [
    {'title': 'Travel', 'cover': 'https://picsum.photos/200/300?random=1'},
    {'title': 'Food', 'cover': 'https://picsum.photos/200/300?random=2'},
    {'title': 'Work', 'cover': 'https://picsum.photos/200/300?random=3'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Highlights'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Manage Your Story Collections',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ).animate().fadeIn().slideX(begin: -0.1, end: 0),
            const SizedBox(height: 8),
            Text(
              'Group your favorite stories into highlights to show on your profile.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 32),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: _mockHighlights.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) return _buildAddHighlight();
                  final highlight = _mockHighlights[index - 1];
                  return _buildHighlightItem(highlight);
                },
              ),
            ),

            PremiumButton(
              text: 'Save Changes',
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAddHighlight() {
    return GestureDetector(
      onTap: () => _showCreateDialog(),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white10),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: AppTheme.primaryIndigo,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'New',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ).animate().scale();
  }

  Widget _buildHighlightItem(Map<String, String> highlight) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(highlight['cover']!),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          highlight['title']!,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  void _showCreateDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.midnight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'New Highlight',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const GlassTextField(
              hintText: 'Highlight Name',
              prefixIcon: Icons.title,
            ),
            const SizedBox(height: 24),
            PremiumButton(
              text: 'Create',
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
