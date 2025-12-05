import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../network/api_client.dart';
import '../../models/search_models.dart';

class SearchService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  // Cache for search results
  final Map<String, _CachedResult> _cache = {};
  static const Duration _cacheDuration = Duration(minutes: 5);

  /// Global search across all content types
  /// [query] - Search query string (required)
  /// [type] - 'all', 'users', 'posts', 'reels', 'hashtags' (default: 'all')
  /// [limit] - Number of results per type, 1-50 (default: 10)
  Future<SearchResult> search(
    String query, {
    String type = 'all',
    int limit = 10,
  }) async {
    if (query.trim().isEmpty) {
      return SearchResult();
    }

    // Check cache first
    final cacheKey = '$query-$type-$limit';
    if (_cache.containsKey(cacheKey)) {
      final cached = _cache[cacheKey]!;
      if (!cached.isExpired) {
        debugPrint('Returning cached search results for: $query');
        return cached.result;
      } else {
        _cache.remove(cacheKey);
      }
    }

    try {
      final response = await _apiClient.get(
        '/explore/search/',
        queryParameters: {'q': query, 'type': type, 'limit': limit},
      );

      if (response.statusCode == 200) {
        final result = SearchResult.fromJson(response.data);

        // Cache the result
        _cache[cacheKey] = _CachedResult(result);

        debugPrint(
          'Search successful: ${result.users.length} users, '
          '${result.posts.length} posts, ${result.reels.length} reels, '
          '${result.hashtags.length} hashtags',
        );

        return result;
      } else {
        throw Exception('Search failed: ${response.statusMessage}');
      }
    } catch (e) {
      debugPrint('Error searching: $e');
      rethrow;
    }
  }

  /// Search only users
  Future<List<UserSearchResult>> searchUsers(
    String query, {
    int limit = 10,
  }) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      final result = await search(query, type: 'users', limit: limit);
      return result.users;
    } catch (e) {
      debugPrint('Error searching users: $e');
      rethrow;
    }
  }

  /// Search only posts
  Future<List<PostSearchResult>> searchPosts(
    String query, {
    int limit = 10,
  }) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      final result = await search(query, type: 'posts', limit: limit);
      return result.posts;
    } catch (e) {
      debugPrint('Error searching posts: $e');
      rethrow;
    }
  }

  /// Search only reels
  Future<List<ReelSearchResult>> searchReels(
    String query, {
    int limit = 10,
  }) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      final result = await search(query, type: 'reels', limit: limit);
      return result.reels;
    } catch (e) {
      debugPrint('Error searching reels: $e');
      rethrow;
    }
  }

  /// Clear the search cache
  void clearCache() {
    _cache.clear();
    debugPrint('Search cache cleared');
  }

  /// Clear expired cache entries
  void clearExpiredCache() {
    _cache.removeWhere((key, value) => value.isExpired);
    debugPrint('Expired cache entries cleared');
  }
}

/// Internal class for caching search results
class _CachedResult {
  final SearchResult result;
  final DateTime timestamp;

  _CachedResult(this.result) : timestamp = DateTime.now();

  bool get isExpired =>
      DateTime.now().difference(timestamp) > SearchService._cacheDuration;
}
