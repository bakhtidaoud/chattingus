import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
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
import 'core/services/notification_service.dart'
    show NotificationService, firebaseMessagingBackgroundHandler;
import 'core/services/search_service.dart';
import 'core/services/permission_service.dart';

// Import controllers
import 'controllers/user_profile_controller.dart';
import 'controllers/feed_controller.dart';
import 'controllers/chat_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize services
  await Get.putAsync(() async => TokenStorageService());
  Get.put(ApiClient());
  Get.put(AuthService());
  Get.put(UserService());
  Get.put(PostService());
  Get.put(ChatService());

  // Initialize NotificationService
  final notificationService = Get.put(NotificationService());
  await notificationService.initialize();

  // Initialize SearchService
  Get.put(SearchService());

  // Initialize PermissionService
  Get.put(PermissionService());

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
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle initial link if app was opened from a deep link
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink.toString());
      }
    } catch (e) {
      debugPrint('Error getting initial link: $e');
    }

    // Handle links while app is running
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _handleDeepLink(uri.toString());
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
