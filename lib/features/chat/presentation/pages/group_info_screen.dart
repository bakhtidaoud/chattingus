import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/premium_button.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GroupInfoScreen extends StatelessWidget {
  final String conversationId;

  const GroupInfoScreen({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://picsum.photos/800/600?random=group',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.midnight.withOpacity(0.9),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              title: const Text(
                'Premium Group Chat',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Participants (12)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildAddParticipantTile(),
                  const SizedBox(height: 8),
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 5,
                    itemBuilder: (context, index) =>
                        _buildParticipantTile(index),
                  ),
                  const SizedBox(height: 48),
                  PremiumButton(text: 'Exit Group', onPressed: () {}),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Report Group',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms),
          ),
        ],
      ),
    );
  }

  Widget _buildAddParticipantTile() {
    return GlassCard(
      padding: const EdgeInsets.all(4),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppTheme.primaryIndigo,
          child: Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
        ),
        title: const Text(
          'Add Participant',
          style: TextStyle(
            color: AppTheme.primaryIndigo,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildParticipantTile(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GlassCard(
        padding: const EdgeInsets.all(4),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?u=part$index',
            ),
          ),
          title: Text('Participant $index'),
          subtitle: Text(index == 0 ? 'Group Admin' : 'Member'),
          trailing: index == 0
              ? null
              : const Icon(Icons.more_horiz, color: Colors.white24),
        ),
      ),
    );
  }
}
