import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.royalNavy,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.royalGold,
        secondary: AppColors.saffronAccent,
        surface: AppColors.cardDark,
        background: AppColors.darkBackground,
        onPrimary: AppColors.royalNavy,
        onSecondary: AppColors.white,
        onSurface: AppColors.textLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.royalNavy,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.tiroDevanagariHindi(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.royalGold,
        ),
        iconTheme: const IconThemeData(color: AppColors.royalGold),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardDark,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderGold, width: 0.8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.royalGold,
          foregroundColor: AppColors.royalNavy,
          textStyle: GoogleFonts.tiroDevanagariHindi(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.saffronAccent,
          side: const BorderSide(color: AppColors.saffronAccent, width: 1.5),
          textStyle: GoogleFonts.tiroDevanagariHindi(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.tiroDevanagariHindi(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: AppColors.royalGold,
        ),
        titleLarge: GoogleFonts.tiroDevanagariHindi(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.white,
        ),
        titleMedium: GoogleFonts.tiroDevanagariHindi(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textLight,
        ),
        bodyLarge: GoogleFonts.tiroDevanagariHindi(
          fontSize: 15,
          color: AppColors.textLight,
        ),
        bodyMedium: GoogleFonts.tiroDevanagariHindi(
          fontSize: 13,
          color: AppColors.textMuted,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.royalNavy,
        selectedItemColor: AppColors.royalGold,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
