import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../providers/marketplace_provider.dart';
import '../../data/models/marketplace_models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MarketplaceHomeScreen extends ConsumerWidget {
  const MarketplaceHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final listingsAsync = ref.watch(listingsProvider(selectedCategory));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Marketplace'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_business_outlined),
            onPressed: () => context.push('/marketplace/create'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GlassTextField(
              hintText: 'Search items...',
              prefixIcon: Icons.search,
            ),
          ),

          // Categories
          SizedBox(
            height: 50,
            child: categoriesAsync.when(
              data: (categories) => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length + 1,
                itemBuilder: (context, index) {
                  final isAll = index == 0;
                  final category = isAll ? null : categories[index - 1];
                  final isSelected =
                      selectedCategory == (isAll ? null : category?.id);

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(isAll ? 'All' : category!.name),
                      selected: isSelected,
                      onSelected: (_) =>
                          ref.read(selectedCategoryProvider.notifier).state =
                              isAll ? null : category?.id,
                      backgroundColor: Colors.white.withOpacity(0.05),
                      selectedColor: AppTheme.primaryIndigo,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  );
                },
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          ),

          const SizedBox(height: 16),

          // Listings Grid
          Expanded(
            child: listingsAsync.when(
              data: (listings) => GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: listings.length,
                itemBuilder: (context, index) {
                  final listing = listings[index];
                  return _ListingCard(listing: listing);
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final Listing listing;

  const _ListingCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          context.push('/marketplace/listing/${listing.id}', extra: listing),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: listing.images.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: listing.images[0],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : Container(
                        color: Colors.white.withOpacity(0.05),
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: Colors.white24,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${listing.currency} ${listing.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppTheme.electricViolet,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listing.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 12,
                        color: Colors.white54,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Local',
                        style: TextStyle(fontSize: 10, color: Colors.white54),
                      ),
                      const Spacer(),
                      if (listing.isFeatured)
                        const Icon(Icons.star, size: 14, color: Colors.amber),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
    );
  }
}
