import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/icon_badge.dart';

class DeviceDetailScreen extends StatefulWidget {
  final VoidCallback? onBack;
  const DeviceDetailScreen({super.key, this.onBack});

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  int _tab = 0; // 0 = Status, 1 = Informasi

  static const _shadow = [
    BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 3)),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: widget.onBack,
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text('Detail Perangkat',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              _deviceHeader(),
              const SizedBox(height: 20),
              _tabs(),
              const SizedBox(height: 16),
              if (_tab == 0) ..._statusTab() else ..._infoTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _deviceHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: _shadow,
      ),
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              boxShadow: _shadow,
            ),
            child: const Icon(Icons.home_outlined,
                size: 44, color: AppColors.primary),
          ),
          const Expanded(
            child: Column(
              children: [
                Text('R-001',
                    style:
                        TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, size: 6, color: AppColors.online),
                    SizedBox(width: 4),
                    Text('Online',
                        style:
                            TextStyle(fontSize: 9, color: AppColors.online)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    Widget tab(String label, int index) {
      final selected = _tab == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _tab = index),
          child: Container(
            height: 34,
            alignment: Alignment.center,
            decoration: selected
                ? const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.primary, width: 1),
                    ),
                  )
                : BoxDecoration(
                    color: const Color(0xFFE8E8E8),
                    borderRadius: BorderRadius.circular(20),
                  ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primary : Colors.black,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        tab('Status', 0),
        const SizedBox(width: 16),
        tab('Informasi', 1),
      ],
    );
  }

  List<Widget> _statusTab() {
    return [
      _infoCard(Icons.sensors, 'Sensor', 'Aktif'),
      _infoCard(Icons.tune, 'Mode Operasi', 'Deteksi Sensor'),
      _infoCard(Icons.volume_up_outlined, 'Suara yang Diputar', 'Suara Elang'),
      _infoCard(
          Icons.history, 'Waktu Operasi Terakhir', '24 sep 2026 09:25'),
      const SizedBox(height: 6),
      SizedBox(
        width: double.infinity,
        height: 46,
        child: ElevatedButton(
          onPressed: () {}, // TODO: ubah mode operasi
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: const Text('Ubah Mode Operasi',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
      ),
    ];
  }

  // Data contoh: layar tab Informasi belum ada di desain Figma.
  List<Widget> _infoTab() {
    return [
      _infoCard(Icons.qr_code_2, 'ID Perangkat', 'R-001'),
      _infoCard(Icons.wifi, 'Status Koneksi', 'Online'),
      _infoCard(Icons.person_outline, 'Pemilik', 'Pak Taufiq'),
    ];
  }

  Widget _infoCard(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: _shadow,
      ),
      child: Row(
        children: [
          IconBadge(icon: icon, radius: 16),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 10, fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              Text(value,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.link)),
            ],
          ),
        ],
      ),
    );
  }
}
