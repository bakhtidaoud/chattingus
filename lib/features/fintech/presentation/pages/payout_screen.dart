import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_text_field.dart';
import '../../../../core/widgets/premium_button.dart';
import '../providers/fintech_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PayoutScreen extends StatefulWidget {
  const PayoutScreen({super.key});

  @override
  State<PayoutScreen> createState() => _PayoutScreenState();
}

class _PayoutScreenState extends State<PayoutScreen> {
  final _amountController = TextEditingController();
  final _methodController = TextEditingController();
  String _selectedMethod = 'Bank Transfer';

  @override
  void dispose() {
    _amountController.dispose();
    _methodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Withdraw Funds'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter Withdrawal Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ).animate().fadeIn().slideY(begin: 0.1, end: 0),
            const SizedBox(height: 8),
            const Text(
              'Funds will be settled to your selected method within 3-5 business days.',
              style: TextStyle(color: Colors.white60),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 40),

            _buildBalanceSummary(),

            const SizedBox(height: 40),

            GlassTextField(
              controller: _amountController,
              hintText: 'Amount to Withdraw',
              prefixIcon: Icons.attach_money_rounded,
            ),
            const SizedBox(height: 20),

            _buildMethodPicker(),

            const SizedBox(height: 20),
            if (_selectedMethod == 'PayPal' || _selectedMethod == 'Crypto')
              GlassTextField(
                controller: _methodController,
                hintText: 'Enter Account/Address',
                prefixIcon: Icons.account_circle_outlined,
              ).animate().fadeIn(),

            const SizedBox(height: 40),

            const Text(
              'ID Verification Proof',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            _buildProofUploader(),

            const SizedBox(height: 60),

            PremiumButton(
              text: 'Request Payout',
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSummary() {
    return Consumer(
      builder: (context, ref, child) {
        final walletAsync = ref.watch(walletProvider);
        return walletAsync.when(
          data: (wallet) => Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryIndigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primaryIndigo.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Available Balance',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${wallet.currency} ${wallet.balance}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.greenAccent,
                  ),
                ),
              ],
            ),
          ),
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildMethodPicker() {
    final methods = ['Bank Transfer', 'PayPal', 'Crypto'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payout Method',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: methods.map((m) {
            final isSelected = _selectedMethod == m;
            return ChoiceChip(
              label: Text(m),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedMethod = m),
              backgroundColor: Colors.white10,
              selectedColor: AppTheme.primaryIndigo,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProofUploader() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white10),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.upload_file_rounded, color: Colors.white38),
            SizedBox(height: 8),
            Text(
              'Upload Proof of Identity',
              style: TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
