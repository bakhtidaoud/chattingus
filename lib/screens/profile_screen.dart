import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../l10n/app_localizations.dart';
import '../controllers/user_profile_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final UserProfileController controller = Get.find<UserProfileController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.profile,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Avatar and Stats Row
                Row(
                  children: [
                    // Profile Avatar
                    Obx(
                      () => Stack(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                controller.currentUser.value?.profilePicture !=
                                    null
                                ? NetworkImage(
                                    controller
                                        .currentUser
                                        .value!
                                        .profilePicture!,
                                  )
                                : null,
                            backgroundColor: Colors.grey.shade300,
                            child:
                                controller.currentUser.value?.profilePicture ==
                                    null
                                ? const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: theme.scaffoldBackgroundColor,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Stats
                    Expanded(
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _StatColumn(
                              label: l10n.posts,
                              count:
                                  '${controller.currentUser.value?.postsCount ?? 0}',
                            ),
                            _StatColumn(
                              label: l10n.followers,
                              count:
                                  '${controller.currentUser.value?.followersCount ?? 0}',
                            ),
                            _StatColumn(
                              label: l10n.following,
                              count:
                                  '${controller.currentUser.value?.followingCount ?? 0}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Name and Bio
                Align(
                  alignment: Alignment.centerLeft,
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '@${controller.currentUser.value?.username ?? ''}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        if (controller.currentUser.value?.bio != null &&
                            controller.currentUser.value!.bio!.isNotEmpty)
                          const SizedBox(height: 8),
                        if (controller.currentUser.value?.bio != null &&
                            controller.currentUser.value!.bio!.isNotEmpty)
                          Text(
                            controller.currentUser.value!.bio!,
                            style: const TextStyle(fontSize: 14),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isDark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                    child: Text(
                      l10n.editProfile,
                      style: TextStyle(
                        color: theme.textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
                  width: 0.5,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: theme.textTheme.bodyLarge?.color,
              labelColor: theme.textTheme.bodyLarge?.color,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(icon: const Icon(Icons.grid_on_outlined), text: l10n.posts),
                Tab(
                  icon: const Icon(Icons.video_library_outlined),
                  text: l10n.reels,
                ),
                Tab(
                  icon: const Icon(Icons.play_circle_outline),
                  text: l10n.stories,
                ),
                Tab(
                  icon: const Icon(Icons.person_pin_outlined),
                  text: l10n.tagged,
                ),
              ],
            ),
          ),
          // Tab Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Posts Grid
                _PostsGrid(),
                // Reels Grid
                _EmptyTabView(
                  icon: Icons.video_library_outlined,
                  message: 'No reels yet',
                ),
                // Stories
                _EmptyTabView(
                  icon: Icons.play_circle_outline,
                  message: 'No stories yet',
                ),
                // Tagged
                _EmptyTabView(
                  icon: Icons.person_pin_outlined,
                  message: 'No tagged posts yet',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String count;

  const _StatColumn({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

class _PostsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sample post data
    final posts = List.generate(9, (index) => index);

    return GridView.builder(
      padding: const EdgeInsets.all(1),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
      ),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Placeholder for post image
              Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 40,
                  color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
                ),
              ),
              // Multiple images indicator (for some posts)
              if (index % 3 == 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.collections,
                    color: Colors.white,
                    size: 20,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyTabView extends StatelessWidget {
  final IconData icon;
  final String message;

  const _EmptyTabView({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
