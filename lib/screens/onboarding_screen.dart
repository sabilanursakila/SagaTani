import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../widgets/tr.dart';

class _OnboardPage {
  final String image;
  final IconData fallbackIcon; // dipakai jika file gambar belum ada
  final String title;
  final String description;
  const _OnboardPage(this.image, this.fallbackIcon, this.title, this.description);
}

/// 3 halaman perkenalan setelah splash screen.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _bg = Color(0xFFF9FAEA);
  static const _titleColor = Color(0xFF1F4D2B);
  static const _dotActive = Color(0xFF2E7D32);
  static const _dotInactive = Color(0xFFC9DDB5);

  static const _pages = [
    _OnboardPage(
      'assets/images/onboarding_1.png',
      Icons.sensors,
      'Pantau Hama & Kondisi',
      'Solusi cerdas untuk melindungi lahan pertanian Anda secara real-time.',
    ),
    _OnboardPage(
      'assets/images/onboarding_2.png',
      Icons.insights,
      'Solusi Pertanian',
      'Kelola aktivitas dan dapatkan rekomendasi terbaik untuk hasil panen Anda.',
    ),
    _OnboardPage(
      'assets/images/onboarding_3.png',
      Icons.agriculture,
      'Bersama Saga Tani,\nPanen Melimpah!',
      'Mari berkolaborasi demi hasil tani yang lebih maksimal.',
    ),
  ];

  final _controller = PageController();
  int _page = 0;

  bool get _isLast => _page == _pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
    );
  }

  void _goLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _goRegister() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: Align(
                alignment: Alignment.centerRight,
                child: _isLast
                    ? null
                    : TextButton(
                        onPressed: _goLogin,
                        child: const Text('Lewati',
                            style: TextStyle(
                                color: Color(0xFF3E7D4F), fontSize: 13)),
                      ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) => _pageContent(_pages[i]),
              ),
            ),
            _dots(),
            const SizedBox(height: 28),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: _isLast ? _lastButtons() : _nextButton(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _pageContent(_OnboardPage p) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                p.image,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  width: 230,
                  height: 230,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFD6E8BF),
                  ),
                  child: Icon(p.fallbackIcon,
                      size: 100, color: AppColors.primary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            p.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: _titleColor,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            p.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF3A3A3A),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _dots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (i) {
        final active = i == _page;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? _dotActive : _dotInactive,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  Widget _nextButton() {
    return Center(
      child: Container(
        width: 220,
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF58A046), Color(0xFF2D6A2F)],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Color(0x40245A28), blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(25),
            onTap: _next,
            child: const Center(
              child: Text(
                'LANJUT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _lastButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: _goRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text('Daftar Akun Baru',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: _goLogin,
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
            ),
            child: const Text('Masuk',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}