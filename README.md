<div align="center">

# 💬 Chatting Us

### A Modern Instagram-Style Social Media App Built with Flutter

[![Flutter](https://img.shields.io/badge/Flutter-3.8+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)

**Connect with the world through beautiful, intuitive social interactions**

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Usage](#-usage) • [Localization](#-localization)

</div>

---

## ✨ Features

### 🎨 **Beautiful UI/UX**
- **Instagram-Style Design** - Modern, clean interface inspired by Instagram
- **Animated Splash Screen** - Stunning gradient background with smooth animations
- **Dark & Light Themes** - Seamless theme switching with floating action button
- **Responsive Layout** - Adapts perfectly to different screen sizes

### 🌐 **Multi-Language Support**
- **3 Languages** - English, Arabic (RTL), and French
- **Easy Language Switching** - Bottom sheet selector with flag emojis
- **Persistent Selection** - Your language choice is saved
- **Full Localization** - All UI elements properly translated

### 🔥 **Firebase Integration**
- **Firebase Cloud Messaging (FCM)** - Real-time push notifications
- **Background Message Handling** - Receive notifications even when app is closed
- **Notification Service** - Comprehensive notification management system
- **Token Management** - Automatic FCM token refresh and synchronization

### 🔐 **Authentication & Security**
- **JWT Authentication** - Secure token-based authentication
- **Secure Storage** - Encrypted token storage using flutter_secure_storage
- **Deep Linking** - Password reset via email links (chatting-us.com/editpassword)
- **Auto-login** - Persistent authentication state

### 🌐 **Backend Integration**
- **Django REST API** - Full integration with Django backend
- **RESTful Services** - Auth, User, Post, Chat, Search services
- **Real-time Updates** - Live data synchronization
- **Error Handling** - Comprehensive error management and user feedback

### 📱 **Core Screens**

#### 🏠 **Home/Feed**
- Instagram-style post feed
- Create, like, and comment on posts
- Image upload with camera/gallery
- Pull-to-refresh functionality
- Infinite scroll pagination

#### 💬 **Chats**
- Real-time messaging
- Chat list with unread indicators
- Story carousel at the top
- Search functionality
- Group and direct messages

#### 🎬 **Reels**
- Full-screen vertical video feed
- Interaction buttons (like, comment, share)
- User info and follow button
- Swipe to navigate

#### 👤 **Profile**
- Profile header with avatar and stats
- Posts, Followers, Following counts
- Bio and username display
- Tab navigation (Posts, Reels, Stories, Tagged)
- 3-column grid layout for posts
- Edit Profile functionality

#### 🔍 **Explore**
- Discover new users and content
- Search functionality
- Trending posts and reels

### 🎭 **Animations & Interactions**
- **Splash Screen** - Fade-in and elastic scale animations
- **Theme Switcher** - Rotating icon with fade transition
- **Page Transitions** - Smooth fade transitions between screens
- **Bottom Sheets** - Elegant slide-up animations

### 🛠️ **Technical Features**
- **GetX State Management** - Reactive and efficient state management
- **Clean Architecture** - Organized service-based architecture
- **Persistent Storage** - SharedPreferences for settings, Secure Storage for tokens
- **Material 3 Design** - Latest Flutter design system
- **Permission Handling** - Camera, storage, and notification permissions
- **Image Picker** - Camera and gallery integration
- **Dio HTTP Client** - Advanced networking with interceptors

---

## 📸 Screenshots

> **Note**: Add your app screenshots here

### Light Theme
| Splash Screen | Chats | Profile |
|:---:|:---:|:---:|
| ![Splash](screenshots/splash_light.png) | ![Chats](screenshots/chats_light.png) | ![Profile](screenshots/profile_light.png) |

### Dark Theme
| Reels | Language Selector | Theme Switcher |
|:---:|:---:|:---:|
| ![Reels](screenshots/reels_dark.png) | ![Language](screenshots/language_dark.png) | ![Theme](screenshots/theme_dark.png) |

---

## 🚀 Installation

### Prerequisites
- Flutter SDK (3.8 or higher)
- Dart SDK (3.8.1 or higher)
- Android Studio / VS Code
- Git
- Firebase account and project setup
- Django backend server (for full functionality)

### Firebase Setup
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android and iOS apps to your Firebase project
3. Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
4. Place configuration files in respective platform directories
5. Run FlutterFire CLI to configure:
```bash
flutter pub global activate flutterfire_cli
flutterfire configure --project=your-project-id
```

### Backend Configuration
1. Ensure your Django backend is running
2. Update API base URL in `lib/core/network/api_client.dart`
3. Configure deep linking domain in `AndroidManifest.xml` and iOS settings

### Clone the Repository
```bash
git clone https://github.com/yourusername/chattingus.git
cd chattingus
```

### Install Dependencies
```bash
flutter pub get
```

### Run the App
```bash
# Run on connected device/emulator
flutter run

# Build release APK (Android)
flutter build apk --release

# Build release bundle (Android)
flutter build appbundle --release

# Build iOS
flutter build ios --release
```

---

## 📖 Usage

### Navigation
- **Bottom Navigation Bar** - 5 tabs: Home, Search, Reels, Messages, Profile
- **Floating Action Button** - Quick theme switching (bottom-right corner)
- **Language Icon** - In chats screen top bar for language selection

### Theme Switching
1. Tap the floating action button (🌙/☀️)
2. Theme changes instantly with smooth animation
3. Selection persists across app restarts

### Language Switching
1. Tap the language icon (🌐) in chats screen
2. Select from English, Arabic, or French
3. App updates immediately
4. Selection is saved automatically

---

## 🌍 Localization

### Supported Languages

| Language | Code | Status |
|----------|------|--------|
| 🇬🇧 English | `en` | ✅ Complete |
| 🇸🇦 Arabic | `ar` | ✅ Complete (RTL) |
| 🇫🇷 French | `fr` | ✅ Complete |

### Adding New Languages

1. Create a new ARB file in `lib/l10n/`:
```bash
lib/l10n/app_<language_code>.arb
```

2. Copy keys from `app_en.arb` and translate values

3. Add locale to `main.dart`:
```dart
supportedLocales: const [
  Locale('en'),
  Locale('ar'),
  Locale('fr'),
  Locale('your_language_code'), // Add here
],
```

4. Run code generation:
```bash
flutter pub get
```

---

## 🏗️ Project Structure

```
lib/
├── core/                      # Core functionality
│   ├── models/                # Data models
│   │   ├── user.dart
│   │   ├── post.dart
│   │   ├── chat.dart
│   │   └── message.dart
│   ├── network/               # Networking layer
│   │   └── api_client.dart    # Dio HTTP client with interceptors
│   └── services/              # Business logic services
│       ├── auth_service.dart          # Authentication & JWT
│       ├── user_service.dart          # User management
│       ├── post_service.dart          # Posts & feed
│       ├── chat_service.dart          # Messaging
│       ├── notification_service.dart  # FCM notifications
│       ├── search_service.dart        # Search functionality
│       ├── permission_service.dart    # Permission handling
│       └── token_storage_service.dart # Secure token storage
├── controllers/               # GetX state management
│   ├── settings_controller.dart
│   ├── login_controller.dart
│   ├── signup_controller.dart
│   ├── user_profile_controller.dart
│   ├── feed_controller.dart
│   └── chat_controller.dart
├── l10n/                      # Localization files
│   ├── app_en.arb
│   ├── app_ar.arb
│   └── app_fr.arb
├── screens/                   # UI screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── main_navigation_screen.dart
│   ├── chats_screen.dart
│   ├── chat_detail_screen.dart
│   ├── feed_screen.dart
│   ├── reels_screen.dart
│   ├── explore_screen.dart
│   ├── profile_screen.dart
│   └── change_password_screen.dart
├── firebase_options.dart      # Firebase configuration
└── main.dart                  # App entry point
```

---

## 🔧 Configuration

### Theme Configuration
Themes are defined in `main.dart`:
```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
),
```

### Localization Configuration
Settings in `pubspec.yaml`:
```yaml
flutter:
  generate: true
  uses-material-design: true
```

---

## 📦 Dependencies

### Core Dependencies
- **flutter** - UI framework
- **get** (^4.7.3) - State management and navigation
- **shared_preferences** (^2.5.3) - Local data persistence
- **flutter_localizations** - Internationalization support
- **intl** (^0.20.2) - Internationalization utilities

### Firebase
- **firebase_core** (^2.24.0) - Firebase core functionality
- **firebase_messaging** (^14.7.0) - Push notifications (FCM)

### Networking & Storage
- **dio** (^5.4.0) - Advanced HTTP client
- **flutter_secure_storage** (^9.0.0) - Encrypted storage for tokens
- **json_annotation** (^4.8.1) - JSON serialization annotations

### Media & Permissions
- **image_picker** (^1.1.2) - Camera and gallery access
- **camera** (^0.11.0+2) - Camera functionality
- **permission_handler** (^11.3.1) - Runtime permissions

### Deep Linking & UI
- **app_links** (^6.3.2) - Deep linking support
- **fluttertoast** (^8.2.4) - Toast notifications
- **cupertino_icons** (^1.0.8) - iOS-style icons

### Dev Dependencies
- **flutter_test** - Testing framework
- **flutter_lints** (^5.0.0) - Linting rules
- **build_runner** (^2.4.8) - Code generation
- **json_serializable** (^6.7.1) - JSON serialization code generation

---

## 🎯 Roadmap

### ✅ Completed
- [x] Instagram-style UI design
- [x] Bottom navigation with 5 tabs
- [x] Animated splash screen
- [x] Theme switching (dark/light)
- [x] Multi-language support (EN, AR, FR)
- [x] Profile screen with tabs
- [x] Feed screen with posts
- [x] Reels screen layout
- [x] User authentication (JWT)
- [x] Backend integration (Django REST API)
- [x] Push notifications (FCM)
- [x] Direct messaging
- [x] Post creation and upload
- [x] Deep linking (password reset)
- [x] Secure token storage
- [x] Real-time notifications
- [x] Search functionality
- [x] Permission handling

### 🚧 In Progress
- [ ] Video playback in Reels
- [ ] Stories feature
- [ ] Group chat functionality
- [ ] WebSocket real-time messaging

### 📋 Planned
- [ ] Voice messages
- [ ] Video calls
- [ ] Story replies
- [ ] Advanced search filters
- [ ] User blocking/reporting
- [ ] Media compression
- [ ] Offline mode
- [ ] Analytics integration

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Daoud Bakhti**
- GitHub: [@bakhtidaoud](https://github.com/bakhtidaoud)
- Project: ChattingUs - Modern Social Media Platform

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- GetX for state management
- Instagram for design inspiration
- The open-source community

---

## 📞 Support

If you have any questions or need help, please:
- Open an issue on GitHub
- Contact via email
- Check the [documentation](https://flutter.dev/docs)

---

<div align="center">

### ⭐ Star this repository if you find it helpful!

**Made with BAKHTI ❤️ using Flutter**

</div>
