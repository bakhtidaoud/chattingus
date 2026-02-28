import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';

class FintechService {
  final Dio _dio = DioClient().dio;

  Future<Response> getWallet() async {
    return await _dio.get('/wallets/');
  }

  Future<Response> getOrders() async {
    return await _dio.get('/orders/');
  }

  Future<Response> createDispute(
    String orderId,
    String reason,
    String description,
  ) async {
    return await _dio.post(
      '/disputes/',
      data: {'order_id': orderId, 'reason': reason, 'description': description},
    );
  }

  Future<Response> createReview({
    required String orderId,
    required int rating,
    required String shippingSpeed,
    String? comment,
  }) async {
    return await _dio.post(
      '/reviews/',
      data: {
        'order_id': orderId,
        'stars': rating,
        'shipping_speed': shippingSpeed,
        'comment': comment,
      },
    );
  }

  Future<Response> requestPayout(double amount, String paymentMethod) async {
    return await _dio.post(
      '/payouts/',
      data: {'amount': amount, 'method': paymentMethod},
    );
  }

  Future<Response> getReferrals() async {
    return await _dio.get('/referrals/');
  }
}
