import 'package:flutter/material.dart';

/// The single colour palette shared by all three screens.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0F5C63);
  static const Color primaryDark = Color(0xFF0A4247);
  static const Color primaryLight = Color(0xFF17767E);
  static const Color accent = Color(0xFFF2766B);

  static const Color background = Color(0xFFF3F8F7);
  static const Color surface = Colors.white;
  static const Color field = Color(0xFFF7FBFA);
  static const Color border = Color(0xFFD6E5E3);

  static const Color textPrimary = Color(0xFF16302F);
  static const Color textSecondary = Color(0xFF5B7270);
  static const Color error = Color(0xFFC0392B);

  /// Background of the header on every screen.
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primaryDark],
  );
}
