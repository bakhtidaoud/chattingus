import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import '../../screens/no_connection_screen.dart';
import '../../screens/splash_screen.dart';

class NetworkConnectivityService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final RxBool isOnline = true.obs;
  final Rx<ConnectivityResult> connectionType = ConnectivityResult.wifi.obs;

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _listenToConnectivityChanges();
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    super.onClose();
  }

  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      _updateConnectionStatus([result]);
    } catch (e) {
      debugPrint('Error checking connectivity: $e');
      isOnline.value = true; // Assume online if check fails
    }
  }

  void _listenToConnectivityChanges() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) => _updateConnectionStatus([result]),
      onError: (error) {
        debugPrint('Connectivity stream error: $error');
      },
    );
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      isOnline.value = false;
      connectionType.value = ConnectivityResult.none;
      _showOfflineBanner();
      debugPrint('📡 Network: OFFLINE');
      return;
    }

    final result = results.first;
    final wasOffline = !isOnline.value;

    isOnline.value = result != ConnectivityResult.none;
    connectionType.value = result;

    if (isOnline.value && wasOffline) {
      _hideOfflineBanner();
      debugPrint('📡 Network: ONLINE (${result.name})');
      Get.snackbar(
        'Back Online',
        'Connection restored',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.wifi, color: Colors.white),
      );
    } else if (!isOnline.value) {
      _showOfflineBanner();
      debugPrint('📡 Network: OFFLINE');
    } else {
      debugPrint('📡 Network: ${result.name}');
    }
  }

  void _showOfflineBanner() {
    // Navigate to full-screen no connection screen
    if (Get.currentRoute != '/no-connection') {
      Get.offAll(
        () => const NoConnectionScreen(),
        transition: Transition.fadeIn,
      );
    }
  }

  void _hideOfflineBanner() {
    // Return to splash screen to re-initialize app
    if (Get.currentRoute == '/no-connection') {
      Get.offAll(() => const SplashScreen(), transition: Transition.fadeIn);
    } else {
      Get.closeAllSnackbars();
    }
  }

  bool get hasConnection => isOnline.value;

  String get connectionTypeName {
    switch (connectionType.value) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.none:
        return 'No Connection';
      default:
        return 'Unknown';
    }
  }
}
