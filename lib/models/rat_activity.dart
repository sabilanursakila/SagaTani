import 'package:flutter/material.dart';

/// Status pengusiran tikus. Label ditulis Bahasa Indonesia,
/// diterjemahkan saat ditampilkan lewat L.t().
enum RepelStatus {
  berhasil('Berhasil diusir', Color(0xFF2E7D32), Color(0xFFE3F6E4)),
  proses('Sedang diusir', Color(0xFFB26A00), Color(0xFFFFF1D6)),
  gagal('Gagal diusir', Color(0xFFC62828), Color(0xFFFDE4E4));

  final String label;
  final Color fg;
  final Color bg;
  const RepelStatus(this.label, this.fg, this.bg);
}

extension RepelStatusTheme on RepelStatus {
  Color foregroundFor(BuildContext context) {
    if (Theme.of(context).brightness != Brightness.dark) return fg;
    return switch (this) {
      RepelStatus.berhasil => const Color(0xFF8BE09B),
      RepelStatus.proses => const Color(0xFFFFD180),
      RepelStatus.gagal => const Color(0xFFFF8A80),
    };
  }

  Color backgroundFor(BuildContext context) {
    if (Theme.of(context).brightness != Brightness.dark) return bg;
    return switch (this) {
      RepelStatus.berhasil => const Color(0xFF1D3828),
      RepelStatus.proses => const Color(0xFF3A301F),
      RepelStatus.gagal => const Color(0xFF3A2525),
    };
  }
}

/// Satu catatan aktivitas tikus.
class RatActivity {
  final DateTime time;
  final String location;
  final String movement;
  final String sound;
  final RepelStatus status;

  const RatActivity({
    required this.time,
    required this.location,
    required this.movement,
    required this.sound,
    required this.status,
  });
}

/// Data contoh sementara yang dipakai bersama oleh Beranda dan Riwayat.
final sampleRatActivities = <RatActivity>[
  RatActivity(
    time: DateTime(2026, 11, 7, 5, 42),
    location: 'Sawah Blok A',
    movement: 'Bergerak cepat ke arah utara',
    sound: 'Ultrasonik 22 kHz',
    status: RepelStatus.proses,
  ),
  RatActivity(
    time: DateTime(2026, 11, 7, 3, 15),
    location: 'Gudang Padi',
    movement: 'Mondar-mandir di sekitar karung',
    sound: 'Ultrasonik 25 kHz + bunyi alarm',
    status: RepelStatus.berhasil,
  ),
  RatActivity(
    time: DateTime(2026, 11, 6, 23, 8),
    location: 'Kebun Jagung',
    movement: 'Menggali di dekat pagar',
    sound: 'Ultrasonik 22 kHz',
    status: RepelStatus.gagal,
  ),
  RatActivity(
    time: DateTime(2026, 11, 6, 21, 30),
    location: 'Saluran Irigasi',
    movement: 'Bergerak lambat menyusuri tepi',
    sound: 'Ultrasonik 20 kHz',
    status: RepelStatus.berhasil,
  ),
  RatActivity(
    time: DateTime(2026, 11, 6, 19, 52),
    location: 'Lumbung',
    movement: 'Diam di sudut ruangan',
    sound: 'Bunyi alarm 85 dB',
    status: RepelStatus.berhasil,
  ),
  RatActivity(
    time: DateTime(2026, 11, 6, 2, 21),
    location: 'Sawah Blok B',
    movement: 'Berkelompok, bergerak ke barat',
    sound: 'Ultrasonik 25 kHz + bunyi alarm',
    status: RepelStatus.berhasil,
  ),
  RatActivity(
    time: DateTime(2026, 11, 5, 22, 47),
    location: 'Gudang Padi',
    movement: 'Melompat di antara tumpukan karung',
    sound: 'Ultrasonik 22 kHz',
    status: RepelStatus.gagal,
  ),
  RatActivity(
    time: DateTime(2026, 11, 5, 20, 5),
    location: 'Kebun Jagung',
    movement: 'Bergerak cepat ke arah selatan',
    sound: 'Ultrasonik 20 kHz',
    status: RepelStatus.berhasil,
  ),
  RatActivity(
    time: DateTime(2026, 11, 5, 4, 36),
    location: 'Saluran Irigasi',
    movement: 'Berenang menyeberangi saluran',
    sound: 'Bunyi alarm 85 dB',
    status: RepelStatus.berhasil,
  ),
  RatActivity(
    time: DateTime(2026, 11, 4, 23, 59),
    location: 'Sawah Blok A',
    movement: 'Mondar-mandir di pematang',
    sound: 'Ultrasonik 22 kHz',
    status: RepelStatus.berhasil,
  ),
  RatActivity(
    time: DateTime(2026, 11, 4, 1, 12),
    location: 'Lumbung',
    movement: 'Menggerogoti pintu',
    sound: 'Ultrasonik 25 kHz + bunyi alarm',
    status: RepelStatus.gagal,
  ),
  RatActivity(
    time: DateTime(2026, 11, 3, 21, 18),
    location: 'Sawah Blok B',
    movement: 'Bergerak lambat ke arah timur',
    sound: 'Ultrasonik 20 kHz',
    status: RepelStatus.berhasil,
  ),
];
