import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/dio_client.dart';

final searchServiceProvider = Provider((ref) => SearchService());

class SearchService {
  final Dio _dio = DioClient().dio;

  Future<Response> searchUsers(String query) async {
    return await _dio.get('/users/suggested/', queryParameters: {'q': query});
  }
}

final userSearchProvider = FutureProvider.family<List<dynamic>, String>((
  ref,
  query,
) async {
  if (query.isEmpty) return [];
  final service = ref.watch(searchServiceProvider);
  final response = await service.searchUsers(query);
  return response.data as List;
});

final searchTabProvider = StateProvider<int>((ref) => 0);
