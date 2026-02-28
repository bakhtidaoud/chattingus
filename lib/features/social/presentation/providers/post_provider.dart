import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../data/models/post.dart';
import '../../data/services/post_service.dart';

final postServiceProvider = Provider((ref) => PostService());

final feedProvider = AsyncNotifierProvider<FeedNotifier, List<Post>>(
  FeedNotifier.new,
);

class FeedNotifier extends AsyncNotifier<List<Post>> {
  int _currentPage = 1;
  bool _hasMore = true;

  @override
  FutureOr<List<Post>> build() async {
    _currentPage = 1;
    _hasMore = true;
    return _fetchFeed();
  }

  Future<List<Post>> _fetchFeed() async {
    if (!_hasMore) {
      if (state is AsyncData) return state.asData!.value;
      return [];
    }

    final service = ref.read(postServiceProvider);
    final response = await service.getFeed(page: _currentPage);
    final List<Post> newPosts = (response.data['results'] as List)
        .map((json) => Post.fromJson(json))
        .toList();

    if (newPosts.isEmpty) {
      _hasMore = false;
    }

    final currentPosts = (state is AsyncData) ? state.asData!.value : <Post>[];
    return [...currentPosts, ...newPosts];
  }

  Future<void> getFeed() async {
    if (!_hasMore) return;
    try {
      final newPosts = await _fetchFeed();
      state = AsyncValue.data(newPosts);
      _currentPage++;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    state = const AsyncValue.loading();
    try {
      final newPosts = await _fetchFeed();
      state = AsyncValue.data(newPosts);
      _currentPage++;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
