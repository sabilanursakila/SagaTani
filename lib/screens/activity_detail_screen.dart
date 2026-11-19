import 'package:flutter/material.dart';

import '../models/rat_activity.dart';
import '../theme/app_theme.dart';
import '../utils/l10n.dart';
import '../widgets/tr.dart';

/// Rincian satu catatan aktivitas yang dibuka dari Beranda atau Riwayat.
class ActivityDetailScreen extends StatelessWidget {
  final RatActivity activity;

  const ActivityDetailScreen({super.key, required this.activity});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  String _two(int n) => n.toString().padLeft(2, '0');

  String _dateText(DateTime value) =>
      '${value.day} ${L.t(_months[value.month - 1])} ${value.year}';

  String _timeText(DateTime value) =>
      '${_two(value.hour)}:${_two(value.minute)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pageBg,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: L.t('Kembali'),
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 4),
                const Tr(
                  'Detail Aktivitas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: context.softBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.pest_control_rodent,
                      size: 30,
                      color: context.accent,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Tr(
                    activity.location,
                    style: TextStyle(
                      color: context.textMain,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_dateText(activity.time)} • ${_timeText(activity.time)}',
                    style: TextStyle(color: context.textSub, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: activity.status.bg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      L.t(activity.status.label),
                      style: TextStyle(
                        color: activity.status.fg,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Tr(
              'Rincian kejadian',
              style: TextStyle(
                color: context.textMain,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            _DetailRow(
              icon: Icons.place_outlined,
              label: 'Lokasi',
              value: activity.location,
            ),
            const SizedBox(height: 10),
            _DetailRow(
              icon: Icons.directions_run,
              label: 'Pergerakan',
              value: activity.movement,
            ),
            const SizedBox(height: 10),
            _DetailRow(
              icon: Icons.volume_up_outlined,
              label: 'Suara keluar',
              value: activity.sound,
            ),
            const SizedBox(height: 10),
            _DetailRow(
              icon: Icons.verified_outlined,
              label: 'Status pengusiran',
              value: L.t(activity.status.label),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: context.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tr(label,
                    style: TextStyle(color: context.textSub, fontSize: 11)),
                const SizedBox(height: 3),
                Tr(
                  value,
                  style: TextStyle(
                    color: context.textMain,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
