import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../controllers/live_controller.dart';

class LiveViewerScreen extends StatefulWidget {
  final int streamId;

  const LiveViewerScreen({super.key, required this.streamId});

  @override
  State<LiveViewerScreen> createState() => _LiveViewerScreenState();
}

class _LiveViewerScreenState extends State<LiveViewerScreen> {
  final LiveController _controller = Get.find<LiveController>();
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  bool _isJoining = true;

  @override
  void initState() {
    super.initState();
    _joinStream();
  }

  Future<void> _joinStream() async {
    final success = await _controller.joinAsViewer(widget.streamId);
    setState(() => _isJoining = false);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _controller.error.value.isEmpty
                ? 'Failed to join stream'
                : _controller.error.value,
          ),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    _controller.leaveStream();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    await _controller.postComment(text);
    _commentController.clear();
    _commentFocusNode.unfocus();
  }

  Future<void> _sendReaction(String reactionType) async {
    await _controller.sendReaction(reactionType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isJoining
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Stack(
              fit: StackFit.expand,
              children: [
                // Video Stream
                Obx(() {
                  final renderer = _controller.remoteRenderer.value;
                  if (renderer.srcObject != null) {
                    return RTCVideoView(
                      renderer,
                      objectFit:
                          RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                    );
                  }
                  return Container(
                    color: Colors.black,
                    child: const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  );
                }),

                // Gradient Overlays
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 250,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Content
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Top Bar
                        Row(
                          children: [
                            // Back Button
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              style: IconButton.styleFrom(
                                backgroundColor: Colors.black.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // LIVE Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'LIVE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Viewer Count
                            Obx(
                              () => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.visibility,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _controller.viewerCount.value.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // Main Content Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Comments Section (Left)
                            Expanded(
                              child: Container(
                                constraints: const BoxConstraints(
                                  maxHeight: 200,
                                ),
                                child: Obx(() {
                                  final comments = _controller.comments
                                      .take(5)
                                      .toList();
                                  return ListView.builder(
                                    reverse: true,
                                    shrinkWrap: true,
                                    itemCount: comments.length,
                                    itemBuilder: (context, index) {
                                      final comment = comments[index];
                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 13,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '${comment.username} ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(text: comment.text),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Reaction Buttons (Right)
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _ReactionButton(
                                  emoji: '❤️',
                                  onPressed: () => _sendReaction('heart'),
                                ),
                                const SizedBox(height: 12),
                                _ReactionButton(
                                  emoji: '🔥',
                                  onPressed: () => _sendReaction('fire'),
                                ),
                                const SizedBox(height: 12),
                                _ReactionButton(
                                  emoji: '👏',
                                  onPressed: () => _sendReaction('clap'),
                                ),
                                const SizedBox(height: 12),
                                _ReactionButton(
                                  emoji: '😂',
                                  onPressed: () => _sendReaction('laugh'),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Comment Input
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  focusNode: _commentFocusNode,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    hintText: 'Add a comment...',
                                    hintStyle: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 14,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                  maxLines: 1,
                                  textInputAction: TextInputAction.send,
                                  onSubmitted: (_) => _sendComment(),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _sendComment,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.send,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Animated Reactions Overlay
                Obx(() {
                  return Stack(
                    children: _controller.reactions.map((reaction) {
                      return _AnimatedReaction(
                        emoji: _getReactionEmoji(reaction.type),
                      );
                    }).toList(),
                  );
                }),
              ],
            ),
    );
  }

  String _getReactionEmoji(String reactionType) {
    switch (reactionType) {
      case 'heart':
        return '❤️';
      case 'fire':
        return '🔥';
      case 'clap':
        return '👏';
      case 'laugh':
        return '😂';
      default:
        return '👍';
    }
  }
}

class _ReactionButton extends StatelessWidget {
  final String emoji;
  final VoidCallback onPressed;

  const _ReactionButton({required this.emoji, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
      ),
    );
  }
}

class _AnimatedReaction extends StatefulWidget {
  final String emoji;

  const _AnimatedReaction({required this.emoji});

  @override
  State<_AnimatedReaction> createState() => _AnimatedReactionState();
}

class _AnimatedReactionState extends State<_AnimatedReaction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _opacityAnimation;
  late double _leftPosition;

  @override
  void initState() {
    super.initState();
    _leftPosition =
        (MediaQuery.of(context).size.width * 0.2) +
        (MediaQuery.of(context).size.width * 0.6 * (0.5 - 0.5));

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _positionAnimation = Tween<double>(
      begin: MediaQuery.of(context).size.height,
      end: -100,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.7, 1.0)),
    );

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
      animation: _controller,
      builder: (context, child) {
        return Positioned(
          left: _leftPosition,
          bottom: _positionAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Text(widget.emoji, style: const TextStyle(fontSize: 32)),
          ),
        );
      },
    );
  }
}
