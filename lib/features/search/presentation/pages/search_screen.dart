import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../providers/search_provider.dart';
import '../../marketplace/presentation/providers/marketplace_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GlobalSearchScreen extends ConsumerStatefulWidget {
  const GlobalSearchScreen({super.key});

  @override
  ConsumerState<GlobalSearchScreen> createState() => _GlobalSearchScreenState();
}

class _GlobalSearchScreenState extends ConsumerState<GlobalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = ref.watch(searchTabProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Global Discovery'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: GlassTextField(
              controller: _searchController,
              hintText: 'Search people or products...',
              prefixIcon: Icons.search_rounded,
              onChanged: (val) => setState(() => _query = val),
            ),
          ),

          DefaultTabController(
            length: 2,
            initialIndex: selectedTab,
            child: Column(
              children: [
                TabBar(
                  onTap: (index) =>
                      ref.read(searchTabProvider.notifier).state = index,
                  indicatorColor: AppTheme.primaryIndigo,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white38,
                  tabs: const [
                    Tab(text: 'People'),
                    Tab(text: 'Marketplace'),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: selectedTab == 0
                ? _buildUserResults()
                : _buildMarketplaceResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserResults() {
    final usersAsync = ref.watch(userSearchProvider(_query));

    return usersAsync.when(
      data: (users) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: user['profile_image'] != null
                  ? CachedNetworkImageProvider(user['profile_image'])
                  : null,
              child: user['profile_image'] == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(user['username'] ?? 'User'),
            subtitle: Text(user['bio'] ?? 'No bio yet', maxLines: 1),
            trailing: OutlinedButton(
              onPressed: () {},
              child: const Text('Follow'),
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildMarketplaceResults() {
    final listingsAsync = ref.watch(
      listingsProvider(null),
    ); // Should be filtered by query ideally

    return listingsAsync.when(
      data: (listings) {
        final filteredListings = listings
            .where((l) => l.title.toLowerCase().contains(_query.toLowerCase()))
            .toList();

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: filteredListings.length,
          itemBuilder: (context, index) {
            final listing = filteredListings[index];
            return GlassCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: listing.images.isNotEmpty
                            ? listing.images[0]
                            : 'https://via.placeholder.com/150',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listing.title,
                          maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${listing.price}',
                          style: const TextStyle(
                            color: AppTheme.electricViolet,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: Duration(milliseconds: index * 50));
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
