import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/icon_badge.dart';
import '../widgets/tr.dart';

class _InfoItem {
  final IconData icon;
  final String title;
  final String value;
  const _InfoItem(this.icon, this.title, this.value);
}

/// Detail Perangkat: status perangkat dalam satu halaman.
class DeviceDetailScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const DeviceDetailScreen({super.key, this.onBack});

  static const _shadow = [
    BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 3)),
  ];

  static const _items = [
    _InfoItem(Icons.sensors, 'Sensor', 'Aktif'),
    _InfoItem(Icons.volume_up_outlined, 'Suara yang Diputar', 'Suara Elang'),
    _InfoItem(Icons.volume_down_outlined, 'Volume Suara', 'Volume 75%'),
    _InfoItem(Icons.battery_full, 'Baterai', '87 %'),
    _InfoItem(Icons.history, 'Waktu Operasi Terakhir', '24 sep 2026 09:25'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text('Detail Perangkat',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              _deviceHeader(context),
              const SizedBox(height: 20),
              for (final item in _items) _infoCard(context, item),
            ],
          ),
        ),
      ),
    );
  }

  Widget _deviceHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(6),
        boxShadow: _shadow,
      ),
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: _shadow,
            ),
            child: const Icon(Icons.home_outlined,
                size: 44, color: AppColors.primary),
          ),
          const Expanded(
            child: Column(
              children: [
                Text('R-001',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, size: 6, color: AppColors.online),
                    SizedBox(width: 4),
                    Text('Online',
                        style:
                            TextStyle(fontSize: 9, color: AppColors.online)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(BuildContext context, _InfoItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(6),
        boxShadow: _shadow,
      ),
      child: Row(
        children: [
          IconBadge(icon: item.icon, radius: 16),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: const TextStyle(
                        fontSize: 10, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Text(item.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.link)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}