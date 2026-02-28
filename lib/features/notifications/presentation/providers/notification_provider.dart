import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/notification_model.dart';
import '../data/services/notification_service.dart';

final notificationServiceProvider = Provider((ref) => NotificationService());

final notificationsProvider = FutureProvider<List<AppNotification>>((
  ref,
) async {
  final service = ref.watch(notificationServiceProvider);
  final response = await service.getNotifications();
  return (response.data['results'] as List)
      .map((n) => AppNotification.fromJson(n))
      .toList();
});

class NotificationNotifier extends StateNotifier<AsyncValue<void>> {
  final NotificationService _service;
  final Ref _ref;

  NotificationNotifier(this._service, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> markAllAsRead() async {
    state = const AsyncValue.loading();
    try {
      await _service.markAllAsRead();
      _ref.invalidate(notificationsProvider);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final notificationActionProvider =
    StateNotifierProvider<NotificationNotifier, AsyncValue<void>>((ref) {
      return NotificationNotifier(ref.watch(notificationServiceProvider), ref);
    });
