import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Logo Saga Tani. Letakkan file logo di assets/images/logo.png.
/// Jika file belum ada, ditampilkan ikon pengganti.
class SagaLogo extends StatelessWidget {
  final double size;
  const SagaLogo({super.key, this.size = 120});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        child: Icon(Icons.pest_control_rodent,
            color: Colors.white, size: size * 0.5),
      ),
    );
  }
}
