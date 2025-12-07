import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/services/live_service.dart';
import '../core/services/token_storage_service.dart';
import '../core/services/network_connectivity_service.dart';
import '../core/constants/api_constants.dart';
import '../models/stream_model.dart';
import '../models/live_comment_model.dart';
import '../models/reaction_model.dart';

class LiveController extends GetxController {
  final LiveService _liveService = Get.find<LiveService>();
  final TokenStorageService _tokenService = Get.find<TokenStorageService>();
  final NetworkConnectivityService _networkService =
      Get.find<NetworkConnectivityService>();

  // Observable state
  final RxList<StreamModel> streams = <StreamModel>[].obs;
  final Rx<StreamModel?> currentStream = Rx<StreamModel?>(null);
  final RxList<LiveComment> comments = <LiveComment>[].obs;
  final RxList<ReactionModel> reactions = <ReactionModel>[].obs;
  final RxInt viewerCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isBroadcasting = false.obs;
  final RxBool isViewing = false.obs;
  final RxString error = ''.obs;

  // WebSocket
  WebSocketChannel? _webSocketChannel;
  StreamSubscription? _webSocketSubscription;
  StreamSubscription? _networkSubscription;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;

  // WebRTC
  webrtc.RTCPeerConnection? _peerConnection;
  final Map<String, webrtc.RTCPeerConnection> _viewerConnections = {};
  webrtc.MediaStream? _localStream;
  final Rx<webrtc.RTCVideoRenderer> localRenderer =
      webrtc.RTCVideoRenderer().obs;
  final Rx<webrtc.RTCVideoRenderer> remoteRenderer =
      webrtc.RTCVideoRenderer().obs;

