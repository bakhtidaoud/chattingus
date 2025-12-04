import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:uni_links/uni_links.dart';
import 'l10n/app_localizations.dart';
import 'controllers/settings_controller.dart';
import 'screens/splash_screen.dart';
import 'screens/change_password_screen.dart';

// Import services
import 'core/services/token_storage_service.dart';
import 'core/network/api_client.dart';
import 'core/services/auth_service.dart';
import 'core/services/user_service.dart';
import 'core/services/post_service.dart';
import 'core/services/chat_service.dart';

// Import controllers
import 'controllers/user_profile_controller.dart';
import 'controllers/feed_controller.dart';
import 'controllers/chat_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize services
  await Get.putAsync(() async => TokenStorageService());
  Get.put(ApiClient());
  Get.put(AuthService());
  Get.put(UserService());
  Get.put(PostService());
  Get.put(ChatService());

  // Initialize controllers
  Get.put(SettingsController());
  Get.put(UserProfileController());
  Get.put(FeedController());
  Get.put(ChatController());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    // Handle initial link if app was opened from a deep link
    try {
      final initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }
    } catch (e) {
      debugPrint('Error getting initial link: $e');
    }

    // Handle links while app is running
    _sub = linkStream.listen(
      (String? link) {
        if (link != null) {
          _handleDeepLink(link);
        }
      },
      onError: (err) {
        debugPrint('Error listening to link stream: $err');
      },
    );
  }

  void _handleDeepLink(String link) {
    final uri = Uri.parse(link);

    // Check if URL starts with www.chatting-us.com/editpassword
    final isValidHost =
        uri.host == 'www.chatting-us.com' || uri.host == 'chatting-us.com';
    final isPasswordReset = uri.path.startsWith('/editpassword');

    if (isValidHost && isPasswordReset) {
      // Extract token from path (e.g., /editpassword/abc123)
      final pathSegments = uri.pathSegments;
      String? token;

      if (pathSegments.length > 1) {
        token = pathSegments[1];
      }

      // Navigate to Change Password screen
      Future.delayed(const Duration(milliseconds: 500), () {
        Get.to(() => const ChangePasswordScreen());

        // You can pass the token to the screen if needed
        if (token != null) {
          debugPrint('Password reset token: $token');
          // You can use this token to verify the reset request
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the controller (already initialized in main)
    final SettingsController settingsController =
        Get.find<SettingsController>();

    return Obx(
      () => GetMaterialApp(
        title: 'Chatting Us',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: settingsController.themeMode.value,
        locale: settingsController.locale.value,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('ar'), // Arabic
          Locale('fr'), // French
        ],
        home: const SplashScreen(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settingsController = Get.find();
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.appTitle),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                settingsController.themeMode.value == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () {
                settingsController.updateThemeMode(
                  settingsController.themeMode.value == ThemeMode.dark
                      ? ThemeMode.light
                      : ThemeMode.dark,
                );
              },
            ),
          ),
          PopupMenuButton<Locale>(
            icon: const Icon(Icons.language),
            onSelected: (Locale locale) {
              settingsController.updateLocale(locale);
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
              const PopupMenuItem<Locale>(
                value: Locale('en'),
                child: Text('English'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('ar'),
                child: Text('العربية'),
              ),
              const PopupMenuItem<Locale>(
                value: Locale('fr'),
                child: Text('Français'),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              l10n.settings,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Obx(
              () => Text(
                '${l10n.language}: ${settingsController.locale.value.languageCode}',
              ),
            ),
            Obx(
              () => Text(
                '${l10n.theme}: ${settingsController.themeMode.value.toString().split('.').last}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
