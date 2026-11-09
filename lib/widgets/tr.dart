import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../theme/app_theme.dart';
import '../utils/l10n.dart';

/// Pengganti `Text` yang otomatis diterjemahkan sesuai bahasa pilihan
/// dan menyesuaikan warna teks untuk mode gelap. Tetap bisa dipakai `const`.
class Tr extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const Tr(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, _) {
        final dark = Theme.of(context).brightness == Brightness.dark;
        return Text(
          L.t(text),
          style: dark ? AppPalette.adaptTextStyle(style) : style,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        );
      },
    );
  }
}