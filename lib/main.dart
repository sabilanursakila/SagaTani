import 'package:flutter/material.dart';

import 'models/app_settings.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const SagaTaniApp());
}

class SagaTaniApp extends StatelessWidget {
  const SagaTaniApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, _) => MaterialApp(
        title: 'Saga Tani',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: AppSettings.instance.themeMode,
        home: const SplashScreen(),
      ),
    );
  }
}