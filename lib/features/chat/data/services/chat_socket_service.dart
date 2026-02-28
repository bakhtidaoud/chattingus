import 'dart:convert';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatSocketService {
  WebSocketChannel? _channel;
  final String baseUrl =
      "ws://10.0.2.2:8000/ws/chat"; // Android Emulator default

  Stream<dynamic> connect(String conversationId, String token) {
    final url = "$baseUrl/$conversationId/?token=$token";
    _channel = IOWebSocketChannel.connect(Uri.parse(url));
    return _channel!.stream;
  }

  void sendMessage(Map<String, dynamic> data) {
    _channel?.sink.add(jsonEncode(data));
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
