import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/auth_models.dart';
import '../data/services/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final currentUserProvider = FutureProvider<UserProfile>((ref) async {
  final service = ref.watch(authServiceProvider);
  final response = await service.getCurrentUser();
  return UserProfile.fromJson(response.data);
});

final authStateProvider = StateProvider<bool>((ref) => false);
