import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class ChatDetailController extends GetxController
    with GetTickerProviderStateMixin {
  final messageController = TextEditingController();
  var messages = <Map<String, dynamic>>[
    {
      'isMe': false,
      'message':
          'Hey, are you free to chat? I have some updates on the project.',
      'time': '10:31 AM',
      'type': 'text',
    },
    {
      'isMe': true,
      'message': 'Hi Alex! Yes, I\'m available. Send them over.',
      'time': '10:32 AM',
      'type': 'text',
      'status': 'Read',
    },
    {
      'isMe': false,
      'message': 'Also, check out this new video feature!',
      'time': '10:32 AM',
      'type': 'text',
    },
    {
      'isMe': false,
      'message': 'Reel Shared',
      'time': '10:32 AM',
      'type': 'reel',
      'imageUrl':
          'https://i.pravatar.cc/300?u=8', // Placeholder for reel thumbnail
    },
    {
      'isMe': true,
      'message': 'Looks cool! I\'ll check it out after the meeting.',
      'time': '10:34 AM',
      'type': 'text',
      'status': 'Read',
    },
  ].obs;

  // Audio recording state
  var isRecording = false.obs;
  var recordingDuration = 0.obs;
  var slideOffset = 0.0.obs;
  Timer? _recordingTimer;
  late AnimationController waveAnimationController;

  @override
  void onInit() {
    super.onInit();
    waveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  void startRecording() {
    isRecording.value = true;
    recordingDuration.value = 0;
    slideOffset.value = 0.0;

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      recordingDuration.value++;
    });
  }

  void stopRecording() {
    isRecording.value = false;
    _recordingTimer?.cancel();
    recordingDuration.value = 0;
    slideOffset.value = 0.0;

    // Here you would normally save the audio recording
    messages.add({
      'isMe': true,
      'message': 'Voice message',
      'time': 'Now',
      'type': 'audio',
      'status': 'Sent',
      'duration': recordingDuration.value,
    });
  }

  void cancelRecording() {
    isRecording.value = false;
    _recordingTimer?.cancel();
    recordingDuration.value = 0;
    slideOffset.value = 0.0;
  }

  void updateSlideOffset(double offset) {
    slideOffset.value = offset;
    if (offset < -100) {
      cancelRecording();
    }
  }

  String getFormattedDuration() {
    final minutes = (recordingDuration.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (recordingDuration.value % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      messages.add({
        'isMe': true,
        'message': messageController.text,
        'time': 'Now',
        'type': 'text',
        'status': 'Sent',
      });
      messageController.clear();
    }
  }

  @override
  void onClose() {
    messageController.dispose();
    _recordingTimer?.cancel();
    waveAnimationController.dispose();
    super.onClose();
  }
}
