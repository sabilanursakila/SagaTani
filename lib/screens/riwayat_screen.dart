import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models/activity_store.dart';
import '../models/app_settings.dart';
import '../models/rat_activity.dart';
import '../theme/app_theme.dart';
import '../utils/l10n.dart';
import '../widgets/tr.dart';
import 'activity_detail_screen.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
    'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
  ];

  final _searchCtrl = TextEditingController();
  String _query = '';
  RepelStatus? _statusFilter; // null = semua

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ---------- Format ----------

  String _two(int n) => n.toString().padLeft(2, '0');

  String _dateText(DateTime t) =>
      '${t.day} ${L.t(_months[t.month - 1])} ${t.year}';

  String _timeText(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}';

  // ---------- Data terfilter ----------

  List<RatActivity> get _filtered {
    final q = _query.trim().toLowerCase();
    return ActivityStore.instance.items.where((a) {
      if (_statusFilter != null && a.status != _statusFilter) return false;
      if (q.isEmpty) return true;
      // Dicari pada teks yang sedang tampil (sesuai bahasa terpilih).
      final haystack = [
        _dateText(a.time),
        _timeText(a.time),
        L.t(a.location),
        L.t(a.movement),
        L.t(a.sound),
        L.t(a.status.label),
      ].join(' ').toLowerCase();
      return haystack.contains(q);
    }).toList();
  }

  // ---------- Download dataset ----------

  String _csvCell(String v) => '"${v.replaceAll('"', '""')}"';

  String _buildCsv(List<RatActivity> rows) {
    final b = StringBuffer();
    b.writeln(L.t('Tanggal,Waktu,Lokasi,Pergerakan,Suara,Status Pengusiran'));
    for (final a in rows) {
      b.writeln([
        _csvCell(_dateText(a.time)),
        _csvCell(_timeText(a.time)),
        _csvCell(L.t(a.location)),
        _csvCell(L.t(a.movement)),
        _csvCell(L.t(a.sound)),
        _csvCell(L.t(a.status.label)),
      ].join(','));
    }
    return b.toString();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _download() async {
    final rows = _filtered;
    if (rows.isEmpty) {
      _snack(L.t('Tidak ada data untuk diunduh.'));
      return;
    }
    try {
      final now = DateTime.now();
      final stamp = '${now.year}${_two(now.month)}${_two(now.day)}_'
          '${_two(now.hour)}${_two(now.minute)}';
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/riwayat_tikus_$stamp.csv');
      // BOM di depan agar Excel membaca UTF-8 dengan benar.
      await file.writeAsString('\uFEFF${_buildCsv(rows)}');
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'text/csv')],
        subject: L.t('Dataset riwayat aktivitas tikus'),
      );
    } catch (e) {
      if (!mounted) return;
      _snack('${L.t('Gagal menyiapkan file')}: $e');
    }
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    // Dibangun ulang otomatis saat bahasa / tema diganti.
    return AnimatedBuilder(
      animation:
          Listenable.merge([AppSettings.instance, ActivityStore.instance]),
      builder: (context, _) {
        final rows = _filtered;
        return Scaffold(
          backgroundColor: context.pageBg,
          body: Column(
            children: [
              _header(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _searchRow(),
              ),
              const SizedBox(height: 10),
              _filterChips(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                      '${rows.length} ${L.t('aktivitas ditemukan')}',
                      style: TextStyle(fontSize: 12, color: context.textSub)),
                ),
              ),
              Expanded(
                child: rows.isEmpty
                    ? Center(
                        child: Tr('Tidak ada riwayat yang cocok.',
                            style: TextStyle(
                                fontSize: 12, color: context.textSub)),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: rows.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (_, i) => _activityCard(rows[i]),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Header hijau bergelombang dengan judul halaman.
  Widget _header() {
    final dark = context.isDark;
    return Stack(
      children: [
        Positioned.fill(
          child: ClipPath(
            clipper: const _LayerWaveClipper(10, -6, 24, 2),
            child: ColoredBox(
                color: dark
                    ? const Color(0xFF14231B)
                    : const Color(0xFFE9FFEA)),
          ),
        ),
        Positioned.fill(
          child: ClipPath(
            clipper: const _LayerWaveClipper(22, 4, 34, 12),
            child: ColoredBox(
                color: dark
                    ? const Color(0xFF193024)
                    : const Color(0xFFC9FACB)),
          ),
        ),
        Positioned.fill(
          child: ClipPath(
            clipper: const _LayerWaveClipper(34, 16, 46, 24),
            child: ColoredBox(
                color: dark
                    ? const Color(0xFF1F3D2D)
                    : const Color(0xFFA6F5A9)),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 44),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(L.t('Riwayat'),
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: context.textMain)),
                  const SizedBox(height: 2),
                  Text(L.t('Aktivitas tikus yang terdeteksi'),
                      style: TextStyle(
                          fontSize: 12, color: context.textSub)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _searchRow() {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: context.cardBg,
            elevation: 2,
            shadowColor: AppColors.shadow,
            borderRadius: BorderRadius.circular(12),
            child: TextField(
              controller: _searchCtrl,
              style: TextStyle(fontSize: 13, color: context.textMain),
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: L.t('Cari tanggal, lokasi, suara, status...'),
                hintStyle: TextStyle(fontSize: 12, color: context.textSub),
                prefixIcon: Icon(Icons.search,
                    size: 20, color: context.textSub),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.close,
                            size: 18, color: context.textSub),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Tooltip(
          message: L.t('Unduh dataset (CSV)'),
          child: Material(
            color: context.isDark ? AppPalette.darkAccent : AppColors.primary,
            elevation: 2,
            shadowColor: AppColors.shadow,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _download,
              child: SizedBox(
                width: 46,
                height: 46,
                child: Icon(
                  Icons.download_rounded,
                  size: 22,
                  color: context.isDark ? AppPalette.darkBg : Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _filterChips() {
    Widget chip(String label, RepelStatus? value) {
      final selected = _statusFilter == value;
      return Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(L.t(label),
              style: TextStyle(
                  fontSize: 11, color: selected ? Colors.white : null)),
          selected: selected,
          showCheckmark: false,
          selectedColor: AppColors.primary,
          backgroundColor: context.cardBg,
          side: BorderSide.none,
          onSelected: (_) => setState(() => _statusFilter = value),
        ),
      );
    }

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          chip('Semua', null),
          for (final s in RepelStatus.values) chip(s.label, s),
        ],
      ),
    );
  }

  Widget _activityCard(RatActivity a) {
    return Material(
      color: context.cardBg,
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: context.lineColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ActivityDetailScreen(activity: a),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.place_outlined,
                      size: 16, color: context.accent),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Tr(
                      a.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: a.status.backgroundFor(context),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      L.t(a.status.label),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: a.status.foregroundFor(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 12, color: context.textSub),
                  const SizedBox(width: 5),
                  Text(
                    _dateText(a.time),
                    style: TextStyle(
                      fontSize: 11,
                      color: context.textSub,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.access_time,
                      size: 12, color: context.textSub),
                  const SizedBox(width: 5),
                  Text(
                    _timeText(a.time),
                    style: TextStyle(
                      fontSize: 11,
                      color: context.textSub,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1, color: context.lineColor),
              ),
              _infoRow(Icons.directions_run, 'Pergerakan', a.movement),
              const SizedBox(height: 8),
              _infoRow(Icons.volume_up_outlined, 'Suara keluar', a.sound),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: context.textSub),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Tr(label,
                  style: TextStyle(fontSize: 11, color: context.textSub)),
              const SizedBox(height: 1),
              Tr(value,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ],
    );
  }
}

/// Potongan gelombang untuk satu lapisan header.
class _LayerWaveClipper extends CustomClipper<Path> {
  final double left;
  final double control1;
  final double control2;
  final double right;
  const _LayerWaveClipper(this.left, this.control1, this.control2, this.right);

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()..lineTo(0, h - left);
    path.cubicTo(w * 0.3, h - control1, w * 0.7, h - control2, w, h - right);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _LayerWaveClipper old) =>
      old.left != left ||
      old.control1 != control1 ||
      old.control2 != control2 ||
      old.right != right;
}