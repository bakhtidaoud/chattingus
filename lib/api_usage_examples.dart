import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

// Import services
import 'core/services/auth_service.dart';
import 'core/services/user_service.dart';
import 'core/services/post_service.dart';
import 'core/services/chat_service.dart';

// Import controllers
import 'controllers/user_profile_controller.dart';
import 'controllers/feed_controller.dart';
import 'controllers/chat_controller.dart';

/// This file demonstrates how to use all the ChattingUs API integrations
/// in your Flutter application.

// ============================================================================
// AUTHENTICATION EXAMPLES
// ============================================================================

/// Example: Register a new user
Future<void> exampleRegister() async {
  final authService = Get.find<AuthService>();

  try {
    await authService.register(
      username: 'newuser',
      email: 'user@example.com',
      password: 'securepassword123',
      password2: 'securepassword123',
      firstName: 'John',
      lastName: 'Doe',
      phoneNumber: '+1234567890',
    );
    print('Registration successful!');
  } catch (e) {
    print('Registration failed: $e');
  }
}

/// Example: Login
Future<void> exampleLogin() async {
  final authService = Get.find<AuthService>();

  try {
    await authService.login('newuser', 'securepassword123');
    print('Login successful!');
  } catch (e) {
    print('Login failed: $e');
  }
}

/// Example: Logout
Future<void> exampleLogout() async {
  final authService = Get.find<AuthService>();
  await authService.logout();
  print('Logged out successfully');
}

// ============================================================================
// USER PROFILE EXAMPLES
// ============================================================================

/// Example: Get current user profile using controller
void exampleGetUserProfile() {
  final userProfileController = Get.find<UserProfileController>();

  // The controller automatically loads the profile on init
  // Access the user data reactively
  final user = userProfileController.currentUser.value;
  if (user != null) {
    print('Username: ${user.username}');
    print('Email: ${user.email}');
    print('Display Name: ${userProfileController.displayName}');
    print('Followers: ${user.followersCount}');
    print('Following: ${user.followingCount}');
    print('Posts: ${user.postsCount}');
  }
}

/// Example: Update user profile
Future<void> exampleUpdateProfile() async {
  final userProfileController = Get.find<UserProfileController>();

  final success = await userProfileController.updateProfile({
    'first_name': 'Johnny',
    'bio': 'Updated bio text',
  });

  if (success) {
    print('Profile updated successfully!');
  } else {
    print('Failed to update profile');
  }
}

/// Example: Search for users
Future<void> exampleSearchUsers() async {
  final userProfileController = Get.find<UserProfileController>();

  final users = await userProfileController.searchUsers('john');
  print('Found ${users.length} users');
  for (var user in users) {
    print('- ${user.username} (${user.email})');
  }
}

// ============================================================================
// POSTS/FEED EXAMPLES
// ============================================================================

/// Example: Get feed using controller
void exampleGetFeed() {
  final feedController = Get.find<FeedController>();

  // The controller automatically loads the feed on init
  // Access posts reactively
  final posts = feedController.posts;
  print('Feed has ${posts.length} posts');

  for (var post in posts) {
    print('Post by ${post.author.username}: ${post.caption}');
    print('  Likes: ${post.likesCount}, Comments: ${post.commentsCount}');
  }
}

/// Example: Refresh feed
Future<void> exampleRefreshFeed() async {
  final feedController = Get.find<FeedController>();
  await feedController.refreshFeed();
  print('Feed refreshed!');
}

/// Example: Create a new post
Future<void> exampleCreatePost(File imageFile) async {
  final feedController = Get.find<FeedController>();

  final success = await feedController.createPost(
    caption: 'My new post!',
    image: imageFile,
    location: 'New York, USA',
  );

  if (success) {
    print('Post created successfully!');
  } else {
    print('Failed to create post');
  }
}

/// Example: Like a post
Future<void> exampleLikePost(int postId) async {
  final feedController = Get.find<FeedController>();
  await feedController.likePost(postId);
  print('Post liked!');
}

