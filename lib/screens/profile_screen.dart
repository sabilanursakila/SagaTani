import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../widgets/icon_badge.dart';
import '../widgets/saga_logo.dart';
import 'login_screen.dart';

class _MenuItem {
  final IconData icon; // ikon cadangan jika gambar belum ada
  final String image; // gambar di folder assets/images/
  final String title;
  final String subtitle;
  const _MenuItem(this.icon, this.image, this.title, this.subtitle);
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _items = [
    _MenuItem(Icons.account_circle_outlined, 'assets/images/ikon_akun.png',
        'Informasi Akun', 'Lihat dan ubah data profil'),
    _MenuItem(Icons.notifications_none, 'assets/images/ikon_notifikasi.png',
        'Notifikasi', 'Pengaturan notifikasi aplikasi'),
    _MenuItem(Icons.sensors, 'assets/images/ikon_sensor.png', 'Sensor',
        'Konfigurasi dan sensitivitas Sensor'),
    _MenuItem(Icons.language, 'assets/images/ikon_bahasa.png', 'Bahasa',
        'Indonesia'),
    _MenuItem(Icons.info_outline, 'assets/images/ikon_tentang.png',
        'Tentang Aplikasi', 'Versi 1.0.0'),
  ];

  static const _headerColor = Color(0xFFE8F8E8);

  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Keluar dari akun?', style: TextStyle(fontSize: 16)),
        content: const Text('Kamu perlu masuk lagi untuk memakai aplikasi.',
            style: TextStyle(fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Keluar',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(context),
            const SizedBox(height: 8),
            _userInfo(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  _menuCard(),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: OutlinedButton(
                      onPressed: () => _confirmLogout(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: AppColors.online),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text('Keluar',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        width: double.infinity,
        color: _headerColor,
        padding: const EdgeInsets.only(bottom: 36),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 12, 0),
            child: Row(
              children: [
                const SagaLogo(size: 46),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Saga Tani',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700)),
                      Text('Solusi para petani',
                          style: TextStyle(
                              fontSize: 10, color: AppColors.textMuted)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {}, // TODO: notifikasi
                  icon: const Icon(Icons.notifications_none, size: 26),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _userInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFFD9D9D9),
            child: Icon(Icons.person, size: 44, color: Colors.black87),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Username',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                const Text('Username123@gmail.com',
                    style:
                        TextStyle(fontSize: 10, color: AppColors.textMuted)),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Pengguna',
                      style: TextStyle(color: Colors.white, fontSize: 9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
              color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < _items.length; i++) ...[
            _tile(_items[i]),
            if (i != _items.length - 1)
              const Divider(
                height: 3,
                thickness: 3,
                indent: 10,
                endIndent: 10,
                color: Color(0xFFEFEFEF),
              ),
          ],
        ],
      ),
    );
  }

  Widget _tile(_MenuItem item) {
    return InkWell(
      onTap: () {}, // TODO: buka halaman terkait
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            IconBadge(icon: item.icon, image: item.image),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(item.subtitle,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      ),
    );
  }
}

/// Potongan bergelombang di bagian bawah header hijau muda.
class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..lineTo(0, size.height - 28);
    path.quadraticBezierTo(
        size.width * 0.28, size.height + 6, size.width * 0.55, size.height - 22);
    path.quadraticBezierTo(
        size.width * 0.82, size.height - 48, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
