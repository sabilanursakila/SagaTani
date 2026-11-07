import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../theme/app_theme.dart';

/// Status pengusiran tikus.
enum RepelStatus {
  berhasil('Berhasil diusir', Color(0xFF2E7D32), Color(0xFFE3F6E4)),
  proses('Sedang diusir', Color(0xFFB26A00), Color(0xFFFFF1D6)),
  gagal('Gagal diusir', Color(0xFFC62828), Color(0xFFFDE4E4));

  final String label;
  final Color fg;
  final Color bg;
  const RepelStatus(this.label, this.fg, this.bg);
}

/// Satu catatan aktivitas tikus.
class RatActivity {
  final DateTime time;
  final String location;
  final String movement; // pergerakan tikus
  final String sound; // suara yang dikeluarkan alat
  final RepelStatus status;
  const RatActivity({
    required this.time,
    required this.location,
    required this.movement,
    required this.sound,
    required this.status,
  });
}

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  static const _pageBg = Color(0xFFF5F7F5);

  // TODO: ganti dengan data asli dari sensor / database.
  static final List<RatActivity> _data = [
    RatActivity(
        time: DateTime(2026, 11, 7, 5, 42),
        location: 'Sawah Blok A',
        movement: 'Bergerak cepat ke arah utara',
        sound: 'Ultrasonik 22 kHz',
        status: RepelStatus.proses),
    RatActivity(
        time: DateTime(2026, 11, 7, 3, 15),
        location: 'Gudang Padi',
        movement: 'Mondar-mandir di sekitar karung',
        sound: 'Ultrasonik 25 kHz + bunyi alarm',
        status: RepelStatus.berhasil),
    RatActivity(
        time: DateTime(2026, 11, 6, 23, 8),
        location: 'Kebun Jagung',
        movement: 'Menggali di dekat pagar',
        sound: 'Ultrasonik 22 kHz',
        status: RepelStatus.gagal),
    RatActivity(
        time: DateTime(2026, 11, 6, 21, 30),
        location: 'Saluran Irigasi',
        movement: 'Bergerak lambat menyusuri tepi',
        sound: 'Ultrasonik 20 kHz',
        status: RepelStatus.berhasil),
    RatActivity(
        time: DateTime(2026, 11, 6, 19, 52),
        location: 'Lumbung',
        movement: 'Diam di sudut ruangan',
        sound: 'Bunyi alarm 85 dB',
        status: RepelStatus.berhasil),
    RatActivity(
        time: DateTime(2026, 11, 6, 2, 21),
        location: 'Sawah Blok B',
        movement: 'Berkelompok, bergerak ke barat',
        sound: 'Ultrasonik 25 kHz + bunyi alarm',
        status: RepelStatus.berhasil),
    RatActivity(
        time: DateTime(2026, 11, 5, 22, 47),
        location: 'Gudang Padi',
        movement: 'Melompat di antara tumpukan karung',
        sound: 'Ultrasonik 22 kHz',
        status: RepelStatus.gagal),
    RatActivity(
        time: DateTime(2026, 11, 5, 20, 5),
        location: 'Kebun Jagung',
        movement: 'Bergerak cepat ke arah selatan',
        sound: 'Ultrasonik 20 kHz',
        status: RepelStatus.berhasil),
    RatActivity(
        time: DateTime(2026, 11, 5, 4, 36),
        location: 'Saluran Irigasi',
        movement: 'Berenang menyeberangi saluran',
        sound: 'Bunyi alarm 85 dB',
        status: RepelStatus.berhasil),
    RatActivity(
        time: DateTime(2026, 11, 4, 23, 59),
        location: 'Sawah Blok A',
        movement: 'Mondar-mandir di pematang',
        sound: 'Ultrasonik 22 kHz',
        status: RepelStatus.berhasil),
    RatActivity(
        time: DateTime(2026, 11, 4, 1, 12),
        location: 'Lumbung',
        movement: 'Menggerogoti pintu',
        sound: 'Ultrasonik 25 kHz + bunyi alarm',
        status: RepelStatus.gagal),
    RatActivity(
        time: DateTime(2026, 11, 3, 21, 18),
        location: 'Sawah Blok B',
        movement: 'Bergerak lambat ke arah timur',
        sound: 'Ultrasonik 20 kHz',
        status: RepelStatus.berhasil),
  ];

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

  String _dateText(DateTime t) => '${t.day} ${_months[t.month - 1]} ${t.year}';

  String _timeText(DateTime t) => '${_two(t.hour)}:${_two(t.minute)}';

  // ---------- Data terfilter ----------

  List<RatActivity> get _filtered {
    final q = _query.trim().toLowerCase();
    return _data.where((a) {
      if (_statusFilter != null && a.status != _statusFilter) return false;
      if (q.isEmpty) return true;
      final haystack = [
        _dateText(a.time),
        _timeText(a.time),
        a.location,
        a.movement,
        a.sound,
        a.status.label,
      ].join(' ').toLowerCase();
      return haystack.contains(q);
    }).toList();
  }

  // ---------- Download dataset ----------

  String _csvCell(String v) => '"${v.replaceAll('"', '""')}"';

  String _buildCsv(List<RatActivity> rows) {
    final b = StringBuffer();
    b.writeln('Tanggal,Waktu,Lokasi,Pergerakan,Suara,Status Pengusiran');
    for (final a in rows) {
      b.writeln([
        _csvCell(_dateText(a.time)),
        _csvCell(_timeText(a.time)),
        _csvCell(a.location),
        _csvCell(a.movement),
        _csvCell(a.sound),
        _csvCell(a.status.label),
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
      _snack('Tidak ada data untuk diunduh.');
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
        subject: 'Dataset riwayat aktivitas tikus',
      );
    } catch (e) {
      _snack('Gagal menyiapkan file: $e');
    }
  }

  // ---------- UI ----------

  @override
  Widget build(BuildContext context) {
    final rows = _filtered;
    return Scaffold(
      backgroundColor: _pageBg,
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
              child: Text('${rows.length} aktivitas ditemukan',
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textMuted)),
            ),
          ),
          Expanded(
            child: rows.isEmpty
                ? const Center(
                    child: Text('Tidak ada riwayat yang cocok.',
                        style: TextStyle(
                            fontSize: 12, color: AppColors.textMuted)),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: rows.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _activityCard(rows[i]),
                  ),
          ),
        ],
      ),
    );
  }

  /// Header hijau bergelombang dengan judul halaman.
  Widget _header() {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipPath(
            clipper: const _LayerWaveClipper(10, -6, 24, 2),
            child: const ColoredBox(color: Color(0xFFE9FFEA)),
          ),
        ),
        Positioned.fill(
          child: ClipPath(
            clipper: const _LayerWaveClipper(22, 4, 34, 12),
            child: const ColoredBox(color: Color(0xFFC9FACB)),
          ),
        ),
        Positioned.fill(
          child: ClipPath(
            clipper: const _LayerWaveClipper(34, 16, 46, 24),
            child: const ColoredBox(color: Color(0xFFA6F5A9)),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 44),
          child: SafeArea(
            bottom: false,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(20, 22, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Riwayat',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark)),
                  SizedBox(height: 2),
                  Text('Aktivitas tikus yang terdeteksi',
                      style: TextStyle(
                          fontSize: 12, color: AppColors.textMuted)),
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
            color: Colors.white,
            elevation: 2,
            shadowColor: AppColors.shadow,
            borderRadius: BorderRadius.circular(12),
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(fontSize: 12),
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Cari tanggal, lokasi, suara, status...',
                hintStyle: const TextStyle(
                    fontSize: 11, color: AppColors.textMuted),
                prefixIcon: const Icon(Icons.search,
                    size: 20, color: AppColors.textMuted),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close,
                            size: 18, color: AppColors.textMuted),
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
          message: 'Unduh dataset (CSV)',
          child: Material(
            color: AppColors.primary,
            elevation: 2,
            shadowColor: AppColors.shadow,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _download,
              child: const SizedBox(
                width: 46,
                height: 46,
                child: Icon(Icons.download_rounded,
                    size: 22, color: Colors.white),
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
          label: Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: selected ? Colors.white : AppColors.textDark)),
          selected: selected,
          showCheckmark: false,
          selectedColor: AppColors.primary,
          backgroundColor: Colors.white,
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
      color: Colors.white,
      elevation: 2,
      shadowColor: AppColors.shadow,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.place_outlined,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(a.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700)),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: a.status.bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(a.status.label,
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: a.status.fg)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined,
                    size: 12, color: AppColors.textMuted),
                const SizedBox(width: 5),
                Text(_dateText(a.time),
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textMuted)),
                const SizedBox(width: 12),
                const Icon(Icons.access_time,
                    size: 12, color: AppColors.textMuted),
                const SizedBox(width: 5),
                Text(_timeText(a.time),
                    style: const TextStyle(
                        fontSize: 10, color: AppColors.textMuted)),
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Divider(height: 1, color: Color(0xFFEEF0EE)),
            ),
            _infoRow(Icons.directions_run, 'Pergerakan', a.movement),
            const SizedBox(height: 8),
            _infoRow(Icons.volume_up_outlined, 'Suara keluar', a.sound),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 8),
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
                      fontSize: 11, fontWeight: FontWeight.w500)),
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