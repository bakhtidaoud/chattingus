import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/theme/app_theme.dart';
import '../data/models/story.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

class StoryPlayer extends StatefulWidget {
  final UserStories userStories;

  const StoryPlayer({super.key, required this.userStories});

  @override
  State<StoryPlayer> createState() => _StoryPlayerState();
}

class _StoryPlayerState extends State<StoryPlayer>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  int _currentIndex = 0;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController = AnimationController(vsync: this);

    final firstStory = widget.userStories.stories[0];
    _loadStory(story: firstStory, animateToPage: false);

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController.stop();
        _animController.reset();
        setState(() {
          if (_currentIndex + 1 < widget.userStories.stories.length) {
            _currentIndex++;
            _loadStory(story: widget.userStories.stories[_currentIndex]);
          } else {
            Navigator.pop(context);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _loadStory({required Story story, bool animateToPage = true}) {
    _animController.stop();
    _animController.reset();

    if (story.isVideo) {
      _videoController?.dispose();
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(story.mediaUrl))
            ..initialize().then((_) {
              setState(() {});
              if (_videoController!.value.isInitialized) {
                _animController.duration = _videoController!.value.duration;
                _videoController!.play();
                _animController.forward();
              }
            });
    } else {
      _animController.duration = const Duration(seconds: 5);
      _animController.forward();
    }

    if (animateToPage) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.userStories.stories[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details, story),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.userStories.stories.length,
              itemBuilder: (context, index) {
                final s = widget.userStories.stories[index];
                if (s.isVideo) {
                  if (_videoController != null &&
                      _videoController!.value.isInitialized) {
                    return Center(
                      child: AspectRatio(
                        aspectRatio: _videoController!.value.aspectRatio,
                        child: VideoPlayer(_videoController!),
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                }
                return CachedNetworkImage(
                  imageUrl: s.mediaUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                );
              },
            ),

            // Top Progress Bars
            Positioned(
              top: 40.0,
              left: 10.0,
              right: 10.0,
              child: Row(
                children: widget.userStories.stories
                    .asMap()
                    .map((i, s) {
                      return MapEntry(
                        i,
                        AnimatedBar(
                          animController: _animController,
                          position: i,
                          currentIndex: _currentIndex,
                        ),
                      );
                    })
                    .values
                    .toList(),
              ),
            ),

            // User Info
            Positioned(
              top: 60.0,
              left: 20.0,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(
                      widget.userStories.profileImage,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.userStories.username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Reactions/Reply at bottom
            Positioned(
              bottom: 40.0,
              left: 20.0,
              right: 20.0,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Send message...',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _buildReactionIcon('🔥'),
                  const SizedBox(width: 8),
                  _buildReactionIcon('❤️'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionIcon(String emoji) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  void _onTapDown(TapDownDetails details, Story story) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex--;
          _loadStory(story: widget.userStories.stories[_currentIndex]);
        }
      });
    } else if (dx > 2 * screenWidth / 3) {
      setState(() {
        if (_currentIndex + 1 < widget.userStories.stories.length) {
          _currentIndex++;
          _loadStory(story: widget.userStories.stories[_currentIndex]);
        } else {
          Navigator.pop(context);
        }
      });
    }
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController animController;
  final int position;
  final int currentIndex;

  const AnimatedBar({
    super.key,
    required this.animController,
    required this.position,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                _buildContainer(
                  double.infinity,
                  position < currentIndex
                      ? Colors.white
                      : Colors.white.withOpacity(0.5),
                ),
                position == currentIndex
                    ? AnimatedBuilder(
                        animation: animController,
                        builder: (context, child) {
                          return _buildContainer(
                            constraints.maxWidth * animController.value,
                            Colors.white,
                          );
                        },
                      )
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContainer(double width, Color color) {
    return Container(
      height: 3.0,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(1.5),
      ),
    );
  }
}
