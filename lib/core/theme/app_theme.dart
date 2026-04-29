import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const bgBase = Color(0xFF0F1117);
  static const bgSidebar = Color(0xFF13161E);
  static const bgCard = Color(0xFF1A1D27);
  static const bgInput = Color(0xFF252836);
  static const border = Color(0xFF2A2D3E);
  static const borderSubtle = Color(0xFF1E2030);

  static const textPrimary = Color(0xFFE8EAF0);
  static const textSecondary = Color(0xFF8B90A7);
  static const textMuted = Color(0xFF555A72);

  static const accentBlue = Color(0xFF4F8EF7);
  static const accentRed = Color(0xFFF25C54);
  static const accentGreen = Color(0xFF4ADE80);
  static const accentYellow = Color(0xFFE8C547);
  static const accentOrange = Color(0xFFF97316);
  static const accentPurple = Color(0xFFA78BFA);

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgBase,
    colorScheme: const ColorScheme.dark(
      primary: accentBlue,
      surface: bgCard,
      onSurface: textPrimary,
    ),
    textTheme: GoogleFonts.dmSansTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: textPrimary, displayColor: textPrimary),
  );
}
