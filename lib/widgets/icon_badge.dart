import 'package:flutter/material.dart';

/// Lingkaran berisi ikon (atau gambar, jika file gambarnya ada).
/// Dipakai di menu Profil, Pengaturan, dan Detail Perangkat.
class IconBadge extends StatelessWidget {
  final IconData icon;
  final String? image; // contoh: 'assets/images/ikon_akun.png' (opsional)
  final double radius;

  const IconBadge({
    super.key,
    required this.icon,
    this.image,
    this.radius = 17,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Icon(icon, size: radius * 1.1, color: Colors.black87);
    return CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFD9D9D9),
      child: image == null
          ? fallback
          : ClipOval(
              child: Image.asset(
                image!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => fallback,
              ),
            ),
    );
  }
}
