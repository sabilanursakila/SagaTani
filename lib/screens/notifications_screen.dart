import 'package:flutter/material.dart';

import '../models/rat_activity.dart';
import '../theme/app_theme.dart';
import '../utils/l10n.dart';
import '../widgets/tr.dart';
import 'activity_detail_screen.dart';

/// Pusat notifikasi dalam aplikasi, saat ini mengambil kejadian terbaru.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  String _two(int value) => value.toString().padLeft(2, '0');

  String _dateTime(DateTime value) =>
      '${value.day} ${L.t(_months[value.month - 1])} ${value.year} • '
      '${_two(value.hour)}:${_two(value.minute)}';

  @override
  Widget build(BuildContext context) {
    final activities = sampleRatActivities.take(5).toList();

    return Scaffold(
      backgroundColor: context.pageBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 14),
              child: Row(
                children: [
                  IconButton(
                    tooltip: L.t('Kembali'),
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Tr(
                          'Notifikasi',
                          style: TextStyle(
                            color: context.textMain,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Tr(
                          'Aktivitas terbaru perangkat',
                          style: TextStyle(
                            color: context.textSub,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Tr(
                'Pemberitahuan terbaru',
                style: TextStyle(
                  color: context.textMain,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: activities.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.notifications_none_rounded,
                                size: 42, color: context.textSub),
                            const SizedBox(height: 10),
                            Tr(
                              'Belum ada notifikasi',
                              style: TextStyle(
                                color: context.textSub,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 2, 16, 24),
                      itemCount: activities.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) =>
                          _notificationCard(context, activities[index]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationCard(BuildContext context, RatActivity activity) {
    return Material(
      color: context.cardBg,
      borderRadius: BorderRadius.circular(14),
      elevation: 1,
      shadowColor: AppColors.shadow,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ActivityDetailScreen(activity: activity),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: activity.status.backgroundFor(context),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  activity.status == RepelStatus.gagal
                      ? Icons.warning_amber_rounded
                      : Icons.sensors_rounded,
                  color: activity.status.foregroundFor(context),
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Tr(
                            activity.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: context.textMain,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward_rounded,
                            size: 16, color: context.textSub),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Tr(
                      activity.movement,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: context.textSub, fontSize: 11),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _dateTime(activity.time),
                            style: TextStyle(
                                color: context.textSub, fontSize: 10),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: activity.status.backgroundFor(context),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            L.t(activity.status.label),
                            style: TextStyle(
                              color: activity.status.foregroundFor(context),
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
