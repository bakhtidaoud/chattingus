import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryIndigo = Color(0xFF6366F1);
  static const Color midnight = Color(0xFF0F172A);
  static const Color electricViolet = Color(0xFFA855F7);
  static const Color glassBase = Color(0x1A6366F1); // 10% opacity primary
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: midnight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryIndigo,
        brightness: Brightness.dark,
        primary: primaryIndigo,
        secondary: electricViolet,
        surface: midnight,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            headlineMedium: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
      cardTheme: CardTheme(
        color: glassBase,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: glassBorder, width: 1.5),
        ),
      ),
    );
  }

  // Gradients
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [primaryIndigo, electricViolet],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Colors.white10, Colors.white05],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