/// Example: Add comment to a post
Future<void> exampleAddComment(int postId) async {
  final feedController = Get.find<FeedController>();

  final comment = await feedController.addComment(postId, 'Nice photo!');
  if (comment != null) {
    print('Comment added successfully!');
  } else {
    print('Failed to add comment');
  }
}

// ============================================================================
// CHAT EXAMPLES
// ============================================================================

/// Example: Get all chats using controller
void exampleGetChats() {
  final chatController = Get.find<ChatController>();

  // The controller automatically loads chats on init
  final chats = chatController.chats;
  print('You have ${chats.length} chats');

  for (var chat in chats) {
    print('Chat with: ${chat.participantsUsernames.join(", ")}');
    if (chat.lastMessage != null) {
      print('  Last message: ${chat.lastMessage!.content}');
    }
  }
}

/// Example: Get messages for a specific chat
Future<void> exampleGetMessages(int chatId) async {
  final chatController = Get.find<ChatController>();

  await chatController.fetchMessages(chatId);
  final messages = chatController.messages;

  print('Chat has ${messages.length} messages');
  for (var message in messages) {
    print('${message.senderUsername}: ${message.content}');
  }
}

/// Example: Send a message
Future<void> exampleSendMessage(int chatId) async {
  final chatController = Get.find<ChatController>();

  await chatController.sendMessage(chatId, 'How are you?');
  print('Message sent!');
}

// ============================================================================
// REACTIVE UI EXAMPLES
// ============================================================================

/// Example: Build a reactive user profile widget
class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserProfileController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const CircularProgressIndicator();
      }

      final user = controller.currentUser.value;
      if (user == null) {
        return const Text('No user data');
      }

      return Column(
        children: [
          if (user.profilePicture != null)
            CircleAvatar(
              backgroundImage: NetworkImage(user.profilePicture!),
              radius: 50,
            ),
          Text(controller.displayName, style: const TextStyle(fontSize: 24)),
          Text('@${user.username}'),
          if (user.bio != null) Text(user.bio!),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Posts: ${user.postsCount ?? 0}'),
              Text('Followers: ${user.followersCount ?? 0}'),
              Text('Following: ${user.followingCount ?? 0}'),
            ],
          ),
        ],
      );
    });
  }
}

/// Example: Build a reactive feed widget
class FeedWidget extends StatelessWidget {
  const FeedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeedController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
        onRefresh: controller.refreshFeed,
        child: ListView.builder(
          itemCount: controller.posts.length,
          itemBuilder: (context, index) {
            final post = controller.posts[index];
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: post.author.profilePicture != null
                          ? NetworkImage(post.author.profilePicture!)
                          : null,
                    ),
                    title: Text(post.author.username),
                    subtitle: Text(post.location ?? ''),
                  ),
                  if (post.image != null)
                    Image.network(post.image!, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                post.isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: post.isLiked ? Colors.red : null,
                              ),
                              onPressed: () => controller.likePost(post.id),
                            ),
                            Text('${post.likesCount} likes'),
                            const SizedBox(width: 16),
                            IconButton(
                              icon: const Icon(Icons.comment),
                              onPressed: () {
                                // Open comment dialog
                              },
                            ),
                            Text('${post.commentsCount} comments'),
                          ],
                        ),
                        Text(post.caption),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}

/// Example: Build a reactive chat list widget
class ChatListWidget extends StatelessWidget {
  const ChatListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return ListView.builder(
        itemCount: controller.chats.length,
        itemBuilder: (context, index) {
          final chat = controller.chats[index];
          return ListTile(
            title: Text(chat.participantsUsernames.join(', ')),
            subtitle: chat.lastMessage != null
                ? Text(chat.lastMessage!.content)
                : null,
            trailing: chat.lastMessage != null
                ? Text(
                    '${chat.lastMessage!.createdAt.hour}:${chat.lastMessage!.createdAt.minute}',
                  )
                : null,
            onTap: () {
              // Navigate to chat detail screen
              controller.fetchMessages(chat.id);
            },
          );
        },
      );
    });
  }
}
