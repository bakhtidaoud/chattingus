import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../l10n/app_localizations.dart';
import '../controllers/chat_detail_controller.dart';

class ChatDetailScreen extends StatelessWidget {
  final String name;
  final String? imageUrl;

  const ChatDetailScreen({super.key, required this.name, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final ChatDetailController controller = Get.put(ChatDetailController());
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: imageUrl != null
                  ? NetworkImage(imageUrl!)
                  : null,
              backgroundColor: Colors.grey.shade300,
              child: imageUrl == null
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Online status indicator could go here
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.blue),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.blue),
            onPressed: () {},
          ),
        ],
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: theme.primaryColor),
        titleTextStyle: TextStyle(color: theme.textTheme.bodyLarge?.color),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];
                  return _MessageBubble(
                    message: msg['message'],
                    isMe: msg['isMe'],
                    time: msg['time'],
                    type: msg['type'],
                    imageUrl: msg['imageUrl'],
                    status: msg['status'],
                  );
                },
              ),
            ),
          ),
          Obx(
            () => controller.isRecording.value
                ? _buildRecordingUI(context, controller, theme)
                : _buildInputUI(context, controller, theme, l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingUI(
    BuildContext context,
    ChatDetailController controller,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SafeArea(
        child: GestureDetector(
          onHorizontalDragUpdate: (details) {
            controller.updateSlideOffset(details.localPosition.dx - 200);
          },
          onHorizontalDragEnd: (details) {
            if (controller.slideOffset.value > -100) {
              controller.stopRecording();
            }
          },
          child: Obx(
            () => Row(
              children: [
                // Cancel indicator
                Opacity(
                  opacity: controller.slideOffset.value < -50 ? 1.0 : 0.5,
                  child: Row(
                    children: [
                      Icon(
                        Icons.chevron_left,
                        color: Colors.red.shade400,
                        size: 28,
                      ),
                      Text(
                        'Slide to cancel',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // Recording indicator with animation
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Timer
                Obx(
                  () => Text(
                    controller.getFormattedDuration(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Animated waveform
                Expanded(
                  child: AnimatedBuilder(
                    animation: controller.waveAnimationController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _WaveformPainter(
                          animation: controller.waveAnimationController,
                          color: Colors.blue,
                        ),
                        size: const Size(double.infinity, 40),
                      );
                    },
                  ),
                ),

                // Send button
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: controller.stopRecording,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputUI(
    BuildContext context,
    ChatDetailController controller,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.add, color: Colors.grey),
              onPressed: () {},
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey.shade900
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: controller.messageController,
                  decoration: InputDecoration(
                    hintText: l10n.message,
                    border: InputBorder.none,
                    suffixIcon: const Icon(
                      Icons.sticky_note_2_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.grey),
              onPressed: () {},
            ),
            GestureDetector(
              onLongPress: controller.startRecording,
              child: IconButton(
                icon: const Icon(Icons.mic, color: Colors.grey),
                onPressed: () {},
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.blue),
              onPressed: controller.sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for waveform animation
class _WaveformPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  _WaveformPainter({required this.animation, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    const barCount = 30;
    final barWidth = size.width / barCount;
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final progress = (animation.value + (i / barCount)) % 1.0;
      final height = (sin(progress * pi * 2) * 0.5 + 0.5) * size.height * 0.6;

      final x = i * barWidth + barWidth / 2;
      final startY = centerY - height / 2;
      final endY = centerY + height / 2;

      canvas.drawLine(Offset(x, startY), Offset(x, endY), paint);
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) => true;
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;
  final String type;
  final String? imageUrl;
  final String? status;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.time,
    required this.type,
    this.imageUrl,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isReel = type == 'reel';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (isReel)
            Container(
              width: 200,
              height: 300,
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: Colors.black,
              ),
              child: Stack(
                children: [
                  const Center(
                    child: Icon(
                      Icons.play_circle_fill,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: const Icon(
                      Icons.video_collection,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.blue
                    : (theme.brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.grey.shade200),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isMe
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.white : theme.textTheme.bodyLarge?.color,
                  fontSize: 16,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                if (isMe && status != null) ...[
                  const SizedBox(width: 4),
                  Text(
                    status!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
