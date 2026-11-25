import 'package:flutter/material.dart';

import '../models/device_state.dart';
import '../theme/app_theme.dart';
import '../utils/l10n.dart';
import '../widgets/tr.dart';

/// Daftar perangkat terdaftar. Detail dibuka sebagai halaman lanjutan.
class DeviceListScreen extends StatelessWidget {
  final VoidCallback onOpenDevice;

  const DeviceListScreen({super.key, required this.onOpenDevice});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: DeviceState.instance,
      builder: (context, _) => _buildPage(context),
    );
  }

  Widget _buildPage(BuildContext context) {
    final dev = DeviceState.instance;
    return Scaffold(
      backgroundColor: context.pageBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          children: [
            Text(
              L.t('Perangkat'),
              style: TextStyle(
                color: context.textMain,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              L.t('Pantau perangkat Saga Tani'),
              style: TextStyle(color: context.textSub, fontSize: 12),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    L.t('Perangkat terdaftar'),
                    style: TextStyle(
                      color: context.textMain,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '1 ${L.t('perangkat')}',
                  style: TextStyle(color: context.textSub, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Material(
              color: context.cardBg,
              borderRadius: BorderRadius.circular(14),
              elevation: 2,
              shadowColor: AppColors.shadow,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onOpenDevice,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: context.softBg,
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: Icon(
                              Icons.memory_outlined,
                              color: context.accent,
                              size: 27,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  L.t('Perangkat Repelan'),
                                  style: TextStyle(
                                    color: context.textMain,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  dev.deviceId,
                                  style: TextStyle(
                                    color: context.textSub,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: context.softBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 7,
                                  color: dev.online
                                      ? AppColors.online
                                      : Colors.grey,
                                ),
                                const SizedBox(width: 5),
                                Tr(
                                  dev.online ? 'Online' : 'Offline',
                                  style: TextStyle(
                                    color: context.accent,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Divider(height: 1, color: context.lineColor),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _DeviceStat(
                              icon: Icons.sensors_outlined,
                              label: 'Sensor',
                              value: dev.sensorAktif ? 'Aktif' : 'Nonaktif',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _DeviceStat(
                              icon: Icons.battery_5_bar,
                              label: 'Baterai',
                              value: dev.bateraiText,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              L.t('Lihat detail perangkat'),
                              style: TextStyle(
                                color: context.accent,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward,
                              size: 18, color: context.accent),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _hubungkanPerangkat(context),
              icon: const Icon(Icons.link, size: 18),
              label: Text(L.t('Hubungkan perangkat dengan kode')),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DeviceStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: context.softBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: context.accent),
              const SizedBox(width: 6),
              Tr(label,
                  style: TextStyle(color: context.textSub, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 6),
          Tr(value,
              style: TextStyle(
                color: context.textMain,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              )),
        ],
      ),
    );
  }
}

/// Dialog untuk memasukkan kode perangkat (info/kodePair di Firebase).
Future<void> _hubungkanPerangkat(BuildContext context) async {
  final ctrl = TextEditingController();
  final kode = await showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(L.t('Hubungkan Perangkat'),
          style: const TextStyle(fontSize: 16)),
      content: TextField(
        controller: ctrl,
        autofocus: true,
        decoration: InputDecoration(hintText: L.t('Masukkan kode perangkat')),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: Text(L.t('Batal')),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(ctrl.text.trim()),
          child: Text(L.t('Hubungkan')),
        ),
      ],
    ),
  );
  if (kode == null || kode.isEmpty) return;

  final err = await DeviceState.instance.gabung(kode);
  if (!context.mounted) return;
  final pesan = err == null
      ? 'Berhasil terhubung ke perangkat ${DeviceState.instance.deviceId}.'
      : (err == 'kode_salah'
          ? 'Kode perangkat tidak valid.'
          : 'Gagal menghubungkan perangkat.');
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(pesan)));
}