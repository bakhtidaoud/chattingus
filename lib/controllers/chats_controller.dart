import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/chats_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/reels_screen.dart';
import '../screens/profile_screen.dart';

class NavigationController extends GetxController {
  var selectedIndex = 0.obs;

  final screens = [
    const ChatsScreen(showBottomNav: false),
    const ExploreScreen(),
    const ReelsScreen(),
    const ChatsScreen(showBottomNav: false), // Messages (reusing ChatsScreen)
    const ProfileScreen(),
  ];

  void changeTabIndex(int index) {
    selectedIndex.value = index;
  }
}
