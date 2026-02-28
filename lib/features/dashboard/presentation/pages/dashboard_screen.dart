import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../providers/dashboard_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Overview'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: statsAsync.when(
        data: (stats) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildStatsGrid(stats),
              const SizedBox(height: 32),
              const Text(
                'Engagement Growth',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildGrowthChart(),
              const SizedBox(height: 32),
              _buildQuickActions(context),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildStatsGrid(dynamic stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Total Posts',
          stats.totalPosts.toString(),
          Icons.grid_view,
        ),
        _buildStatCard(
          'Followers',
          stats.totalFollowers.toString(),
          Icons.people_outline,
        ),
        _buildStatCard(
          'Balance',
          '\$${stats.walletBalance}',
          Icons.account_balance_wallet_outlined,
        ),
        _buildStatCard(
          'Active Ads',
          stats.activeListings.toString(),
          Icons.local_offer_outlined,
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return RepaintBoundary(
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppTheme.primaryIndigo, size: 20),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.white38),
            ),
          ],
        ),
      ).animate().fadeIn().scale(),
    );
  }

  Widget _buildGrowthChart() {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 1),
                FlSpot(2, 4),
                FlSpot(4, 3),
                FlSpot(6, 6),
                FlSpot(8, 5),
                FlSpot(10, 8),
              ],
              isCurved: true,
              color: AppTheme.electricViolet,
              barWidth: 3,
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.electricViolet.withOpacity(0.1),
              ),
              dotData: const FlDotData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        _buildActionTile(context, 'Edit Profile', Icons.edit_note, () {}),
        _buildActionTile(
          context,
          'Privacy Settings',
          Icons.lock_outline,
          () {},
        ),
        _buildActionTile(context, 'Help & Support', Icons.help_outline, () {}),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: ListTile(
          leading: Icon(icon, color: Colors.white70),
          title: Text(title, style: const TextStyle(fontSize: 14)),
          trailing: const Icon(Icons.chevron_right, color: Colors.white24),
          onTap: onTap,
        ),
      ),
    );
  }
}
