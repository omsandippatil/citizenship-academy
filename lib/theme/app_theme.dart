import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF20B2AA);
  static const Color gold = Color(0xFFFFD700);
  static const Color textDark = Color(0xFF2F4F4F);
  static const Color bg = Color(0xFFF8FFFE);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color softGreen = Color(0xFFE0F7F5);
  static const Color softGold = Color(0xFFFFF8DC);
  static const Color border = Color(0xFFB2DFDB);
  static const Color muted = Color(0xFF607D7B);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        fontFamily: 'Nunito',
        scaffoldBackgroundColor: bg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          primary: primary,
          secondary: gold,
          surface: cardBg,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: bg,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: textDark,
            fontSize: 20,
            fontWeight: FontWeight.w800,
            fontFamily: 'Nunito',
          ),
          iconTheme: IconThemeData(color: textDark),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              fontFamily: 'Nunito',
            ),
          ),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: textDark, fontWeight: FontWeight.w900),
          displayMedium: TextStyle(color: textDark, fontWeight: FontWeight.w800),
          headlineLarge: TextStyle(color: textDark, fontWeight: FontWeight.w800),
          headlineMedium: TextStyle(color: textDark, fontWeight: FontWeight.w700),
          headlineSmall: TextStyle(color: textDark, fontWeight: FontWeight.w700),
          titleLarge: TextStyle(color: textDark, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(color: textDark, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(color: textDark),
          bodyMedium: TextStyle(color: textDark),
          labelLarge: TextStyle(color: textDark, fontWeight: FontWeight.w700),
        ),
      );
}