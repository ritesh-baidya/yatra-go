import 'package:flutter/material.dart';

class YatriTheme {
  // Primary brand colors
  static const Color primary = Color(0xFF0A5C36); // deep green
  static const Color primaryLight = Color(0xFFE6F6EE);
  static const Color background = Color(0xFFF5F5F5);
  static const Color scaffoldBg = Color(0xFFF8FAFC);

  // Gradient for header background
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF053E23), Color(0xFF03311A)],
  );

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: const Color(0x33000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static const LinearGradient ctaGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A5C36), Color(0xFF053E23)],
  );

  static ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: scaffoldBg,
        primaryColor: primary,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black54,
          ),
        ),
        iconTheme: const IconThemeData(color: primary),
        shadowColor: Colors.black12,
      );
}
