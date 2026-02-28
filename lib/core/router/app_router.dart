import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/auth/presentation/pages/otp_screen.dart';
import '../../features/auth/presentation/pages/password_reset_screen.dart';
import '../../features/auth/presentation/pages/splash_screen.dart';
import '../../features/social/presentation/pages/home_feed_screen.dart';
import '../../features/social/presentation/pages/create_post_screen.dart';
import '../../features/social/presentation/pages/hashtag_explore_screen.dart';
import '../../features/stories/presentation/pages/story_player_screen.dart';
import '../../features/stories/presentation/pages/create_story_screen.dart';
import '../../features/stories/presentation/pages/highlight_manager_screen.dart';
import '../../features/stories/data/models/story.dart';
import '../../features/chat/presentation/pages/inbox_screen.dart';
import '../../features/chat/presentation/pages/chat_room_screen.dart';
import '../../features/chat/presentation/pages/group_info_screen.dart';
import '../../features/marketplace/presentation/pages/marketplace_home_screen.dart';
import '../../features/marketplace/presentation/pages/listing_detail_screen.dart';
import '../../features/marketplace/presentation/pages/listing_creator_screen.dart';
import '../../features/marketplace/data/models/marketplace_models.dart';
import '../../features/fintech/presentation/pages/wallet_dashboard.dart';
import '../../features/fintech/presentation/pages/order_tracking_screen.dart';
import '../../features/fintech/presentation/pages/payout_screen.dart';
import '../../features/fintech/presentation/pages/dispute_center.dart';
import '../../features/fintech/data/models/fintech_models.dart' as fintech;
import '../../features/notifications/presentation/pages/notification_hub_screen.dart';
import '../../features/search/presentation/pages/search_screen.dart';
import '../../features/dashboard/presentation/pages/dashboard_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(path: '/otp', builder: (context, state) => const OTPScreen()),
    GoRoute(
      path: '/password-reset',
      builder: (context, state) => const PasswordResetScreen(),
    ),
    GoRoute(path: '/', builder: (context, state) => const HomePage()),

    // Social & Feed
    GoRoute(path: '/feed', builder: (context, state) => const HomeFeedScreen()),
    GoRoute(
      path: '/create-post',
      builder: (context, state) => const CreatePostScreen(),
    ),
    GoRoute(
      path: '/explore',
      builder: (context, state) => const HashtagExploreScreen(),
    ),

    // Stories
    GoRoute(
      path: '/story-player',
      builder: (context, state) =>
          StoryPlayer(userStories: state.extra as UserStories),
    ),
    GoRoute(
      path: '/create-story',
      builder: (context, state) => const CreateStoryScreen(),
    ),
    GoRoute(
      path: '/highlights',
      builder: (context, state) => const HighlightManager(),
    ),

    // Chat
    GoRoute(path: '/inbox', builder: (context, state) => const InboxScreen()),
    GoRoute(
      path: '/chat/:chatId',
      builder: (context, state) =>
          ChatRoomScreen(conversationId: state.pathParameters['chatId']!),
    ),
    GoRoute(
      path: '/group-info/:chatId',
      builder: (context, state) =>
          GroupInfoScreen(conversationId: state.pathParameters['chatId']!),
    ),

    // Marketplace
    GoRoute(
      path: '/marketplace',
      builder: (context, state) => const MarketplaceHomeScreen(),
    ),
    GoRoute(
      path: '/marketplace/create',
      builder: (context, state) => const ListingCreatorScreen(),
    ),
    GoRoute(
      path: '/marketplace/listing/:id',
      builder: (context, state) =>
          ListingDetailScreen(listing: state.extra as Listing),
    ),

    // Fintech
    GoRoute(
      path: '/wallet',
      builder: (context, state) => const WalletDashboard(),
    ),
    GoRoute(path: '/payout', builder: (context, state) => const PayoutScreen()),
    GoRoute(
      path: '/dispute',
      builder: (context, state) => const DisputeCenter(),
    ),
    GoRoute(
      path: '/order-tracking',
      builder: (context, state) =>
          OrderTrackingScreen(order: state.extra as fintech.Order),
    ),

    // Main Features (New)
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationHubScreen(),
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) => const GlobalSearchScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
  ],
);
