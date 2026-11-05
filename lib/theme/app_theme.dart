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
}