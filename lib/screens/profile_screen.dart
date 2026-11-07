import 'package:flutter/material.dart';

import '../models/user_session.dart';
import '../theme/app_theme.dart';
import '../widgets/gradient_button.dart';
import '../widgets/icon_badge.dart';
import '../widgets/saga_logo.dart';
import 'login_screen.dart';

class _MenuItem {
  final IconData icon; // ikon cadangan jika gambar belum ada
  final String? image; // gambar di folder assets/images/ (opsional)
  final String title;
  final String? value; // keterangan di sisi kanan (opsional)
  const _MenuItem(this.icon, this.title, {this.image, this.value});
}

class _MenuSection {
  final String label;
  final List<_MenuItem> items;
  const _MenuSection(this.label, this.items);
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _pageBg = Color(0xFFF5F7F5);

  static const _sections = [
    _MenuSection('Akun', [
      _MenuItem(Icons.account_circle_outlined, 'Informasi Akun',
          image: 'assets/images/ikon_akun.png'),
      _MenuItem(Icons.lock_outline, 'Kata Sandi & Keamanan'),
      _MenuItem(Icons.notifications_none, 'Notifikasi',
          image: 'assets/images/ikon_notifikasi.png'),
      _MenuItem(Icons.language, 'Bahasa',
          image: 'assets/images/ikon_bahasa.png', value: 'Indonesia'),
    ]),
    _MenuSection('Preferensi', [
      _MenuItem(Icons.sensors, 'Sensor',
          image: 'assets/images/ikon_sensor.png'),
      _MenuItem(Icons.brightness_6_outlined, 'Tema', value: 'Terang'),
      _MenuItem(Icons.info_outline, 'Tentang Aplikasi',
          image: 'assets/images/ikon_tentang.png', value: 'Versi 1.0.0'),
    ]),
    _MenuSection('Dukungan', [
      _MenuItem(Icons.help_outline, 'Pusat Bantuan'),
    ]),
  ];

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
              UserSession.instance.logout();
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
      backgroundColor: _pageBg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _header(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _userCard(),
                  const SizedBox(height: 22),
                  for (final section in _sections) ...[
                    _sectionLabel(section.label),
                    _sectionCard(section.items),
                    const SizedBox(height: 22),
                  ],
                  GradientButton(
                    label: 'Keluar',
                    onPressed: () => _confirmLogout(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Header hijau dengan tiga lapisan gelombang (makin ke bawah makin terang).
  Widget _header() {
    return Stack(
      children: [
        // Lapisan paling terang (belakang)
        Positioned.fill(
          child: ClipPath(
            clipper: const _LayerWaveClipper(10, -6, 24, 2),
            child: const ColoredBox(color: Color(0xFFE9FFEA)),
          ),
        ),
        // Lapisan tengah
        Positioned.fill(
          child: ClipPath(
            clipper: const _LayerWaveClipper(26, 4, 42, 16),
            child: const ColoredBox(color: Color(0xFFC9FACB)),
          ),
        ),
        // Lapisan paling pekat (depan)
        Positioned.fill(
          child: ClipPath(
            clipper: const _LayerWaveClipper(44, 20, 60, 34),
            child: const ColoredBox(color: Color(0xFFA6F5A9)),
          ),
        ),
        // Isi header: logo dan nama aplikasi
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 66),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(
                children: const [
                  SagaLogo(size: 62),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Saga Tani',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textDark)),
                        SizedBox(height: 2),
                        Text('Solusi para petani',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Kartu data pengguna: foto, nama, email / no. HP, dan label peran.
  Widget _userCard() {
    return AnimatedBuilder(
      animation: UserSession.instance,
      builder: (context, _) => Material(
        color: Colors.white,
        elevation: 2,
        shadowColor: AppColors.shadow,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xFFD9D9D9),
                child: Icon(Icons.person, size: 34, color: Colors.black87),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(UserSession.instance.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(UserSession.instance.contact,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.textMuted)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 3),
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
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(text,
            style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted)),
      );

  /// Satu kelompok menu dalam kartu putih, dipisah garis tipis.
  Widget _sectionCard(List<_MenuItem> items) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shadowColor: AppColors.shadow,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _tile(items[i]),
            if (i != items.length - 1)
              const Divider(
                height: 1,
                thickness: 1,
                indent: 62,
                endIndent: 14,
                color: Color(0xFFEEF0EE),
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            IconBadge(icon: item.icon, image: item.image, radius: 16),
            const SizedBox(width: 14),
            Expanded(
              child: Text(item.title,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w500)),
            ),
            if (item.value != null) ...[
              Text(item.value!,
                  style: const TextStyle(
                      fontSize: 9, color: AppColors.textMuted)),
              const SizedBox(width: 4),
            ],
            const Icon(Icons.chevron_right,
                size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

/// Potongan gelombang untuk satu lapisan header.
/// Empat angka = jarak tepi bawah dari dasar header: kiri, kontrol 1,
/// kontrol 2, dan kanan (membentuk gelombang berbentuk huruf S).
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