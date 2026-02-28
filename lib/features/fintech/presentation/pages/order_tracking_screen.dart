import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../data/models/fintech_models.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OrderTrackingScreen extends StatelessWidget {
  final Order order;

  const OrderTrackingScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Order'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOrderInfo(),
            const SizedBox(height: 40),
            _buildTrackingTimeline(),
            const SizedBox(height: 40),
            if (order.trackingNumber != null) _buildTrackingDetails(),
            const SizedBox(height: 40),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              order.listingImage,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.listingTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Order ID: #${order.id}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total: \$${order.amount}',
                  style: const TextStyle(
                    color: AppTheme.electricViolet,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline() {
    final steps = ['Paid', 'Shipped', 'Out for Delivery', 'Delivered'];
    final currentStep = _getStatusIndex(order.status);

    return Column(
      children: List.generate(steps.length, (index) {
        final isCompleted = index <= currentStep;
        final isLast = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? AppTheme.primaryIndigo
                        : Colors.white10,
                    border: Border.all(
                      color: isCompleted ? Colors.white38 : Colors.white10,
                    ),
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 50,
                    color: index < currentStep
                        ? AppTheme.primaryIndigo
                        : Colors.white10,
                  ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    steps[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isCompleted ? Colors.white : Colors.white38,
                    ),
                  ),
                  if (isCompleted)
                    Text(
                      'Dec 24, 2023 - 10:30 AM',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        );
      }).animate(interval: 100.ms).fadeIn().slideX(begin: 0.1, end: 0),
    );
  }

  int _getStatusIndex(String status) {
    switch (status) {
      case 'PAID':
        return 0;
      case 'SHIPPED':
        return 1;
      case 'DELIVERED':
        return 3;
      default:
        return 0;
    }
  }

  Widget _buildTrackingDetails() {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tracking Number',
            style: TextStyle(color: Colors.white54, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.local_shipping_outlined,
                color: AppTheme.primaryIndigo,
              ),
              const SizedBox(width: 12),
              Text(
                order.trackingNumber!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.copy_rounded, size: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        if (order.status == 'DELIVERED')
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryIndigo,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Mark as Completed',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Open Dispute',
            style: TextStyle(color: Colors.redAccent),
          ),
        ),
      ],
    );
  }
}
