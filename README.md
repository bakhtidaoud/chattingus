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

### 📱 **Core Screens**

#### 🏠 **Home/Chats**
- Clean chat list interface
- Story carousel at the top
- Search functionality
- Language switcher

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
- Edit Profile button

#### 🔍 **Explore**
- Discover new content (coming soon)

### 🎭 **Animations & Interactions**
- **Splash Screen** - Fade-in and elastic scale animations
- **Theme Switcher** - Rotating icon with fade transition
- **Page Transitions** - Smooth fade transitions between screens
- **Bottom Sheets** - Elegant slide-up animations

### 🛠️ **Technical Features**
- **GetX State Management** - Reactive and efficient
- **Persistent Storage** - SharedPreferences for settings
- **Clean Architecture** - Organized code structure
- **Material 3 Design** - Latest Flutter design system

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
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- Git

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

# Run on specific platform
flutter run -d windows
flutter run -d android
flutter run -d ios
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
├── controllers/          # GetX controllers for state management
│   ├── chats_controller.dart
│   ├── login_controller.dart
│   └── settings_controller.dart
├── l10n/                # Localization files
│   ├── app_en.arb
│   ├── app_ar.arb
│   └── app_fr.arb
├── screens/             # UI screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── main_navigation_screen.dart
│   ├── chats_screen.dart
│   ├── reels_screen.dart
│   ├── explore_screen.dart
│   ├── profile_screen.dart
│   └── chat_detail_screen.dart
└── main.dart           # App entry point
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

### Dev Dependencies
- **flutter_test** - Testing framework
- **flutter_lints** (^5.0.0) - Linting rules

---

## 🎯 Roadmap

- [x] Instagram-style UI design
- [x] Bottom navigation with 5 tabs
- [x] Animated splash screen
- [x] Theme switching (dark/light)
- [x] Multi-language support (EN, AR, FR)
- [x] Profile screen with tabs
- [x] Reels screen layout
- [ ] Real-time chat functionality
- [ ] Video playback in Reels
- [ ] Post creation and upload
- [ ] User authentication
- [ ] Backend integration
- [ ] Push notifications
- [ ] Stories feature
- [ ] Direct messaging

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

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

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
