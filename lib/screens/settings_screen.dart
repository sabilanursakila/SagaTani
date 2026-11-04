import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/icon_badge.dart';

class _SettingItem {
  final IconData icon;
  final String title;
  final String subtitle;
  const _SettingItem(this.icon, this.title, this.subtitle);
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _items = [
    _SettingItem(Icons.calendar_month_outlined, 'Mode Operasi',
        'Terjadwal,Sensor,Manual'),
    _SettingItem(Icons.volume_up_outlined, 'Pemilihan Suara',
        'Pilih atau acak suara predator'),
    _SettingItem(Icons.sensors, 'Sensor', 'Konfigurasi dan sensitivitas Sensor'),
    _SettingItem(Icons.notifications_none, 'Notifikasi',
        'Pengaturan notifikasi aplikasi'),
    _SettingItem(Icons.smartphone, 'Perangkat',
        'Informasi perangkat dan pengguna'),
    _SettingItem(
        Icons.account_circle_outlined, 'Akun', 'Profil dan Keamanan'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8),
                child: Text('Pengaturan',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: Offset(0, 3)),
                  ],
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < _items.length; i++) ...[
                      _tile(_items[i]),
                      if (i != _items.length - 1)
                        const Divider(
                          height: 3,
                          thickness: 3,
                          color: Color(0xFFEFEFEF),
                        ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(_SettingItem item) {
    return InkWell(
      onTap: () {}, // TODO: buka halaman pengaturan terkait
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Row(
          children: [
            IconBadge(icon: item.icon, radius: 16),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(item.subtitle,
                      style: const TextStyle(
                          fontSize: 8, color: AppColors.textMuted)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    );
  }
}
