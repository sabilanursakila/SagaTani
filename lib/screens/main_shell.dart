import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';
import 'device_detail_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'scan_screen.dart';
import 'settings_screen.dart';

/// Kerangka utama: 4 halaman + menu navigasi bawah.
/// Urutan tab: 0 Beranda, 1 Detail Perangkat, 2 Akun, 3 Pengaturan.
/// Tombol kamera di tengah membuka halaman scan (bukan tab).
///
/// Tombol kembali di HP (dan panah kembali di layar) membawa pengguna
/// ke tab sebelumnya. Aplikasi baru tertutup jika sudah di Beranda
/// dan tidak ada riwayat lagi.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  /// Riwayat tab yang pernah dibuka (yang terakhir = tab sebelumnya).
  final List<int> _riwayat = [];

  /// Pindah ke tab [i] sambil mencatat tab sekarang ke riwayat.
  void _go(int i) {
    if (i == _index) return;
    setState(() {
      _riwayat.remove(i); // hindari tumpukan ganda
      _riwayat.add(_index);
      _index = i;
    });
  }

  /// Kembali ke tab sebelumnya; jika riwayat kosong, ke Beranda.
  void _kembali() {
    setState(() {
      if (_riwayat.isNotEmpty) {
        _index = _riwayat.removeLast();
      } else {
        _index = 0;
      }
    });
  }

  void _openScan() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScanScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Hanya boleh keluar aplikasi jika sudah di Beranda dan riwayat kosong.
      canPop: _riwayat.isEmpty && _index == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _kembali();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            HomeScreen(onOpenDevice: () => _go(1)),
            DeviceDetailScreen(onBack: _kembali),
            ProfileScreen(onBack: _kembali),
            SettingsScreen(onOpenAccount: () => _go(2)),
          ],
        ),
        bottomNavigationBar: AppBottomNav(
          currentIndex: _index,
          onTap: _go,
          onScanTap: _openScan,
        ),
      ),
    );
  }
}