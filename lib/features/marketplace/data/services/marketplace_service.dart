import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';

class MarketplaceService {
  final Dio _dio = DioClient().dio;

  Future<Response> getCategories() async {
    return await _dio.get('/categories/');
  }

  Future<Response> getListings({
    String? categoryId,
    Map<String, dynamic>? attributes,
    String? search,
  }) async {
    Map<String, dynamic> params = {};
    if (categoryId != null) params['category_id'] = categoryId;
    if (search != null) params['search'] = search;
    if (attributes != null) {
      attributes.forEach((key, value) {
        params['attr_$key'] = value;
      });
    }
    return await _dio.get('/listings/', queryParameters: params);
  }

  Future<Response> createListing(Map<String, dynamic> data) async {
    // Note: data should include images as MultipartFile if needed
    return await _dio.post('/listings/', data: data);
  }

  Future<Response> createOffer(String listingId, double amount) async {
    return await _dio.post(
      '/offers/',
      data: {'listing_id': listingId, 'amount': amount},
    );
  }

  Future<Response> contactSeller(String listingId) async {
    return await _dio.post('/listings/$listingId/contact_seller/');
  }

  Future<Response> requestPromotion(
    String listingId,
    String promotionType,
  ) async {
    return await _dio.post(
      '/promotions/',
      data: {
        'listing_id': listingId,
        'type': promotionType, // 'FEATURED' or 'URGENT'
      },
    );
  }
}
