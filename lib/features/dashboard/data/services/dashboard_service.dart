import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';

class DashboardService {
  final Dio _dio = DioClient().dio;

  Future<Response> getDashboardStats() async {
    return await _dio.get('/dashboard/');
  }
}

class NotificationService {
  final Dio _dio = DioClient().dio;

  Future<Response> getNotifications() async {
    return await _dio.get('/notifications/');
  }

  Future<Response> markAllAsRead() async {
    return await _dio.post('/notifications/mark_all_as_read/');
  }

  Future<Response> markAsRead(String id) async {
    return await _dio.post('/notifications/$id/mark_as_read/');
  }
}
