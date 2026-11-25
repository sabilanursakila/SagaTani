import 'package:flutter/material.dart';

import '../models/activity_store.dart';
import '../models/device_state.dart';
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

  List<_InfoItem> _items() {
    final d = DeviceState.instance;
    return [
      _InfoItem(Icons.sensors, 'Sensor', d.sensorAktif ? 'Aktif' : 'Nonaktif'),
      _InfoItem(Icons.volume_up_outlined, 'Suara yang Diputar', d.suaraText),
      _InfoItem(Icons.volume_down_outlined, 'Volume Suara', d.volumeText),
      _InfoItem(Icons.battery_full, 'Baterai', d.bateraiLabel),
      _InfoItem(Icons.history, 'Waktu Operasi Terakhir', d.operasiText),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          Listenable.merge([DeviceState.instance, ActivityStore.instance]),
      builder: (context, _) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pageBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed:
                        onBack ?? () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Tr('Detail Perangkat',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              _deviceHeader(context),
              const SizedBox(height: 20),
              for (final item in _items()) _infoCard(context, item),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.lineColor),
        boxShadow: _shadow,
      ),
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: context.softBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.memory_outlined,
                size: 38, color: context.accent),
          ),
          Expanded(
            child: Column(
              children: [
                Tr(DeviceState.instance.deviceId,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle,
                        size: 6,
                        color: DeviceState.instance.online
                            ? AppColors.online
                            : Colors.grey),
                    const SizedBox(width: 4),
                    Tr(DeviceState.instance.online ? 'Online' : 'Offline',
                        style: TextStyle(
                            fontSize: 12,
                            color: DeviceState.instance.online
                                ? AppColors.online
                                : Colors.grey)),
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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.lineColor),
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
                Tr(item.title,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w600)),
                const SizedBox(height: 3),
                Tr(item.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12,
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