import 'package:flutter/material.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/premium_button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DisputeCenter extends StatelessWidget {
  const DisputeCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispute Resolution'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Open a New Dispute',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ).animate().fadeIn().slideX(begin: -0.1, end: 0),
            const SizedBox(height: 8),
            const Text(
              'Resolution center handles payment failures or item discrepancies.',
              style: TextStyle(color: Colors.white60),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 32),

            Expanded(
              child: ListView(
                children: [
                  _buildDisputeForm(),
                  const SizedBox(height: 40),
                  const Text(
                    'Active Cases',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  _buildMockCaseItem(
                    'ORDER-001',
                    'Item not received',
                    'PENDING',
                  ),
                  _buildMockCaseItem(
                    'ORDER-042',
                    'Damaged product',
                    'RESOLVED',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisputeForm() {
    return Column(
      children: [
        const GlassTextField(
          hintText: 'Order ID',
          prefixIcon: Icons.receipt_long_outlined,
        ),
        const SizedBox(height: 16),
        const GlassTextField(
          hintText: 'Reason for Dispute',
          prefixIcon: Icons.help_outline,
        ),
        const SizedBox(height: 16),
        const GlassTextField(
          hintText: 'Detailed Description',
          prefixIcon: Icons.description_outlined,
        ),
        const SizedBox(height: 24),
        PremiumButton(text: 'Open Dispute Case', onPressed: () {}),
      ],
    );
  }

  Widget _buildMockCaseItem(String orderId, String reason, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (status == 'RESOLVED' ? Colors.green : Colors.amber)
                    .withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                status == 'RESOLVED'
                    ? Icons.task_alt_rounded
                    : Icons.history_rounded,
                color: status == 'RESOLVED' ? Colors.green : Colors.amber,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Case #$orderId',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    reason,
                    style: const TextStyle(fontSize: 12, color: Colors.white60),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
