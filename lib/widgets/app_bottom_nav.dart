import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../theme/app_theme.dart';
import '../utils/l10n.dart';

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

/// Menu navigasi bawah dengan tombol Scan yang menonjol di tengah.
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
    _NavItem(Icons.history, 'Riwayat'),
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

        // Susunan: Beranda, Perangkat, [Scan], Riwayat, Pengaturan
        final children = <Widget>[];
        for (var i = 0; i < _items.length; i++) {
          children.add(_buildTab(i, iconColor, labelColor));
          if (i == 1 && onScanTap != null) {
            children.add(_ScanNavButton(
              onTap: onScanTap!,
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

/// Tombol Scan selalu menonjol di tengah navigasi.
class _ScanNavButton extends StatefulWidget {
  final VoidCallback onTap;

  const _ScanNavButton({required this.onTap});

  @override
  State<_ScanNavButton> createState() => _ScanNavButtonState();
}

class _ScanNavButtonState extends State<_ScanNavButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: Transform.translate(
          offset: const Offset(0, -7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: _pressed ? 0.94 : 1,
                duration: const Duration(milliseconds: 120),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.online,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x330B5B3B),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                L.t('Scan'),
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: AppColors.online,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
