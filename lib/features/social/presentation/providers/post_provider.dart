import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/post.dart';
import '../../data/services/post_service.dart';

final postServiceProvider = Provider((ref) => PostService());

final feedProvider =
    StateNotifierProvider<FeedNotifier, AsyncValue<List<Post>>>((ref) {
      return FeedNotifier(ref.watch(postServiceProvider));
    });

class FeedNotifier extends StateNotifier<AsyncValue<List<Post>>> {
  final PostService _service;
  int _currentPage = 1;
  bool _hasMore = true;

  FeedNotifier(this._service) : super(const AsyncValue.loading()) {
    getFeed();
  }

  Future<void> getFeed() async {
    if (!_hasMore) return;

    try {
      final response = await _service.getFeed(page: _currentPage);
      final List<Post> newPosts = (response.data['results'] as List)
          .map((json) => Post.fromJson(json))
          .toList();

      if (newPosts.isEmpty) {
        _hasMore = false;
      }

      state = AsyncValue.data([
        if (state is AsyncData) ...(state.asData!.value),
        ...newPosts,
      ]);
      _currentPage++;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    _currentPage = 1;
    _hasMore = true;
    state = const AsyncValue.loading();
    await getFeed();
  }
}
