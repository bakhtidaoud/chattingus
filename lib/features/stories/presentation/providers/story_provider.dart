import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/story.dart';
import '../../data/services/story_service.dart';

final storyServiceProvider = Provider((ref) => StoryService());

final followingStoriesProvider = FutureProvider<List<UserStories>>((ref) async {
  final service = ref.watch(storyServiceProvider);
  final response = await service.getFollowingStories();

  final Map<String, UserStories> grouped = {};

  for (var item in (response.data as List)) {
    final story = Story.fromJson(item);
    final userId = item['author']['id'].toString();

    if (grouped.containsKey(userId)) {
      grouped[userId]!.stories.add(story);
    } else {
      grouped[userId] = UserStories(
        userId: userId,
        username: item['author']['username'],
        profileImage: story.authorImage,
        stories: [story],
      );
    }
  }

  return grouped.values.toList();
});
