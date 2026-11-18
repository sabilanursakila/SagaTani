import 'package:flutter/material.dart';

import '../models/perangkat.dart';
import '../theme/app_theme.dart';

/// Popup detail perangkat yang muncul setelah QR dipindai.
class DetailPerangkatSheet extends StatelessWidget {
  final Perangkat perangkat;

  /// Isi QR (misalnya PERANGKAT-001). Opsional, tampil sebagai label kecil.
  final String? kode;

  const DetailPerangkatSheet({super.key, required this.perangkat, this.kode});

  static const double _ukuranGambar = 150;

  @override
  Widget build(BuildContext context) {
    final hijau = AppColors.online;
    final hijauTua = HSLColor.fromColor(hijau).withLightness(0.22).toColor();

    // Spesifikasi dipecah per baris, tanda "•" di depan dibuang.
    final spesifikasi = perangkat.spesifikasi
        .split('\n')
        .map((e) => e.replaceFirst(RegExp(r'^[•\-*]\s*'), '').trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== Header hijau + gambar di tengah =====
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    height: 130,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [hijau, hijauTua],
                      ),
                    ),
                    child: Stack(
                      children: [
                        const Positioned(
                          top: -30,
                          left: -20,
                          child: _Lingkaran(ukuran: 110, alpha: 0.12),
                        ),
                        const Positioned(
                          top: 20,
                          right: -30,
                          child: _Lingkaran(ukuran: 130, alpha: 0.10),
                        ),
                        const Positioned(
                          bottom: -40,
                          left: 90,
                          child: _Lingkaran(ukuran: 90, alpha: 0.08),
                        ),
                        const Positioned(
                          top: 16,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: Text(
                              'Detail Perangkat',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: -_ukuranGambar / 2,
                  child: _GambarPerangkat(
                    perangkat: perangkat,
                    ukuran: _ukuranGambar,
                  ),
                ),
              ],
            ),
            SizedBox(height: _ukuranGambar / 2 + 14),

            // ===== Nama + label ID =====
            _Muncul(
              urutan: 0,
              child: Column(
                children: [
                  Text(
                    perangkat.nama,
                    textAlign: TextAlign.center,
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                  ),
                  if (kode != null) ...[
                    const SizedBox(height: 8),
                    _LabelKode(kode: kode!),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),

            // ===== Kartu Fungsi =====
            _Muncul(
              urutan: 1,
              child: _Seksi(
                icon: Icons.bolt_rounded,
                judul: 'Fungsi',
                child: Text(
                  perangkat.fungsi,
                  style: const TextStyle(fontSize: 13.5, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ===== Kartu Spesifikasi =====
            _Muncul(
              urutan: 2,
              child: _Seksi(
                icon: Icons.tune_rounded,
                judul: 'Spesifikasi',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final baris in spesifikasi)
                      _BarisSpesifikasi(teks: baris),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 18),

            // ===== Tombol Tutup =====
            _Muncul(
              urutan: 3,
              child: SizedBox(
                height: 52,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: hijau,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  icon: const Icon(Icons.close_rounded),
                  label: const Text(
                    'Tutup',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
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

/// Lingkaran dekoratif di header.
class _Lingkaran extends StatelessWidget {
  final double ukuran;
  final double alpha;
  const _Lingkaran({required this.ukuran, required this.alpha});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ukuran,
      height: ukuran,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }
}

/// Gambar perangkat di dalam lingkaran putih, membesar lembut saat muncul.
class _GambarPerangkat extends StatelessWidget {
  final Perangkat perangkat;
  final double ukuran;
  const _GambarPerangkat({required this.perangkat, required this.ukuran});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.6, end: 1.0),
      duration: const Duration(milliseconds: 550),
      curve: Curves.easeOutBack,
      builder: (context, nilai, child) =>
          Transform.scale(scale: nilai, child: child),
      child: Container(
        width: ukuran,
        height: ukuran,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: AppColors.online.withValues(alpha: 0.35),
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Image.asset(
          perangkat.gambar,
          fit: BoxFit.contain,
          // Jika gambar belum ada, tampilkan ikon cadangan.
          errorBuilder: (_, __, ___) =>
              Icon(perangkat.ikon, size: 64, color: AppColors.online),
        ),
      ),
    );
  }
}

/// Label kecil berisi ID perangkat.
class _LabelKode extends StatelessWidget {
  final String kode;
  const _LabelKode({required this.kode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.online.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.qr_code_2_rounded, size: 16, color: AppColors.online),
          const SizedBox(width: 6),
          Text(
            kode,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: AppColors.online,
            ),
          ),
        ],
      ),
    );
  }
}

/// Kartu dengan ikon + judul + isi (dipakai untuk Fungsi dan Spesifikasi).
class _Seksi extends StatelessWidget {
  final IconData icon;
  final String judul;
  final Widget child;
  const _Seksi({
    required this.icon,
    required this.judul,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.online.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.online.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.online.withValues(alpha: 0.15),
                ),
                child: Icon(icon, size: 19, color: AppColors.online),
              ),
              const SizedBox(width: 10),
              Text(
                judul,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.online,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// Satu baris spesifikasi dengan tanda centang.
class _BarisSpesifikasi extends StatelessWidget {
  final String teks;
  const _BarisSpesifikasi({required this.teks});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(
              Icons.check_circle_rounded,
              size: 18,
              color: AppColors.online,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              teks,
              style: const TextStyle(fontSize: 13.5, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Animasi muncul: memudar masuk sambil naik dari bawah.
/// [urutan] makin besar = muncul makin belakangan.
class _Muncul extends StatelessWidget {
  final int urutan;
  final Widget child;
  const _Muncul({required this.urutan, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + urutan * 120),
      curve: Curves.easeOutCubic,
      builder: (context, nilai, child) => Opacity(
        opacity: nilai,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - nilai)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}