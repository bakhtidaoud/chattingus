import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/dashboard_models.dart';
import '../../data/services/dashboard_service.dart';

final dashboardServiceProvider = Provider((ref) => DashboardService());

final dashboardStatsProvider = FutureProvider<DashboardStats>((ref) async {
  final service = ref.watch(dashboardServiceProvider);
  final response = await service.getDashboardStats();
  return DashboardStats.fromJson(response.data);
});
