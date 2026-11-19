import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';
import 'device_detail_screen.dart';
import 'device_list_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'riwayat_screen.dart';
import 'scan_screen.dart';
import 'settings_screen.dart';

/// Kerangka utama: Beranda, daftar Perangkat, Riwayat, dan Pengaturan.
/// Urutan tab: 0 Beranda, 1 Perangkat, 2 Riwayat, 3 Pengaturan.
/// Tombol kamera di tengah membuka halaman scan (bukan tab).
///
/// Tombol kembali perangkat di dalam halaman detail menutup halaman tersebut.
/// Tombol kembali HP pada kerangka utama berpindah ke tab sebelumnya.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  /// Riwayat tab yang pernah dibuka (yang terakhir = tab sebelumnya).
  final List<int> _riwayatNavigasi = [];

  /// Pindah ke tab [i] sambil mencatat tab sekarang ke riwayat.
  void _go(int i) {
    if (i == _index) return;
    setState(() {
      _riwayatNavigasi.remove(i); // hindari tumpukan ganda
      _riwayatNavigasi.add(_index);
      _index = i;
    });
  }

  /// Kembali ke tab sebelumnya; jika riwayat kosong, ke Beranda.
  void _kembali() {
    setState(() {
      if (_riwayatNavigasi.isNotEmpty) {
        _index = _riwayatNavigasi.removeLast();
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

  void _openDeviceDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const DeviceDetailScreen(),
      ),
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Hanya boleh keluar aplikasi jika sudah di Beranda dan riwayat kosong.
      canPop: _riwayatNavigasi.isEmpty && _index == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _kembali();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: [
            HomeScreen(onOpenDevice: _openDeviceDetail),
            DeviceListScreen(onOpenDevice: _openDeviceDetail),
            const RiwayatScreen(),
            SettingsScreen(onOpenAccount: _openProfile),
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
