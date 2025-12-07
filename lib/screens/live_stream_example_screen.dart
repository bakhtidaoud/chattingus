import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../controllers/live_controller.dart';
import '../models/stream_model.dart';

/// Example screen showing how to use the LiveController
/// This demonstrates both broadcaster and viewer functionality
class LiveStreamExampleScreen extends StatelessWidget {
  const LiveStreamExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final liveController = Get.put(LiveController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Streams'),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () => _showStartBroadcastDialog(context),
          ),
        ],
      ),
      body: Obx(() {
        if (liveController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (liveController.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(liveController.error.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => liveController.fetchStreams(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (liveController.streams.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.live_tv, size: 48),
                const SizedBox(height: 16),
                const Text('No active streams'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => liveController.fetchStreams(),
                  child: const Text('Refresh'),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => liveController.fetchStreams(),
          child: ListView.builder(
            itemCount: liveController.streams.length,
            itemBuilder: (context, index) {
              final stream = liveController.streams[index];
              return _StreamListItem(stream: stream);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showStartBroadcastDialog(context),
        icon: const Icon(Icons.videocam),
        label: const Text('Go Live'),
      ),
    );
  }

  void _showStartBroadcastDialog(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Live Stream'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter stream title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                hintText: 'Enter stream description',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.isEmpty) {
                Get.snackbar('Error', 'Please enter a title');
                return;
              }

              Navigator.pop(context);

              final liveController = Get.find<LiveController>();
              final success = await liveController.startBroadcast(
                title: titleController.text,
                description: descriptionController.text.isEmpty
                    ? null
                    : descriptionController.text,
              );

              if (success) {
                Get.to(() => const BroadcasterScreen());
              } else {
                Get.snackbar('Error', liveController.error.value);
              }
            },
            child: const Text('Start'),
          ),
        ],
      ),
    );
  }
}

class _StreamListItem extends StatelessWidget {
  final StreamModel stream;

  const _StreamListItem({required this.stream});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: stream.broadcasterAvatar != null
              ? NetworkImage(stream.broadcasterAvatar!)
              : null,
          child: stream.broadcasterAvatar == null
              ? Text(stream.broadcasterName[0].toUpperCase())
              : null,
        ),
        title: Text(stream.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stream.broadcasterName),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.visibility, size: 16),
                const SizedBox(width: 4),
                Text('${stream.viewerCount} viewers'),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        onTap: () => _joinStream(context, stream.id),
      ),
    );
  }

  void _joinStream(BuildContext context, int streamId) async {
    final liveController = Get.find<LiveController>();
    final success = await liveController.joinAsViewer(streamId);

    if (success) {
      Get.to(() => const ViewerScreen());
    } else {
      Get.snackbar('Error', liveController.error.value);
    }
  }
}

/// Broadcaster screen showing local video and stream controls
class BroadcasterScreen extends StatelessWidget {
  const BroadcasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final liveController = Get.find<LiveController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Broadcasting'),
        actions: [
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () async {
              await liveController.stopBroadcast();
              Get.back();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Local video preview
          Expanded(
            flex: 3,
            child: Obx(() => RTCVideoView(liveController.localRenderer.value)),
          ),
          // Stream info
          Container(
            padding: const EdgeInsets.all(16),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _InfoChip(
                    icon: Icons.visibility,
                    label: '${liveController.viewerCount.value} viewers',
                  ),
                  _InfoChip(
                    icon: Icons.comment,
                    label: '${liveController.comments.length} comments',
                  ),
                ],
              ),
            ),
          ),
          // Comments section
          Expanded(flex: 2, child: _CommentsSection()),
        ],
      ),
    );
  }
}

/// Viewer screen showing remote video and interaction controls
class ViewerScreen extends StatelessWidget {
  const ViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final liveController = Get.find<LiveController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () =>
              Text(liveController.currentStream.value?.title ?? 'Live Stream'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await liveController.leaveStream();
              Get.back();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Remote video
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Obx(() => RTCVideoView(liveController.remoteRenderer.value)),
                // Viewer count overlay
                Positioned(
                  top: 16,
                  left: 16,
                  child: Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.visibility,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${liveController.viewerCount.value}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Reactions overlay
                Positioned(
                  right: 16,
                  bottom: 100,
                  child: Obx(
                    () => Column(
                      children: liveController.reactions
                          .map(
                            (reaction) =>
                                _ReactionAnimation(type: reaction.type),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Reaction buttons
          Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _ReactionButton(
                  emoji: '❤️',
                  type: 'love',
                  onTap: () => liveController.sendReaction('love'),
                ),
                _ReactionButton(
                  emoji: '👍',
                  type: 'like',
                  onTap: () => liveController.sendReaction('like'),
                ),
                _ReactionButton(
                  emoji: '🔥',
                  type: 'fire',
                  onTap: () => liveController.sendReaction('fire'),
                ),
                _ReactionButton(
                  emoji: '😮',
                  type: 'wow',
                  onTap: () => liveController.sendReaction('wow'),
                ),
              ],
            ),
          ),
          // Comments section
          Expanded(flex: 2, child: _CommentsSection()),
        ],
      ),
    );
  }
}

class _CommentsSection extends StatelessWidget {
  final TextEditingController _commentController = TextEditingController();

  _CommentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final liveController = Get.find<LiveController>();

    return Column(
      children: [
        Expanded(
          child: Obx(
            () => ListView.builder(
              reverse: true,
              itemCount: liveController.comments.length,
              itemBuilder: (context, index) {
                final comment = liveController.comments.reversed
                    .toList()[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: comment.userAvatar != null
                        ? NetworkImage(comment.userAvatar!)
                        : null,
                    child: comment.userAvatar == null
                        ? Text(comment.username[0].toUpperCase())
                        : null,
                  ),
                  title: Text(comment.username),
                  subtitle: Text(comment.text),
                );
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    hintText: 'Add a comment...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_commentController.text.isNotEmpty) {
                    liveController.postComment(_commentController.text);
                    _commentController.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Chip(avatar: Icon(icon, size: 16), label: Text(label));
  }
}

class _ReactionButton extends StatelessWidget {
  final String emoji;
  final String type;
  final VoidCallback onTap;

  const _ReactionButton({
    required this.emoji,
    required this.type,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
          ],
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}

class _ReactionAnimation extends StatefulWidget {
  final String type;

  const _ReactionAnimation({required this.type});

  @override
  State<_ReactionAnimation> createState() => _ReactionAnimationState();
}

class _ReactionAnimationState extends State<_ReactionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  String get emoji {
    switch (widget.type) {
      case 'love':
        return '❤️';
      case 'like':
        return '👍';
      case 'fire':
        return '🔥';
      case 'wow':
        return '😮';
      default:
        return '👍';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: -200).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: Opacity(
            opacity: 1 - _controller.value,
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
          ),
        );
      },
    );
  }
}
