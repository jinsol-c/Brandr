import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF1A1A2E); // Deep Navy
  static const Color secondaryColor = Color(0xFF2E5FA3); // Royal Blue
  static const Color accentColor = Color(0xFFB8860B); // Gold
  static const Color backgroundColor = Color(0xFFF8F9FA); // Off White
  static const Color cardColor = Color(0xFFFFFFFF); // White

  // 브랜드 유형별 배경 (그라디언트 혹은 단일 기준)
  static const Color typeSeed = Color(0xFF4A7C59); // Sage Green
  static const Color typeGrowth = Color(0xFF2A7886); // Teal Blue
  static const Color typeMixed = Color(0xFF3D5A99); // Indigo
  static const Color typeComplete = Color(0xFF1A1A2E); // Deep Navy

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor).copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
      ),
      textTheme: GoogleFonts.notoSansKrTextTheme(
        ThemeData.light().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.notoSansKr(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        headlineLarge: GoogleFonts.notoSansKr(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: primaryColor,
        ),
        headlineMedium: GoogleFonts.notoSansKr(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        bodyLarge: GoogleFonts.notoSansKr(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
        labelLarge: GoogleFonts.notoSansKr(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: primaryColor),
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: cardColor,
        elevation: 2,
        margin: EdgeInsets.all(4),
      ),
    );
  }
}
