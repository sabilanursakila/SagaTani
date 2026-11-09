import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF0B5B3B); // hijau tua (tombol, kartu)
  static const brand = Color(0xFF4A8C75); // warna teks "SAGA TANI"
  static const online = Color(0xFF2E9E4F); // status aktif / online
  static const link = Color(0xFF1B7F3F); // tautan
  static const textDark = Color(0xFF1A1A1A);
  static const textMuted = Color(0xFF6B6B6B);
  static const border = Color(0xFFD0D5D3);
  static const shadow = Color(0x26000000);
}

/// Warna yang berubah mengikuti mode terang / gelap.
class AppPalette {
  static const darkBg = Color(0xFF0F1713);
  static const darkCard = Color(0xFF1A2520);
  static const darkLine = Color(0xFF2A3731);
  static const darkText = Color(0xFFEAF2EE);
  static const darkMuted = Color(0xFF9DB0A6);
  static const darkAccent = Color(0xFF6FCF97); // hijau terang untuk aksen
  static const darkSoft = Color(0xFF22362B); // latar ikon / pilihan

  /// Dipakai oleh widget `Tr`: ubah warna teks gelap menjadi terang.
  static TextStyle? adaptTextStyle(TextStyle? s) {
    final c = s?.color;
    if (s == null || c == null) return s;
    if (c == AppColors.textDark || c == Colors.black || c == Colors.black87) {
      return s.copyWith(color: darkText);
    }
    if (c == AppColors.textMuted) return s.copyWith(color: darkMuted);
    if (c == AppColors.primary || c == AppColors.link) {
      return s.copyWith(color: darkAccent);
    }
    return s;
  }
}

extension AppThemeX on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  Color get pageBg => isDark ? AppPalette.darkBg : const Color(0xFFF5F7F5);
  Color get cardBg => isDark ? AppPalette.darkCard : Colors.white;
  Color get lineColor => isDark ? AppPalette.darkLine : const Color(0xFFEEF0EE);
  Color get textMain => isDark ? AppPalette.darkText : AppColors.textDark;
  Color get textSub => isDark ? AppPalette.darkMuted : AppColors.textMuted;
  Color get accent => isDark ? AppPalette.darkAccent : AppColors.primary;
  Color get softBg => isDark ? AppPalette.darkSoft : const Color(0xFFE3F6E4);
  Color get iconColor => isDark ? AppPalette.darkText : Colors.black;
}

class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
        ),
      );

  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppPalette.darkBg,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          primary: AppPalette.darkAccent,
          surface: AppPalette.darkCard,
        ),
      );
}