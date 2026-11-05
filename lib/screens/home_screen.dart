import 'package:flutter/material.dart';

import '../models/user_session.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onOpenDevice;
  const HomeScreen({super.key, this.onOpenDevice});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _mode = 1; // 0 = Terjadwal, 1 = Manual

  static const _cardShadow = [
    BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 3)),
  ];

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
              const SizedBox(height: 16),
              _sectionTitle('Ringkasan Hari Ini'),
              _summary(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return AnimatedBuilder(
      animation: UserSession.instance,
      builder: (context, _) {
        final user = UserSession.instance;
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
                  Text('Halo, ${user.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  const Text('Petani Sawah Sejahtera',
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
                Text('Perangkat Aktif',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
                Text('R-001',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.circle, size: 6, color: Color(0xFF4CD964)),
                    SizedBox(width: 4),
                    Text('Online',
                        style: TextStyle(
                            color: Color(0xFF4CD964), fontSize: 9)),
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
        child: Text(text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      );

  Widget _systemStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: _cardShadow,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatusItem(
              icon: Icons.sensors, label: 'Sensor', value: 'Aktif', active: true),
          _StatusItem(
              icon: Icons.volume_up_outlined, label: 'Suara', value: 'Berjalan'),
          _StatusItem(
              icon: Icons.phonelink_ring, label: 'Status', value: 'Terhubung'),
        ],
      ),
    );
  }

  Widget _modeSelector() {
    Widget item(int index, IconData icon, String label) {
      final selected = _mode == index;
      return GestureDetector(
        onTap: () => setState(() => _mode = index),
        child: Container(
          width: 76,
          height: 62,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: _cardShadow,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 20, color: selected ? Colors.white : Colors.black),
              const SizedBox(height: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : Colors.black)),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        item(0, Icons.calendar_month_outlined, 'Terjadwal'),
        const SizedBox(width: 12),
        item(1, Icons.smartphone, 'Manual'),
      ],
    );
  }

  Widget _summary() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Expanded(
          child: _SummaryCard(
              title: 'Aktivitas Deteksi', value: '5', unit: 'Kali', trend: '67%'),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
              title: 'Suara Diputar', value: '12', unit: 'Kali', trend: '58%'),
        ),
        SizedBox(width: 4),
        Icon(Icons.chevron_right, size: 22),
      ],
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
      children: [
        Icon(icon, size: 26),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
        Text(value,
            style: TextStyle(
                fontSize: 8,
                color: active ? AppColors.online : AppColors.textDark)),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final String trend;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.unit,
    required this.trend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
              color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(width: 3),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(unit, style: const TextStyle(fontSize: 9)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.arrow_upward, size: 12, color: AppColors.online),
              const SizedBox(width: 2),
              Text(trend,
                  style: const TextStyle(
                      fontSize: 9,
                      color: AppColors.online,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}