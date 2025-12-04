import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../core/services/post_service.dart';
import '../models/post_model.dart';
import '../models/comment_model.dart';

class FeedController extends GetxController {
  final PostService _postService = Get.find<PostService>();

  final RxList<Post> posts = <Post>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isRefreshing = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadFeed();
  }

  /// Load feed posts
  Future<void> loadFeed() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final feedPosts = await _postService.getFeed();
      posts.value = feedPosts;
    } catch (e) {
      errorMessage.value = 'Failed to load feed: $e';
      debugPrint('Error loading feed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh feed
  Future<void> refreshFeed() async {
    try {
      isRefreshing.value = true;
      errorMessage.value = '';
      final feedPosts = await _postService.getFeed();
      posts.value = feedPosts;
    } catch (e) {
      errorMessage.value = 'Failed to refresh feed: $e';
      debugPrint('Error refreshing feed: $e');
    } finally {
      isRefreshing.value = false;
    }
  }

  /// Create a new post
  Future<bool> createPost({
    required String caption,
    required File image,
    String? location,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      final newPost = await _postService.createPost(
        caption: caption,
        image: image,
        location: location,
      );
      // Add the new post to the beginning of the list
      posts.insert(0, newPost);
      return true;
    } catch (e) {
      errorMessage.value = 'Failed to create post: $e';
      debugPrint('Error creating post: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Like a post
  Future<void> likePost(int postId) async {
    try {
      await _postService.likePost(postId);
      // Update the post in the list
      final index = posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        final post = posts[index];
        // Create a new post object with updated like status
        final updatedPost = Post(
          id: post.id,
          author: post.author,
          caption: post.caption,
          image: post.image,
          location: post.location,
          likesCount: post.isLiked ? post.likesCount - 1 : post.likesCount + 1,
          commentsCount: post.commentsCount,
          createdAt: post.createdAt,
          isLiked: !post.isLiked,
        );
        posts[index] = updatedPost;
      }
    } catch (e) {
      errorMessage.value = 'Failed to like post: $e';
      debugPrint('Error liking post: $e');
    }
  }

  /// Add comment to a post
  Future<Comment?> addComment(int postId, String text) async {
    try {
      errorMessage.value = '';
      final comment = await _postService.addComment(postId, text);
      // Update the comments count in the post
      final index = posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        final post = posts[index];
        final updatedPost = Post(
          id: post.id,
          author: post.author,
          caption: post.caption,
          image: post.image,
          location: post.location,
          likesCount: post.likesCount,
          commentsCount: post.commentsCount + 1,
          createdAt: post.createdAt,
          isLiked: post.isLiked,
        );
        posts[index] = updatedPost;
      }
      return comment;
    } catch (e) {
      errorMessage.value = 'Failed to add comment: $e';
      debugPrint('Error adding comment: $e');
      return null;
    }
  }
}
