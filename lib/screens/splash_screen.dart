import '../services/auth_service.dart';
import 'main_shell.dart';
import 'dart:async';

import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../utils/l10n.dart';
import '../widgets/saga_logo.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Timer? _timer;
  late final AnimationController _introController;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _titleOffset;
  late final Animation<double> _taglineOpacity;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _logoOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0, 0.48, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.72, end: 1).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0, 0.62, curve: Curves.easeOutBack),
      ),
    );
    _titleOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.28, 0.78, curve: Curves.easeOut),
    );
    _titleOffset = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.28, 0.82, curve: Curves.easeOutCubic),
      ),
    );
    _taglineOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.55, 1, curve: Curves.easeOut),
    );

    _timer = Timer(const Duration(seconds: 3), () async {
      // Jika masih ada sesi login, langsung ke Beranda.
      final loggedIn = await AuthService.instance.restoreSession();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              loggedIn ? const MainShell() : const OnboardingScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dibangun ulang otomatis saat bahasa diganti.
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, _) => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Latar: foto sawah di assets/images/splash_bg.jpg (opsional)
            Image.asset(
              'assets/images/splash_bg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF4F93D1),
                      Color(0xFF9CC7E8),
                      Color(0xFF6BA86B),
                      Color(0xFF3E8E2F),
                    ],
                    stops: [0.0, 0.5, 0.75, 1.0],
                  ),
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.45),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _logoOpacity,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: const SagaLogo(size: 130),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FadeTransition(
                    opacity: _titleOpacity,
                    child: SlideTransition(
                      position: _titleOffset,
                      child: Text(
                        L.t('SAGA TANI'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  FadeTransition(
                    opacity: _taglineOpacity,
                    child: Text(
                      L.t('Pertanian Lebih Aman Panen Lebih Maksimal'),
                      style: const TextStyle(color: Colors.white, fontSize: 9),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 17,
                          height: 17,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.4,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          L.t('Loading...'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                color: Color(0x88000000),
                                blurRadius: 8,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
