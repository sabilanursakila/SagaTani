import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/saga_logo.dart';
import 'onboarding_screen.dart';
import '../widgets/tr.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              children: const [
                SagaLogo(size: 130),
                SizedBox(height: 12),
                Text(
                  'SAGA TANI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 3,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Pertanian Lebih Aman Panen Lebih Maksimal',
                  style: TextStyle(color: Colors.white, fontSize: 9),
                ),
              ],
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 36,
            child: Text(
              'Loading...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}