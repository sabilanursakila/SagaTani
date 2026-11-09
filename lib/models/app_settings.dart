import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Pengaturan aplikasi: tema, bahasa, notifikasi, dan sensitivitas sensor.
/// Catatan: pilihan hanya tersimpan selama aplikasi terbuka.
class AppSettings extends ChangeNotifier {
  AppSettings._();
  static final AppSettings instance = AppSettings._();

  static const languages = ['Indonesia', 'English'];
  static const sensitivityLabels = ['Rendah', 'Sedang', 'Tinggi'];

  bool _notifications = true;
  int _language = 0; // 0 = Indonesia, 1 = English
  int _sensitivity = 1;
  bool _dark = false;

  bool get notifications => _notifications;
  int get language => _language;
  int get sensitivity => _sensitivity;
  bool get isDark => _dark;
  bool get isEnglish => _language == 1;
  ThemeMode get themeMode => _dark ? ThemeMode.dark : ThemeMode.light;

  String get languageLabel => languages[_language];
  String get sensitivityLabel => sensitivityLabels[_sensitivity];

  set notifications(bool v) {
    if (_notifications == v) return;
    _notifications = v;
    notifyListeners();
  }

  set language(int i) {
    if (_language == i) return;
    _language = i;
    notifyListeners();
  }

  set sensitivity(int i) {
    if (_sensitivity == i) return;
    _sensitivity = i;
    notifyListeners();
  }

  set dark(bool v) {
    if (_dark == v) return;
    _dark = v;
    notifyListeners();
  }
}