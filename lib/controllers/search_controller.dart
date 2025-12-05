import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/search_service.dart';
import '../models/search_models.dart';

class SearchController extends GetxController {
  final SearchService _searchService = Get.find<SearchService>();

  // Observable state
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt selectedTabIndex = 0.obs; // 0: All, 1: Users, 2: Posts, 3: Reels

  // Search results
  final Rx<SearchResult?> searchResults = Rx<SearchResult?>(null);
  final RxList<UserSearchResult> filteredUsers = <UserSearchResult>[].obs;
  final RxList<PostSearchResult> filteredPosts = <PostSearchResult>[].obs;
  final RxList<ReelSearchResult> filteredReels = <ReelSearchResult>[].obs;
  final RxList<HashtagSearchResult> filteredHashtags =
      <HashtagSearchResult>[].obs;

  // Search history
  final RxList<String> searchHistory = <String>[].obs;
  static const int _maxHistoryItems = 10;
  static const String _historyKey = 'search_history';

  // Debouncing
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 300);

  @override
  void onInit() {
    super.onInit();
    _loadSearchHistory();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    super.onClose();
  }

  /// Perform search with debouncing
  void onSearchChanged(String query) {
    searchQuery.value = query;
    errorMessage.value = '';

    // Cancel previous timer
    _debounceTimer?.cancel();

    if (query.trim().isEmpty) {
      // Clear results when query is empty
      searchResults.value = null;
      _clearFilteredResults();
      return;
    }

    // Start new debounce timer
    _debounceTimer = Timer(_debounceDuration, () {
      performSearch(query);
    });
  }

  /// Perform the actual search
  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) return;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Determine search type based on selected tab
      String searchType = 'all';
      switch (selectedTabIndex.value) {
        case 1:
          searchType = 'users';
          break;
        case 2:
          searchType = 'posts';
          break;
        case 3:
          searchType = 'reels';
          break;
        default:
          searchType = 'all';
      }

      final results = await _searchService.search(
        query,
        type: searchType,
        limit: 20,
      );

      searchResults.value = results;
      _updateFilteredResults(results);

      // Add to search history
      _addToHistory(query);

      debugPrint(
        'Search completed: ${results.users.length} users, '
        '${results.posts.length} posts, ${results.reels.length} reels',
      );
    } catch (e) {
      errorMessage.value = 'Failed to search: ${e.toString()}';
      debugPrint('Search error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update filtered results based on current tab
  void _updateFilteredResults(SearchResult results) {
    filteredUsers.value = results.users;
    filteredPosts.value = results.posts;
    filteredReels.value = results.reels;
    filteredHashtags.value = results.hashtags;
  }

  /// Clear filtered results
  void _clearFilteredResults() {
    filteredUsers.clear();
    filteredPosts.clear();
    filteredReels.clear();
    filteredHashtags.clear();
  }

  /// Change tab and optionally re-search
  void changeTab(int index) {
    selectedTabIndex.value = index;

    // If there's a current search query, re-search with new filter
    if (searchQuery.value.trim().isNotEmpty) {
      performSearch(searchQuery.value);
    }
  }

  /// Clear search
  void clearSearch() {
    searchQuery.value = '';
    searchResults.value = null;
    _clearFilteredResults();
    errorMessage.value = '';
    _debounceTimer?.cancel();
  }

  /// Retry search after error
  void retrySearch() {
    if (searchQuery.value.trim().isNotEmpty) {
      performSearch(searchQuery.value);
    }
  }

  /// Pull to refresh
  @override
  Future<void> refresh() async {
    if (searchQuery.value.trim().isNotEmpty) {
      // Clear cache and re-search
      _searchService.clearCache();
      await performSearch(searchQuery.value);
    }
  }

  /// Load search history from SharedPreferences
  Future<void> _loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = prefs.getStringList(_historyKey) ?? [];
      searchHistory.value = history;
      debugPrint('Loaded ${history.length} search history items');
    } catch (e) {
      debugPrint('Error loading search history: $e');
    }
  }

  /// Add query to search history
  Future<void> _addToHistory(String query) async {
    try {
      final trimmedQuery = query.trim();
      if (trimmedQuery.isEmpty) return;

      // Remove if already exists
      searchHistory.remove(trimmedQuery);

      // Add to beginning
      searchHistory.insert(0, trimmedQuery);

      // Keep only last 10 items
      if (searchHistory.length > _maxHistoryItems) {
        searchHistory.value = searchHistory.take(_maxHistoryItems).toList();
      }

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_historyKey, searchHistory);
    } catch (e) {
      debugPrint('Error adding to search history: $e');
    }
  }

  /// Clear search history
  Future<void> clearHistory() async {
    try {
      searchHistory.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_historyKey);
      debugPrint('Search history cleared');
    } catch (e) {
      debugPrint('Error clearing search history: $e');
    }
  }

  /// Remove item from history
  Future<void> removeFromHistory(String query) async {
    try {
      searchHistory.remove(query);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_historyKey, searchHistory);
    } catch (e) {
      debugPrint('Error removing from history: $e');
    }
  }

  /// Search from history item
  void searchFromHistory(String query) {
    searchQuery.value = query;
    performSearch(query);
  }

  /// Check if there are any results
  bool get hasResults {
    final results = searchResults.value;
    return results != null && !results.isEmpty;
  }

  /// Check if search is empty
  bool get isSearchEmpty => searchQuery.value.trim().isEmpty;
}