  // ICE Servers (Google's public STUN servers)
  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {'urls': 'stun:stun1.l.google.com:19302'},
      {'urls': 'stun:stun2.l.google.com:19302'},
    ],
  };

  // Media constraints
  final Map<String, dynamic> _mediaConstraints = {
    'audio': true,
    'video': {
      'facingMode': 'user',
      'width': {'ideal': 1280},
      'height': {'ideal': 720},
    },
  };

  @override
  void onInit() {
    super.onInit();
    _initializeRenderers();
    _listenToNetworkChanges();
  }

  @override
  void onClose() {
    _networkSubscription?.cancel();
    _cleanup();
    super.onClose();
  }

  void _listenToNetworkChanges() {
    _networkSubscription = _networkService.isOnline.listen((isOnline) {
      if (!isOnline) {
        debugPrint('📡 Network offline - pausing WebSocket');
        _webSocketChannel?.sink.close();
      } else if (currentStream.value != null &&
          (isBroadcasting.value || isViewing.value)) {
        debugPrint('📡 Network online - reconnecting WebSocket');
        _connectWebSocket(currentStream.value!.id);
      }
    });
  }

  Future<void> _initializeRenderers() async {
    try {
      await localRenderer.value.initialize();
      await remoteRenderer.value.initialize();
      debugPrint('Video renderers initialized');
    } catch (e) {
      debugPrint('Error initializing renderers: $e');
    }
  }

  // ==================== Stream Management ====================

  /// Fetch all active streams
  Future<void> fetchStreams() async {
    try {
      isLoading.value = true;
      error.value = '';
      final fetchedStreams = await _liveService.getStreams();
      streams.value = fetchedStreams;
    } catch (e) {
      error.value = 'Failed to fetch streams: $e';
      debugPrint(error.value);
    } finally {
      isLoading.value = false;
    }
  }

  /// Create a new stream
  Future<StreamModel?> createStream({
    required String title,
    String? description,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';
      final stream = await _liveService.createStream(
        title: title,
        description: description,
      );
      currentStream.value = stream;
      return stream;
    } catch (e) {
      error.value = 'Failed to create stream: $e';
      debugPrint(error.value);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  // ==================== Broadcasting ====================

  /// Start broadcasting a stream
  Future<bool> startBroadcast({
    required String title,
    String? description,
  }) async {
    try {
      debugPrint('=== STARTING BROADCAST ===');

      // Request permissions
      final hasPermissions = await _requestPermissions();
      if (!hasPermissions) {
        error.value = 'Camera and microphone permissions are required';
        return false;
      }

      // Create stream on backend
      final stream = await createStream(title: title, description: description);
      if (stream == null) return false;

      // Initialize local media stream
      _localStream = await webrtc.navigator.mediaDevices.getUserMedia(
        _mediaConstraints,
      );
      localRenderer.value.srcObject = _localStream;
      debugPrint('Local media stream initialized');

      // Start the stream on backend
      final startedStream = await _liveService.startStream(stream.id);
      currentStream.value = startedStream;

      // Connect to WebSocket
      await _connectWebSocket(stream.id);

      // Setup WebRTC peer connection
      await _setupBroadcasterPeerConnection();

      isBroadcasting.value = true;
      debugPrint('Broadcast started successfully');
      return true;
    } catch (e) {
      error.value = 'Failed to start broadcast: $e';
      debugPrint(error.value);
      await stopBroadcast();
      return false;
    }
  }

  /// Stop broadcasting
  Future<void> stopBroadcast() async {
    try {
      debugPrint('=== STOPPING BROADCAST ===');

      if (currentStream.value != null) {
        await _liveService.endStream(currentStream.value!.id);
      }

      await _cleanup();
      isBroadcasting.value = false;
      currentStream.value = null;
      debugPrint('Broadcast stopped');
    } catch (e) {
      debugPrint('Error stopping broadcast: $e');
    }
  }

  // ==================== Viewing ====================

  /// Join a stream as a viewer
  Future<bool> joinAsViewer(int streamId) async {
    try {
      debugPrint('=== JOINING AS VIEWER ===');
      debugPrint('Stream ID: $streamId');

      // Join stream on backend
      await _liveService.joinStream(streamId);

      // Get stream details
      final streamsList = await _liveService.getStreams();
      final stream = streamsList.firstWhereOrNull((s) => s.id == streamId);
      if (stream == null) {
        error.value = 'Stream not found';
        return false;
      }
      currentStream.value = stream;

      // Connect to WebSocket
      await _connectWebSocket(streamId);

      // Setup WebRTC peer connection for viewing
      await _setupViewerPeerConnection();

      // Load existing comments
      await _loadComments(streamId);

      isViewing.value = true;
      debugPrint('Joined stream successfully');
      return true;
    } catch (e) {
      error.value = 'Failed to join stream: $e';
      debugPrint(error.value);
      return false;
    }
  }

  /// Leave the current stream
  Future<void> leaveStream() async {
    try {
      debugPrint('=== LEAVING STREAM ===');

      if (currentStream.value != null) {
        await _liveService.leaveStream(currentStream.value!.id);
      }

      await _cleanup();
      isViewing.value = false;
      currentStream.value = null;
      comments.clear();
      reactions.clear();
      viewerCount.value = 0;
      debugPrint('Left stream');
    } catch (e) {
      debugPrint('Error leaving stream: $e');
    }
  }

  // ==================== WebSocket Management ====================

  Future<void> _connectWebSocket(int streamId) async {
    try {
      debugPrint('=== CONNECTING TO WEBSOCKET ===');

      // Get access token
      final token = await _tokenService.getAccessToken();
      if (token == null) {
        throw Exception('No access token available');
      }

      // Construct WebSocket URL
      final baseUrl = ApiConstants.baseUrl;
      final host = baseUrl
          .replaceAll('http://', '')
          .replaceAll('https://', '')
          .replaceAll('/api/', '');
      final wsProtocol = baseUrl.startsWith('https') ? 'wss' : 'ws';
      final wsUrl = '$wsProtocol://$host/ws/live/$streamId/?token=$token';

      debugPrint('WebSocket URL: $wsUrl');

      // Create WebSocket connection
      _webSocketChannel = WebSocketChannel.connect(Uri.parse(wsUrl));

      // Listen to messages
      _webSocketSubscription = _webSocketChannel!.stream.listen(
        _handleWebSocketMessage,
        onError: _handleWebSocketError,
        onDone: _handleWebSocketClosed,
      );

      _reconnectAttempts = 0;
      debugPrint('WebSocket connected');
    } catch (e) {
      debugPrint('Error connecting to WebSocket: $e');
      _scheduleReconnect(streamId);
    }
  }

  void _handleWebSocketMessage(dynamic message) {
    try {
      final data = jsonDecode(message);
      final type = data['type'];

      debugPrint('WebSocket message received: $type');

      switch (type) {
        case 'viewer_count':
          viewerCount.value = data['count'] ?? 0;
          break;

        case 'comment':
          final comment = LiveComment.fromJson(data['comment']);
          comments.add(comment);
          break;

        case 'reaction':
          final reaction = ReactionModel.fromJson(data['reaction']);
          reactions.add(reaction);
          // Remove reaction after animation (3 seconds)
          Future.delayed(const Duration(seconds: 3), () {
            reactions.remove(reaction);
          });
          break;

        case 'webrtc_signal':
          _handleWebRTCSignal(data);
          break;

        default:
          debugPrint('Unknown message type: $type');
      }
    } catch (e) {
      debugPrint('Error handling WebSocket message: $e');
    }
  }

  void _handleWebSocketError(error) {
    debugPrint('WebSocket error: $error');
    if (currentStream.value != null) {
      _scheduleReconnect(currentStream.value!.id);
    }
  }

  void _handleWebSocketClosed() {
    debugPrint('WebSocket connection closed');
    if (currentStream.value != null &&
        (isBroadcasting.value || isViewing.value)) {
      _scheduleReconnect(currentStream.value!.id);
    }
  }

  void _scheduleReconnect(int streamId) {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint('Max reconnect attempts reached');
      error.value = 'Connection lost. Please try again.';
      return;
    }

    _reconnectAttempts++;
    final delay = Duration(seconds: _reconnectAttempts * 2);
    debugPrint(
      'Reconnecting in ${delay.inSeconds} seconds (attempt $_reconnectAttempts)',
    );

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(delay, () {
      _connectWebSocket(streamId);
    });
  }

  void _sendWebSocketMessage(Map<String, dynamic> message) {
    try {
      _webSocketChannel?.sink.add(jsonEncode(message));
    } catch (e) {
      debugPrint('Error sending WebSocket message: $e');
    }
  }

  // ==================== WebRTC Management ====================

  Future<void> _setupBroadcasterPeerConnection() async {
    try {
      debugPrint('=== SETTING UP BROADCASTER PEER CONNECTION ===');

      _peerConnection = await webrtc.createPeerConnection(_iceServers);

      // Add local stream to peer connection
      _localStream?.getTracks().forEach((track) {
        _peerConnection?.addTrack(track, _localStream!);
      });

      // Handle ICE candidates
      _peerConnection?.onIceCandidate = (webrtc.RTCIceCandidate candidate) {
        debugPrint('ICE candidate generated');
        _sendWebSocketMessage({
          'type': 'ice_candidate',
          'candidate': {
            'candidate': candidate.candidate,
            'sdpMid': candidate.sdpMid,
            'sdpMLineIndex': candidate.sdpMLineIndex,
          },
        });
      };

      // Create and send offer
      final offer = await _peerConnection!.createOffer();
      await _peerConnection!.setLocalDescription(offer);

      _sendWebSocketMessage({'type': 'webrtc_offer', 'sdp': offer.sdp});

      debugPrint('WebRTC offer sent');
    } catch (e) {
      debugPrint('Error setting up broadcaster peer connection: $e');
    }
  }

  Future<void> _setupViewerPeerConnection() async {
    try {
      debugPrint('=== SETTING UP VIEWER PEER CONNECTION ===');

      _peerConnection = await webrtc.createPeerConnection(_iceServers);

      // Handle remote stream
      _peerConnection?.onTrack = (webrtc.RTCTrackEvent event) {
        debugPrint('Remote track received');
        if (event.streams.isNotEmpty) {
          remoteRenderer.value.srcObject = event.streams[0];
        }
      };

      // Handle ICE candidates
      _peerConnection?.onIceCandidate = (webrtc.RTCIceCandidate candidate) {
        debugPrint('ICE candidate generated');
        _sendWebSocketMessage({
          'type': 'ice_candidate',
          'candidate': {
            'candidate': candidate.candidate,
            'sdpMid': candidate.sdpMid,
            'sdpMLineIndex': candidate.sdpMLineIndex,
          },
        });
      };

      debugPrint('Viewer peer connection ready');
    } catch (e) {
      debugPrint('Error setting up viewer peer connection: $e');
    }
  }

  void _handleWebRTCSignal(Map<String, dynamic> data) async {
    try {
      final signalType = data['signal_type'];

      switch (signalType) {
        case 'offer':
          // Viewer receives offer from broadcaster
          final sdp = data['sdp'];
          await _peerConnection?.setRemoteDescription(
            webrtc.RTCSessionDescription(sdp, 'offer'),
          );

          // Create and send answer
          final answer = await _peerConnection?.createAnswer();
          await _peerConnection?.setLocalDescription(answer!);

          _sendWebSocketMessage({'type': 'webrtc_answer', 'sdp': answer?.sdp});
          debugPrint('WebRTC answer sent');
          break;

        case 'answer':
          // Broadcaster receives answer from viewer
          final sdp = data['sdp'];
          await _peerConnection?.setRemoteDescription(
            webrtc.RTCSessionDescription(sdp, 'answer'),
          );
          debugPrint('WebRTC answer received');
          break;

        case 'ice_candidate':
          // Handle ICE candidate
          final candidateData = data['candidate'];
          final candidate = webrtc.RTCIceCandidate(
            candidateData['candidate'],
            candidateData['sdpMid'],
            candidateData['sdpMLineIndex'],
          );
          await _peerConnection?.addCandidate(candidate);
          debugPrint('ICE candidate added');
          break;
      }
    } catch (e) {
      debugPrint('Error handling WebRTC signal: $e');
    }
  }

  // ==================== Comments & Reactions ====================

  Future<void> _loadComments(int streamId) async {
    try {
      final fetchedComments = await _liveService.getComments(streamId);
      comments.value = fetchedComments;
    } catch (e) {
      debugPrint('Error loading comments: $e');
    }
  }

  Future<void> postComment(String text) async {
    try {
      if (currentStream.value == null) return;

      await _liveService.postComment(currentStream.value!.id, text);

      // Send via WebSocket for real-time update
      _sendWebSocketMessage({'type': 'comment', 'text': text});

      debugPrint('Comment posted');
    } catch (e) {
      debugPrint('Error posting comment: $e');
    }
  }

  Future<void> sendReaction(String reactionType) async {
    try {
      if (currentStream.value == null) return;

      await _liveService.sendReaction(currentStream.value!.id, reactionType);

      // Send via WebSocket for real-time update
      _sendWebSocketMessage({
        'type': 'reaction',
        'reaction_type': reactionType,
      });

      debugPrint('Reaction sent: $reactionType');
    } catch (e) {
      debugPrint('Error sending reaction: $e');
    }
  }

  // ==================== Permissions ====================

  Future<bool> _requestPermissions() async {
    try {
      final cameraStatus = await Permission.camera.request();
      final microphoneStatus = await Permission.microphone.request();

      if (cameraStatus.isGranted && microphoneStatus.isGranted) {
        debugPrint('Camera and microphone permissions granted');
        return true;
      } else {
        debugPrint('Permissions denied');
        return false;
      }
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return false;
    }
  }

  // ==================== Cleanup ====================

  Future<void> _cleanup() async {
    debugPrint('=== CLEANING UP RESOURCES ===');

    // Close WebSocket
    _reconnectTimer?.cancel();
    _webSocketSubscription?.cancel();
    await _webSocketChannel?.sink.close();
    _webSocketChannel = null;

    // Close WebRTC connections
    await _peerConnection?.close();
    _peerConnection = null;

    for (final connection in _viewerConnections.values) {
      await connection.close();
    }
    _viewerConnections.clear();

    // Stop local stream
    _localStream?.getTracks().forEach((track) {
      track.stop();
    });
    await _localStream?.dispose();
    _localStream = null;

    // Clear renderers
    localRenderer.value.srcObject = null;
    remoteRenderer.value.srcObject = null;

    debugPrint('Cleanup complete');
  }
}
