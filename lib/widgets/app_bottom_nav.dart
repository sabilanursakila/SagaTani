import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../theme/app_theme.dart';
import '../utils/l10n.dart';

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

/// Menu navigasi bawah (4 tab) dengan keterangan di bawah tiap ikon:
/// Beranda, Perangkat, Riwayat, Pengaturan.
/// Warna latar, ikon, dan teks menyesuaikan tema terang / gelap.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(Icons.home_outlined, 'Beranda'),
    _NavItem(Icons.tune, 'Perangkat'),
    _NavItem(Icons.history, 'Riwayat'),
    _NavItem(Icons.settings_outlined, 'Pengaturan'),
  ];

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
              child: Row(
                children: List.generate(_items.length, (i) {
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
                              color: selected
                                  ? AppColors.online
                                  : Colors.transparent,
                            ),
                            child: Icon(item.icon,
                                size: 24,
                                color: selected ? Colors.white : iconColor),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            L.t(item.label),
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight:
                                  selected ? FontWeight.w700 : FontWeight.w500,
                              color: selected ? AppColors.online : labelColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}