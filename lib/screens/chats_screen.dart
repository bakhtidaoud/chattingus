import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../controllers/chats_controller.dart';
import '../controllers/settings_controller.dart';
import 'chat_detail_screen.dart';

class ChatsScreen extends StatelessWidget {
  final bool showBottomNav;
  const ChatsScreen({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      l10n.edit,
                      style: const TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                  Row(
                    children: [
                      // Language Switcher
                      IconButton(
                        icon: const Icon(Icons.language),
                        onPressed: () => _showLanguageSelector(context),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_square),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  l10n.chats,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: l10n.search,
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: theme.brightness == Brightness.dark ? Colors.grey.shade900 : Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _StoryItem(name: l10n.yourStory, isUser: true),
                  const _StoryItem(name: 'Sarah', imageUrl: 'https://i.pravatar.cc/150?u=1'),
                  const _StoryItem(name: 'Mike', imageUrl: 'https://i.pravatar.cc/150?u=2'),
                  const _StoryItem(name: 'Emily', imageUrl: 'https://i.pravatar.cc/150?u=3'),
                  const _StoryItem(name: 'Anna', imageUrl: 'https://i.pravatar.cc/150?u=4'),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: [
                  _ChatItem(
                    name: 'Alex Johnson',
                    message: 'Hey, are we still on for lunch?',
                    time: '2m',
                    isUnread: true,
                    imageUrl: 'https://i.pravatar.cc/150?u=5',
                  ),
                  _ChatItem(
                    name: 'Design Team',
                    message: "Sarah: Shared a file 'Project_Brief.pdf'",
                    time: '10:30 AM',
                    isUnread: true,
                    isGroup: true,
                  ),
                  _ChatItem(
                    name: 'Chris Lee',
                    message: 'Sounds good! See you then.',
                    time: 'Yesterday',
                    imageUrl: 'https://i.pravatar.cc/150?u=6',
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: const Icon(Icons.video_collection, color: Colors.white),
                    ),
                    title: const Text('Reels Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('New popular reel from @creator1'),
                    trailing: const Text('Tuesday', style: TextStyle(color: Colors.grey)),
                  ),
                  _ChatItem(
                    name: 'Emma Watson',
                    message: 'typing...',
                    time: 'Mon',
                    imageUrl: 'https://i.pravatar.cc/150?u=7',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageSelector(BuildContext context) {
    final settingsController = Get.find<SettingsController>();
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                l10n.language,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            Obx(() => Column(
              children: [
                _LanguageOption(
                  flag: '🇬🇧',
                  language: 'English',
                  isSelected: settingsController.locale.value.languageCode == 'en',
                  onTap: () {
                    settingsController.updateLocale(const Locale('en'));
                    Navigator.pop(context);
                  },
                ),
                _LanguageOption(
                  flag: '🇸🇦',
                  language: 'العربية',
                  isSelected: settingsController.locale.value.languageCode == 'ar',
                  onTap: () {
                    settingsController.updateLocale(const Locale('ar'));
                    Navigator.pop(context);
                  },
                ),
                _LanguageOption(
                  flag: '🇫🇷',
                  language: 'Français',
                  isSelected: settingsController.locale.value.languageCode == 'fr',
                  onTap: () {
                    settingsController.updateLocale(const Locale('fr'));
                    Navigator.pop(context);
                  },
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  final String flag;
  final String language;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageOption({
    required this.flag,
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(
        flag,
        style: const TextStyle(fontSize: 32),
      ),
      title: Text(
        language,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.blue)
          : null,
      onTap: onTap,
    );
  }
}

class _StoryItem extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final bool isUser;

  const _StoryItem({required this.name, this.imageUrl, this.isUser = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isUser ? null : Border.all(color: Colors.blue, width: 2),
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
                  backgroundColor: Colors.grey.shade300,
                  child: imageUrl == null && isUser
                      ? const Icon(Icons.person, size: 30, color: Colors.white)
                      : null,
                ),
              ),
              if (isUser)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, size: 16, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _ChatItem extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final bool isUnread;
  final String? imageUrl;
  final bool isGroup;

  const _ChatItem({
    required this.name,
    required this.message,
    required this.time,
    this.isUnread = false,
    this.imageUrl,
    this.isGroup = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Get.to(() => ChatDetailScreen(name: name, imageUrl: imageUrl)),
      leading: CircleAvatar(
        radius: 28,
        backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
        backgroundColor: Colors.grey.shade300,
        child: isGroup ? const Icon(Icons.group, color: Colors.white) : null,
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: isUnread ? Theme.of(context).textTheme.bodyMedium?.color : Colors.grey,
          fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(time, style: TextStyle(color: isUnread ? Colors.blue : Colors.grey, fontSize: 12)),
          if (isUnread)
            Container(
              margin: const EdgeInsets.only(top: 4),
              width: 10,
              height: 10,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
