import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/fintech_models.dart';
import '../../data/services/fintech_service.dart';

final fintechServiceProvider = Provider((ref) => FintechService());

final walletProvider = FutureProvider<Wallet>((ref) async {
  final service = ref.watch(fintechServiceProvider);
  final response = await service.getWallet();
  return Wallet.fromJson(
    response.data is List ? response.data[0] : response.data,
  );
});

final ordersProvider = FutureProvider<List<Order>>((ref) async {
  final service = ref.watch(fintechServiceProvider);
  final response = await service.getOrders();
  return (response.data['results'] as List)
      .map((o) => Order.fromJson(o))
      .toList();
});

final referralsProvider = FutureProvider<ReferralStat>((ref) async {
  final service = ref.watch(fintechServiceProvider);
  final response = await service.getReferrals();
  return ReferralStat.fromJson(response.data);
});
