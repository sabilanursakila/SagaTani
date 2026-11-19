import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../models/rat_activity.dart';
import '../models/user_session.dart';
import '../theme/app_theme.dart';
import '../utils/l10n.dart';
import '../widgets/tr.dart';
import 'activity_detail_screen.dart';
import 'notifications_screen.dart';
import 'sound_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onOpenDevice;
  const HomeScreen({super.key, this.onOpenDevice});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _mode = 0; // 0 = Otomatis (default), 1 = Manual
  DateTime? _manualTime; // jadwal yang diatur lewat pop up Manual

  static const _cardShadow = [
    BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 3)),
  ];

  static const _daysId = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu',
  ];
  static const _daysEn = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
    'Sunday',
  ];
  static const _monthsId = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];
  static const _monthsEn = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  // ---------- Bantuan teks & format ----------

  /// Teks dua bahasa langsung di tempat.
  String _t(String id, String en) => AppSettings.instance.isEnglish ? en : id;

  String _two(int n) => n.toString().padLeft(2, '0');

  String _dayName(DateTime d) => AppSettings.instance.isEnglish
      ? _daysEn[d.weekday - 1]
      : _daysId[d.weekday - 1];

  String _monthName(DateTime d) => AppSettings.instance.isEnglish
      ? _monthsEn[d.month - 1]
      : _monthsId[d.month - 1];

  String _timeText(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}';

  String _fullText(DateTime d) =>
      '${_dayName(d)}, ${d.day} ${_monthName(d)} ${d.year} • ${_timeText(d)}';

  void _openNotifications() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pageBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 18),
              _deviceCard(),
              const SizedBox(height: 20),
              _sectionTitle('Status Sistem'),
              _systemStatus(),
              const SizedBox(height: 20),
              _sectionTitle('Mode Operasi'),
              _modeSelector(),
              _manualSummary(),
              const SizedBox(height: 20),
              _sectionTitle('Pemilihan Suara'),
              _soundPicker(),
              const SizedBox(height: 20),
              _sectionTitle('Riwayat Aktivitas'),
              _history(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return AnimatedBuilder(
      animation: Listenable.merge([UserSession.instance, AppSettings.instance]),
      builder: (context, _) {
        final user = UserSession.instance;
        final dark = Theme.of(context).brightness == Brightness.dark;
        final greetStyle = TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: context.textMain,
        );
        return Row(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundColor: context.softBg,
              child: Icon(Icons.person_outline,
                  size: 30, color: context.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${L.t('Halo')}, ${user.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: dark
                          ? AppPalette.adaptTextStyle(greetStyle)
                          : greetStyle),
                  const SizedBox(height: 2),
                  Tr(
                    'Petani Sawah Sejahtera',
                    style: TextStyle(fontSize: 11, color: context.textSub),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: _openNotifications,
              tooltip: L.t('Notifikasi'),
              style: IconButton.styleFrom(
                backgroundColor: context.softBg,
                foregroundColor: context.accent,
                fixedSize: const Size(46, 46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              icon: const Icon(Icons.notifications_none, size: 22),
            ),
          ],
        );
      },
    );
  }

  Widget _deviceCard() {
    const radius = BorderRadius.all(Radius.circular(18));
    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B5B3B), Color(0xFF247B53)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220B5B3B),
            blurRadius: 16,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onOpenDevice,
          child: Stack(
            children: [
              Positioned(
                right: -22,
                top: -34,
                child: Container(
                  width: 118,
                  height: 118,
                  decoration: const BoxDecoration(
                    color: Color(0x14FFFFFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 47,
                bottom: -55,
                child: Container(
                  width: 105,
                  height: 105,
                  decoration: const BoxDecoration(
                    color: Color(0x0DFFFFFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0x20FFFFFF),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0x26FFFFFF)),
                      ),
                      child: const Icon(Icons.memory_outlined,
                          size: 28, color: Colors.white),
                    ),
                    const SizedBox(width: 13),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Tr(
                            'Perangkat Aktif',
                            style: TextStyle(
                              color: Color(0xDFFFFFFF),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 2),
                          Tr(
                            'R-001',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.circle,
                                  size: 7, color: Color(0xFF8BE09B)),
                              SizedBox(width: 5),
                              Tr(
                                'Online',
                                style: TextStyle(
                                  color: Color(0xFFB9F1C2),
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0x1AFFFFFF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward,
                          size: 17, color: Colors.white),
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

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Tr(text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      );

  /// Tiga status dalam satu kartu, dipisah garis tegak.
  Widget _systemStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 15),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.lineColor),
        boxShadow: _cardShadow,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            const Expanded(
              child: _StatusItem(
                  icon: Icons.sensors,
                  label: 'Sensor',
                  value: 'Aktif',
                  active: true),
            ),
            VerticalDivider(width: 1, thickness: 1, color: context.lineColor),
            const Expanded(
              child: _StatusItem(
                  icon: Icons.volume_up_outlined,
                  label: 'Suara',
                  value: 'Berjalan'),
            ),
            VerticalDivider(width: 1, thickness: 1, color: context.lineColor),
            const Expanded(
              child: _StatusItem(
                  icon: Icons.phonelink_ring,
                  label: 'Status',
                  value: 'Terhubung'),
            ),
          ],
        ),
      ),
    );
  }

  /// Dua kartu lebar: Otomatis dan Manual.
  /// Menekan Manual membuka pop up pengaturan jadwal.
  Widget _modeSelector() {
    Widget item(int index, IconData icon, String label) {
      final selected = _mode == index;
      return Expanded(
        child: Material(
          color: selected
              ? (context.isDark ? AppPalette.darkAccent : AppColors.primary)
              : context.cardBg,
          borderRadius: BorderRadius.circular(15),
          elevation: selected ? 2 : 0,
          shadowColor: AppColors.shadow,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              if (index == 1) {
                _openManualDialog();
              } else {
                setState(() => _mode = index);
              }
            },
            child: Container(
              height: 62,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: selected ? Colors.transparent : context.lineColor,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color:
                          selected ? const Color(0x24FFFFFF) : context.softBg,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: Icon(
                      icon,
                      size: 19,
                      color: selected
                          ? (context.isDark ? AppPalette.darkBg : Colors.white)
                          : context.accent,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Tr(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? (context.isDark
                                ? AppPalette.darkBg
                                : Colors.white)
                            : context.textMain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        item(0, Icons.calendar_month_outlined, 'Otomatis'),
        const SizedBox(width: 14),
        item(1, Icons.smartphone, 'Manual'),
      ],
    );
  }

  /// Ringkasan jadwal manual di bawah pilihan mode (ketuk untuk mengubah).
  Widget _manualSummary() {
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, _) {
        final t = _manualTime;
        if (_mode != 1 || t == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Material(
            color: context.cardBg,
            elevation: 2,
            shadowColor: AppColors.shadow,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: _openManualDialog,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.schedule, size: 18, color: context.accent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_t('Jadwal manual', 'Manual schedule'),
                              style: TextStyle(
                                  fontSize: 11, color: context.textSub)),
                          const SizedBox(height: 2),
                          Text(_fullText(t),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    Icon(Icons.edit_outlined,
                        size: 16, color: context.textSub),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ---------- Pop up jadwal manual ----------

  Future<void> _openManualDialog() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initial = _manualTime ?? now.add(const Duration(minutes: 5));
    var date = DateTime(initial.year, initial.month, initial.day);
    var time = TimeOfDay.fromDateTime(initial);

    final result = await showDialog<DateTime>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) {
          final chosen = DateTime(
              date.year, date.month, date.day, time.hour, time.minute);
          final isPast = chosen.isBefore(DateTime.now());

          Future<void> pickDate() async {
            final picked = await showDatePicker(
              context: ctx,
              initialDate: date.isBefore(today) ? today : date,
              firstDate: today,
              lastDate: today.add(const Duration(days: 365)),
            );
            if (picked != null) setLocal(() => date = picked);
          }

          Future<void> pickTime() async {
            final picked =
                await showTimePicker(context: ctx, initialTime: time);
            if (picked != null) setLocal(() => time = picked);
          }

          return AlertDialog(
            title: Text(_t('Atur Jadwal Manual', 'Set Manual Schedule'),
                style: const TextStyle(fontSize: 16)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _pickerTile(
                    Icons.calendar_today_outlined,
                    _t('Tanggal', 'Date'),
                    '${date.day} ${_monthName(date)} ${date.year}',
                    pickDate,
                  ),
                  const SizedBox(height: 10),
                  _pickerTile(
                    Icons.access_time,
                    _t('Jam', 'Time'),
                    '${_two(time.hour)}:${_two(time.minute)}',
                    pickTime,
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _cell(_t('Hari', 'Day'), _dayName(date)),
                      _cell(_t('Tgl', 'Date'), '${date.day}'),
                      _cell(_t('Bulan', 'Month'), _monthName(date)),
                      _cell(_t('Jam', 'Time'),
                          '${_two(time.hour)}:${_two(time.minute)}'),
                    ],
                  ),
                  if (isPast) ...[
                    const SizedBox(height: 12),
                    Text(
                      _t('Waktu sudah lewat, pilih waktu yang akan datang.',
                          'That time has passed, choose a future time.'),
                      style: const TextStyle(
                          fontSize: 11, color: Color(0xFFC62828)),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(_t('Batal', 'Cancel')),
              ),
              TextButton(
                onPressed:
                    isPast ? null : () => Navigator.of(ctx).pop(chosen),
                child: Text(_t('Simpan', 'Save'),
                    style: TextStyle(
                        color: isPast ? null : ctx.accent)),
              ),
            ],
          );
        },
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _mode = 1;
        _manualTime = result;
        // TODO: kirim jadwal manual (_manualTime) ke perangkat.
      });
    }
  }

  /// Baris yang bisa diketuk untuk membuka pemilih tanggal / jam.
  Widget _pickerTile(
      IconData icon, String label, String value, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: context.cardBg,
          border: Border.all(color: context.lineColor),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: context.accent),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 11, color: context.textSub)),
                  const SizedBox(height: 1),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: context.textSub),
          ],
        ),
      ),
    );
  }

  /// Satu kolom ringkasan (Hari / Tgl / Bulan / Jam) di dalam pop up.
  Widget _cell(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: TextStyle(fontSize: 11, color: context.textSub)),
          const SizedBox(height: 2),
          Text(value,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _soundPicker() {
    return Material(
      color: context.cardBg,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      shadowColor: AppColors.shadow,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SoundSelectionScreen()),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: context.softBg,
                  borderRadius: const BorderRadius.all(Radius.circular(13)),
                ),
                child: Icon(
                  Icons.volume_up_outlined,
                  size: 21,
                  color: context.accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Tr('Daftar Suara',
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600)),
              ),
              Icon(Icons.arrow_forward, size: 17, color: context.textSub),
            ],
          ),
        ),
      ),
    );
  }

  /// Ringkasan kejadian terbaru; detailnya dibuka sebagai halaman terpisah.
  Widget _history() {
    final activity = sampleRatActivities.first;
    void openDetails() => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ActivityDetailScreen(activity: activity),
          ),
        );

    return Material(
      color: context.cardBg,
      borderRadius: BorderRadius.circular(16),
      elevation: 2,
      shadowColor: AppColors.shadow,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.place_outlined, size: 17, color: context.accent),
                const SizedBox(width: 6),
                Expanded(
                  child: Tr(
                    activity.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                      color: activity.status.backgroundFor(context),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    L.t(activity.status.label),
                    style: TextStyle(
                      color: activity.status.foregroundFor(context),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _fullText(activity.time),
              style: TextStyle(color: context.textSub, fontSize: 11),
            ),
            const SizedBox(height: 8),
            Tr(
              activity.movement,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: context.textMain, fontSize: 12),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: Divider(height: 1, color: context.lineColor),
            ),
            Material(
              color: context.softBg,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: openDetails,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _t('Lihat detail kejadian', 'View event details'),
                          style: TextStyle(
                            color: context.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_forward_rounded,
                          size: 18, color: context.accent),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool active;

  const _StatusItem({
    required this.icon,
    required this.label,
    required this.value,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: context.softBg,
          ),
          child: Icon(
            icon,
            size: 21,
            color: active ? AppColors.online : context.accent,
          ),
        ),
        const SizedBox(height: 7),
        Tr(label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: context.textSub,
            )),
        const SizedBox(height: 2),
        Tr(value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: active ? AppColors.online : context.textMain,
            )),
      ],
    );
  }
}
