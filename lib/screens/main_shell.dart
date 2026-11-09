import 'package:flutter/material.dart';

import '../widgets/app_bottom_nav.dart';
import 'device_detail_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

/// Kerangka utama: 4 halaman + menu navigasi bawah.
/// Urutan tab: 0 Beranda, 1 Detail Perangkat, 2 Akun, 3 Pengaturan.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;

  void _go(int i) => setState(() => _index = i);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onOpenDevice: () => _go(1)),
          DeviceDetailScreen(onBack: () => _go(0)),
          ProfileScreen(onBack: () => _go(0)),
          SettingsScreen(onOpenAccount: () => _go(2)),
        ],
      ),
      bottomNavigationBar: AppBottomNav(currentIndex: _index, onTap: _go),
    );
  }
}