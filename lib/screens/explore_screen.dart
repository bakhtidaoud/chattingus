import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../l10n/app_localizations.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Sample data for posts and reels
  final List<Map<String, dynamic>> _exploreItems = [
    {
      'type': 'post',
      'image':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
      'aspectRatio': 1.0,
    },
    {
      'type': 'reel',
      'image':
          'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400',
      'aspectRatio': 1.5,
    },
    {
      'type': 'post',
      'image':
          'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=400',
      'aspectRatio': 0.8,
    },
    {
      'type': 'reel',
      'image':
          'https://images.unsplash.com/photo-1516116216624-53e697fedbea?w=400',
      'aspectRatio': 1.2,
    },
    {
      'type': 'post',
      'image':
          'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400',
      'aspectRatio': 1.0,
    },
    {
      'type': 'reel',
      'image':
          'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=400',
      'aspectRatio': 1.5,
    },
    {
      'type': 'post',
      'image':
          'https://images.unsplash.com/photo-1475924156734-496f6cac6ec1?w=400',
      'aspectRatio': 0.9,
    },
    {
      'type': 'reel',
      'image':
          'https://images.unsplash.com/photo-1518173946687-a4c8892bbd9f?w=400',
      'aspectRatio': 1.3,
    },
    {
      'type': 'post',
      'image':
          'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      'aspectRatio': 1.0,
    },
    {
      'type': 'reel',
      'image':
          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
      'aspectRatio': 1.4,
    },
    {
      'type': 'post',
      'image':
          'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400',
      'aspectRatio': 0.85,
    },
    {
      'type': 'reel',
      'image':
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400',
      'aspectRatio': 1.5,
    },
    {
      'type': 'post',
      'image':
          'https://images.unsplash.com/photo-1488426862026-3ee34a7d66df?w=400',
      'aspectRatio': 1.0,
    },
    {
      'type': 'reel',
      'image':
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400',
      'aspectRatio': 1.2,
    },
    {
      'type': 'post',
      'image':
          'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400',
      'aspectRatio': 0.9,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: l10n.searchPlaceholder,
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: isDark
                      ? Colors.grey.shade800
                      : Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  // Search functionality can be implemented here
                  setState(() {});
                },
              ),
            ),

            // Staggered Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                  childAspectRatio: 1.0,
                ),
                itemCount: _exploreItems.length,
                itemBuilder: (context, index) {
                  final item = _exploreItems[index];
                  return _buildExploreItem(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExploreItem(Map<String, dynamic> item) {
    final isReel = item['type'] == 'reel';

    return GestureDetector(
      onTap: () {
        // Handle item tap
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Image
          Image.network(
            item['image'],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                child: const Icon(Icons.image, size: 40, color: Colors.grey),
              );
            },
          ),

          // Reel indicator
          if (isReel)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),

          // View count overlay (for reels)
          if (isReel)
            Positioned(
              bottom: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.play_arrow, color: Colors.white, size: 12),
                    const SizedBox(width: 2),
                    Text(
                      '${(math.Random().nextInt(900) + 100)}K',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
