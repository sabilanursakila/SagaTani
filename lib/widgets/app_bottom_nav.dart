import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../theme/app_theme.dart';
import '../utils/l10n.dart';

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

/// Menu navigasi bawah: 4 tab (Beranda, Perangkat, Akun, Pengaturan)
/// ditambah tombol Scan di tengah yang membuka kamera pemindai.
/// Warna latar, ikon, dan teks menyesuaikan tema terang / gelap.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  /// Dipanggil saat tombol kamera ditekan. Jika null, tombol tidak tampil.
  final VoidCallback? onScanTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.onScanTap,
  });

  static const _items = [
    _NavItem(Icons.home_outlined, 'Beranda'),
    _NavItem(Icons.tune, 'Perangkat'),
    _NavItem(Icons.person_outline, 'Akun'),
    _NavItem(Icons.settings_outlined, 'Pengaturan'),
  ];

  Widget _buildTab(int i, Color iconColor, Color labelColor) {
    final item = _items[i];
    final selected = currentIndex == i;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(i),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.online : Colors.transparent,
              ),
              child: Icon(item.icon,
                  size: 24, color: selected ? Colors.white : iconColor),
            ),
            const SizedBox(height: 2),
            Text(
              L.t(item.label),
              maxLines: 1,
              style: TextStyle(
                fontSize: 9,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.online : labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dibangun ulang otomatis saat bahasa atau tema diganti.
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, _) {
        final dark = Theme.of(context).brightness == Brightness.dark;
        final iconColor = dark ? Colors.white : Colors.black;
        final labelColor = dark ? Colors.white70 : Colors.black87;
        final shadowColor = dark ? const Color(0x66000000) : AppColors.shadow;

        // Susunan: Beranda, Perangkat, [Scan], Akun, Pengaturan
        final children = <Widget>[];
        for (var i = 0; i < _items.length; i++) {
          children.add(_buildTab(i, iconColor, labelColor));
          if (i == 1 && onScanTap != null) {
            children.add(_ScanNavButton(
              onTap: onScanTap!,
              iconColor: iconColor,
              labelColor: labelColor,
            ));
          }
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Container(
              height: 74,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(34),
                boxShadow: [
                  BoxShadow(
                      color: shadowColor,
                      blurRadius: 8,
                      offset: const Offset(0, 3)),
                ],
              ),
              child: Row(children: children),
            ),
          ),
        );
      },
    );
  }
}

/// Tombol Scan: polos saat diam, berlatar hijau hanya ketika sedang ditekan.
class _ScanNavButton extends StatefulWidget {
  final VoidCallback onTap;
  final Color iconColor;
  final Color labelColor;

  const _ScanNavButton({
    required this.onTap,
    required this.iconColor,
    required this.labelColor,
  });

  @override
  State<_ScanNavButton> createState() => _ScanNavButtonState();
}

class _ScanNavButtonState extends State<_ScanNavButton> {
  bool _pressed = false;

  void _setPressed(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _pressed ? AppColors.online : Colors.transparent,
              ),
              child: Icon(
                Icons.camera_alt_outlined,
                size: 24,
                color: _pressed ? Colors.white : widget.iconColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              L.t('Scan'),
              maxLines: 1,
              style: TextStyle(
                fontSize: 9,
                fontWeight: _pressed ? FontWeight.w700 : FontWeight.w500,
                color: _pressed ? AppColors.online : widget.labelColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}