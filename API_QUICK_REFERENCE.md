# ChattingUs API Integration - Quick Reference

## Service Initialization

Add to your `main.dart`:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize services
  await Get.putAsync(() async => TokenStorageService());
  Get.put(ApiClient());
  Get.put(AuthService());
  Get.put(UserService());
  Get.put(PostService());
  Get.put(ChatService());
  
  // Initialize controllers
  Get.put(UserProfileController());
  Get.put(FeedController());
  Get.put(ChatController());
  
  runApp(MyApp());
}
```

## Quick API Reference

### Authentication

```dart
final authService = Get.find<AuthService>();

// Register
await authService.register(
  username: 'user',
  email: 'user@example.com',
  password: 'pass123',
  password2: 'pass123',
  firstName: 'John',
  lastName: 'Doe',
  phoneNumber: '+1234567890',
);

// Login
await authService.login('username', 'password');

// Logout
await authService.logout();
```

### User Profile

```dart
final controller = Get.find<UserProfileController>();

// Get current user (reactive)
final user = controller.currentUser.value;

// Update profile
await controller.updateProfile({
  'first_name': 'Johnny',
  'bio': 'New bio',
});

// Search users
final users = await controller.searchUsers('query');
```

### Feed/Posts

```dart
final controller = Get.find<FeedController>();

// Get feed (reactive)
final posts = controller.posts;

// Refresh feed
await controller.refreshFeed();

// Create post
await controller.createPost(
  caption: 'My post',
  image: imageFile,
  location: 'New York',
);

// Like post
await controller.likePost(postId);

// Add comment
await controller.addComment(postId, 'Nice!');
```

### Chat

```dart
final controller = Get.find<ChatController>();

// Get chats (reactive)
final chats = controller.chats;

// Get messages
await controller.fetchMessages(chatId);
final messages = controller.messages;

// Send message
await controller.sendMessage(chatId, 'Hello!');
```

## Reactive UI Pattern

```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FeedController>();
    
    return Obx(() {
      if (controller.isLoading.value) {
        return CircularProgressIndicator();
      }
      
      return ListView.builder(
        itemCount: controller.posts.length,
        itemBuilder: (context, index) {
          final post = controller.posts[index];
          return Text(post.caption);
        },
      );
    });
  }
}
```

## API Endpoints

| Endpoint | Method | Service Method |
|----------|--------|----------------|
| `/users/register/` | POST | `authService.register()` |
| `/token/` | POST | `authService.login()` |
| `/token/refresh/` | POST | Auto (via interceptor) |
| `/users/me/` | GET | `userService.getCurrentUserProfile()` |
| `/users/me/` | PATCH | `userService.updateProfile()` |
| `/users/search/` | GET | `userService.searchUsers()` |
| `/posts/` | GET | `postService.getFeed()` |
| `/posts/` | POST | `postService.createPost()` |
| `/posts/{id}/like/` | POST | `postService.likePost()` |
| `/posts/{id}/comments/` | POST | `postService.addComment()` |
| `/chat/chats/` | GET | `chatService.fetchChats()` |
| `/chat/messages/` | GET | `chatService.fetchMessages()` |
| `/chat/messages/` | POST | `chatService.sendMessage()` |

## Error Handling

All controllers have error handling:

```dart
final controller = Get.find<FeedController>();

// Check for errors
if (controller.errorMessage.value.isNotEmpty) {
  print('Error: ${controller.errorMessage.value}');
}

// Display errors in UI
Obx(() => controller.errorMessage.value.isNotEmpty
  ? Text(controller.errorMessage.value, style: TextStyle(color: Colors.red))
  : SizedBox.shrink()
)
```

## Models

- `User` - User profile with all fields
- `Post` - Feed post with author, image, likes, comments
- `Comment` - Post comment with author and text
- `Chat` - Chat conversation with participants
- `Message` - Chat message with sender and content

All models have `fromJson()` and `toJson()` methods for automatic serialization.
