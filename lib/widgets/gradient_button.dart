import 'package:flutter/material.dart';

/// Tombol hijau bergradasi berbentuk pil, gayanya sama dengan tombol
/// LANJUT di halaman welcome (ukuran lebih kecil).
class GradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const GradientButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.width = 170,
    this.height = 40,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(height / 2);
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF58A046), Color(0xFF2D6A2F)],
          ),
          borderRadius: radius,
          boxShadow: const [
            BoxShadow(
                color: Color(0x40245A28), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: radius,
            onTap: onPressed,
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}