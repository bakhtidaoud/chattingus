import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';

/// Service for managing app permissions with user-friendly dialogs
class PermissionService extends GetxService {
  /// Request camera permission with explanation dialog
  Future<bool> requestCameraPermission(BuildContext context) async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      return await _showSettingsDialog(
        context,
        'Camera Permission Required',
        'Camera access is needed to take photos and videos. Please enable it in Settings.',
      );
    }

    // Show explanation dialog before requesting
    final shouldRequest = await _showPermissionDialog(
      context,
      'Camera Access',
      'ChattingUs needs camera access to let you take photos and videos for your posts and stories.',
      Icons.camera_alt,
    );

    if (!shouldRequest) return false;

    final result = await Permission.camera.request();

    if (result.isPermanentlyDenied) {
      return await _showSettingsDialog(
        context,
        'Camera Permission Denied',
        'You have permanently denied camera access. Please enable it in Settings to use this feature.',
      );
    }

    return result.isGranted;
  }

  /// Request storage/photos permission with explanation dialog
  Future<bool> requestStoragePermission(BuildContext context) async {
    Permission permission;

    // Use appropriate permission based on Android version
    if (await _isAndroid13OrHigher()) {
      permission = Permission.photos;
    } else {
      permission = Permission.storage;
    }

    final status = await permission.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      return await _showSettingsDialog(
        context,
        'Storage Permission Required',
        'Photo library access is needed to select images and videos. Please enable it in Settings.',
      );
    }

    // Show explanation dialog before requesting
    final shouldRequest = await _showPermissionDialog(
      context,
      'Photo Library Access',
      'ChattingUs needs access to your photo library to let you select photos and videos for your posts and stories.',
      Icons.photo_library,
    );

    if (!shouldRequest) return false;

    final result = await permission.request();

    if (result.isPermanentlyDenied) {
      return await _showSettingsDialog(
        context,
        'Storage Permission Denied',
        'You have permanently denied photo library access. Please enable it in Settings to use this feature.',
      );
    }

    return result.isGranted;
  }

  /// Request notification permission with explanation dialog
  Future<bool> requestNotificationPermission(BuildContext context) async {
    final status = await Permission.notification.status;

    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      return await _showSettingsDialog(
        context,
        'Notification Permission Required',
        'Notification access is needed to keep you updated. Please enable it in Settings.',
      );
    }

    // Show explanation dialog before requesting
    final shouldRequest = await _showPermissionDialog(
      context,
      'Enable Notifications',
      'Stay updated with messages, likes, comments, and other activities from your friends.',
      Icons.notifications_active,
    );

    if (!shouldRequest) return false;

    final result = await Permission.notification.request();

    if (result.isPermanentlyDenied) {
      return await _showSettingsDialog(
        context,
        'Notification Permission Denied',
        'You have permanently denied notification access. Please enable it in Settings to receive updates.',
      );
    }

    return result.isGranted;
  }

  /// Check if a specific permission is granted
  Future<bool> isPermissionGranted(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  /// Check if Android 13 or higher
  Future<bool> _isAndroid13OrHigher() async {
    try {
      return await Permission.photos.status != PermissionStatus.denied;
    } catch (e) {
      return false;
    }
  }

  /// Show permission explanation dialog
  Future<bool> _showPermissionDialog(
    BuildContext context,
    String title,
    String message,
    IconData icon,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Not Now', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Show settings redirect dialog for permanently denied permissions
  Future<bool> _showSettingsDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.settings, color: Colors.orange, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Text(message, style: const TextStyle(fontSize: 15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
              await openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}
