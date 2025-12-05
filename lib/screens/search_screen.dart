import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart' as app;
import '../l10n/app_localizations.dart';
import '../widgets/search_widgets.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(app.SearchController());
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(controller, l10n, theme),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Tab bar
          _buildTabBar(controller, l10n, theme),
          const Divider(height: 1),
          // Content
          Expanded(
            child: Obx(() {
              if (controller.isSearchEmpty) {
                return _buildRecentSearches(controller, l10n);
              } else if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.errorMessage.value.isNotEmpty) {
                return SearchErrorState(
                  message: controller.errorMessage.value,
                  onRetry: controller.retrySearch,
                );
              } else if (!controller.hasResults) {
                return const SearchEmptyState(
                  message: 'No results found',
                  suggestion: 'Try different keywords or check spelling',
                );
              } else {
                return _buildSearchResults(controller);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(
    app.SearchController controller,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Obx(
      () => TextField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: l10n.searchPlaceholder,
          border: InputBorder.none,
          suffixIcon: controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: controller.clearSearch,
                )
              : null,
        ),
        onChanged: controller.onSearchChanged,
        controller: TextEditingController(text: controller.searchQuery.value)
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: controller.searchQuery.value.length),
          ),
      ),
    );
  }

  Widget _buildTabBar(
    app.SearchController controller,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Obx(
      () => Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            _buildTab(controller, 0, 'All', l10n),
            _buildTab(controller, 1, 'Users', l10n),
            _buildTab(controller, 2, 'Posts', l10n),
            _buildTab(controller, 3, 'Reels', l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
    app.SearchController controller,
    int index,
    String label,
    AppLocalizations l10n,
  ) {
    final isSelected = controller.selectedTabIndex.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearches(
    app.SearchController controller,
    AppLocalizations l10n,
  ) {
    return Obx(() {
      if (controller.searchHistory.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Start searching',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Search for users, posts, and reels',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                TextButton(
                  onPressed: controller.clearHistory,
                  child: const Text('Clear all'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: controller.searchHistory.length,
              itemBuilder: (context, index) {
                final query = controller.searchHistory[index];
                return ListTile(
                  leading: const Icon(Icons.history, color: Colors.grey),
                  title: Text(query),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => controller.removeFromHistory(query),
                  ),
                  onTap: () => controller.searchFromHistory(query),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSearchResults(app.SearchController controller) {
    return Obx(() {
      final tabIndex = controller.selectedTabIndex.value;

      return RefreshIndicator(
        onRefresh: controller.refresh,
        child: _buildResultsList(controller, tabIndex),
      );
    });
  }

  Widget _buildResultsList(app.SearchController controller, int tabIndex) {
    switch (tabIndex) {
      case 1: // Users
        return _buildUsersList(controller);
      case 2: // Posts
        return _buildPostsList(controller);
      case 3: // Reels
        return _buildReelsList(controller);
      default: // All
        return _buildAllResults(controller);
    }
  }

  Widget _buildAllResults(app.SearchController controller) {
    return ListView(
      children: [
        if (controller.filteredUsers.isNotEmpty) ...[
          _buildSectionHeader('Users', controller.filteredUsers.length),
          ...controller.filteredUsers
              .take(3)
              .map(
                (user) => UserSearchTile(
                  user: user,
                  onTap: () => _navigateToUserProfile(user.id),
                ),
              ),
          if (controller.filteredUsers.length > 3)
            _buildSeeAllButton(() => controller.changeTab(1)),
        ],
        if (controller.filteredPosts.isNotEmpty) ...[
          _buildSectionHeader('Posts', controller.filteredPosts.length),
          ...controller.filteredPosts
              .take(3)
              .map(
                (post) => PostSearchTile(
                  post: post,
                  onTap: () => _navigateToPost(post.id),
                ),
              ),
          if (controller.filteredPosts.length > 3)
            _buildSeeAllButton(() => controller.changeTab(2)),
        ],
        if (controller.filteredReels.isNotEmpty) ...[
          _buildSectionHeader('Reels', controller.filteredReels.length),
          ...controller.filteredReels
              .take(3)
              .map(
                (reel) => ReelSearchTile(
                  reel: reel,
                  onTap: () => _navigateToReel(reel.id),
                ),
              ),
          if (controller.filteredReels.length > 3)
            _buildSeeAllButton(() => controller.changeTab(3)),
        ],
        if (controller.filteredHashtags.isNotEmpty) ...[
          _buildSectionHeader('Hashtags', controller.filteredHashtags.length),
          ...controller.filteredHashtags.map(
            (hashtag) => HashtagSearchTile(
              hashtag: hashtag,
              onTap: () => _navigateToHashtag(hashtag.name),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildUsersList(app.SearchController controller) {
    if (controller.filteredUsers.isEmpty) {
      return const SearchEmptyState(
        message: 'No users found',
        suggestion: 'Try different keywords',
      );
    }

    return ListView.builder(
      itemCount: controller.filteredUsers.length,
      itemBuilder: (context, index) {
        final user = controller.filteredUsers[index];
        return UserSearchTile(
          user: user,
          onTap: () => _navigateToUserProfile(user.id),
        );
      },
    );
  }

  Widget _buildPostsList(app.SearchController controller) {
    if (controller.filteredPosts.isEmpty) {
      return const SearchEmptyState(
        message: 'No posts found',
        suggestion: 'Try different keywords',
      );
    }

    return ListView.builder(
      itemCount: controller.filteredPosts.length,
      itemBuilder: (context, index) {
        final post = controller.filteredPosts[index];
        return PostSearchTile(
          post: post,
          onTap: () => _navigateToPost(post.id),
        );
      },
    );
  }

  Widget _buildReelsList(app.SearchController controller) {
    if (controller.filteredReels.isEmpty) {
      return const SearchEmptyState(
        message: 'No reels found',
        suggestion: 'Try different keywords',
      );
    }

    return ListView.builder(
      itemCount: controller.filteredReels.length,
      itemBuilder: (context, index) {
        final reel = controller.filteredReels[index];
        return ReelSearchTile(
          reel: reel,
          onTap: () => _navigateToReel(reel.id),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        '$title ($count)',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildSeeAllButton(VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextButton(onPressed: onTap, child: const Text('See all')),
    );
  }

  // Navigation methods
  void _navigateToUserProfile(int userId) {
    // TODO: Implement navigation to user profile
    Get.snackbar('Navigate', 'To user profile: $userId');
  }

  void _navigateToPost(int postId) {
    // TODO: Implement navigation to post detail
    Get.snackbar('Navigate', 'To post: $postId');
  }

  void _navigateToReel(int reelId) {
    // TODO: Implement navigation to reel player
    Get.snackbar('Navigate', 'To reel: $reelId');
  }

  void _navigateToHashtag(String hashtag) {
    // TODO: Implement navigation to hashtag page
    Get.snackbar('Navigate', 'To hashtag: #$hashtag');
  }
}
