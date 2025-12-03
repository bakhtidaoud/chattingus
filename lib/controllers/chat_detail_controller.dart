import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatDetailController extends GetxController {
  final messageController = TextEditingController();
  var messages = <Map<String, dynamic>>[
    {
      'isMe': false,
      'message': 'Hey, are you free to chat? I have some updates on the project.',
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
      'imageUrl': 'https://i.pravatar.cc/300?u=8', // Placeholder for reel thumbnail
    },
    {
      'isMe': true,
      'message': 'Looks cool! I\'ll check it out after the meeting.',
      'time': '10:34 AM',
      'type': 'text',
      'status': 'Read',
    },
  ].obs;

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
    super.onClose();
  }
}
