import 'package:flutter/material.dart';

import '../models/user_session.dart';
import '../theme/app_theme.dart';
import 'sound_selection_screen.dart';
import '../widgets/tr.dart';
import '../models/app_settings.dart';
import '../utils/l10n.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onOpenDevice;
  const HomeScreen({super.key, this.onOpenDevice});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _mode = 1; // 0 = Otomatis, 1 = Manual
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _header(),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: widget.onOpenDevice,
                child: _deviceCard(),
              ),
              const SizedBox(height: 16),
              _sectionTitle('Status Sistem'),
              _systemStatus(),
              const SizedBox(height: 16),
              _sectionTitle('Mode Operasi'),
              _modeSelector(),
              _manualSummary(),
              const SizedBox(height: 16),
              _sectionTitle('Pemilihan Suara'),
              _soundPicker(),
              const SizedBox(height: 16),
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
        const greetStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
        return Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Color(0xFFD9D9D9),
              child: Icon(Icons.person, size: 44, color: Colors.black),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${L.t('Halo')}, ${user.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          dark ? AppPalette.adaptTextStyle(greetStyle) : greetStyle),
                  const SizedBox(height: 2),
                  const Tr('Petani Sawah Sejahtera',
                      style:
                          TextStyle(fontSize: 9, color: AppColors.textMuted)),
                ],
              ),
            ),
            IconButton(
              onPressed: () {}, // TODO: notifikasi
              icon: const Icon(Icons.notifications_none, size: 28),
            ),
          ],
        );
      },
    );
  }

  Widget _deviceCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(Icons.home_outlined, size: 48, color: Color(0x66FFFFFF)),
          const SizedBox(width: 24),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tr('Perangkat Aktif',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
                Tr('R-001',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.circle, size: 6, color: Color(0xFF4CD964)),
                    SizedBox(width: 4),
                    Tr('Online',
                        style:
                            TextStyle(color: Color(0xFF4CD964), fontSize: 9)),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Tr(text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      );

  /// Tiga status dalam satu kartu, dipisah garis tegak.
  Widget _systemStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(6),
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
        child: GestureDetector(
          onTap: () {
            if (index == 1) {
              _openManualDialog();
            } else {
              setState(() => _mode = index);
            }
          },
          child: Container(
            height: 58,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : context.cardBg,
              borderRadius: BorderRadius.circular(6),
              boxShadow: _cardShadow,
            ),
            child: Row(
              children: [
                Icon(icon,
                    size: 20,
                    color: selected ? Colors.white : context.iconColor),
                const SizedBox(width: 14),
                Tr(label,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : Colors.black)),
              ],
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
            borderRadius: BorderRadius.circular(6),
            child: InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: _openManualDialog,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.schedule,
                        size: 18, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_t('Jadwal manual', 'Manual schedule'),
                              style: const TextStyle(
                                  fontSize: 9, color: AppColors.textMuted)),
                          const SizedBox(height: 2),
                          Text(_fullText(t),
                              style: const TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const Icon(Icons.edit_outlined,
                        size: 16, color: AppColors.textMuted),
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
                          fontSize: 10, color: Color(0xFFC62828)),
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
                        color: isPast ? null : AppColors.primary)),
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
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 9, color: AppColors.textMuted)),
                  const SizedBox(height: 1),
                  Text(value,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 18, color: AppColors.textMuted),
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
              style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
          const SizedBox(height: 2),
          Text(value,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _soundPicker() {
    return Material(
      color: context.cardBg,
      borderRadius: BorderRadius.circular(6),
      elevation: 3,
      shadowColor: AppColors.shadow,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SoundSelectionScreen()),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              Icon(Icons.volume_up_outlined, size: 20),
              SizedBox(width: 14),
              Expanded(
                child: Tr('Daftar Suara',
                    style:
                        TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
              ),
              Icon(Icons.chevron_right, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Kartu riwayat aktivitas (daftar aktivitas akan tampil di sini).
  Widget _history() {
    return Container(
      width: double.infinity,
      height: 110,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(6),
        boxShadow: _cardShadow,
      ),
      child: const Tr('Belum ada aktivitas',
          style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
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
        Icon(icon, size: 26),
        const SizedBox(height: 4),
        Tr(label,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
        Tr(value,
            style: TextStyle(
                fontSize: 8,
                color: active ? AppColors.online : AppColors.textDark)),
      ],
    );
  }
}