import 'package:flutter/foundation.dart';

/// Menyimpan pengaturan aplikasi (notifikasi, bahasa, sensitivitas sensor).
/// Catatan: pilihan hanya tersimpan selama aplikasi terbuka.
class AppSettings extends ChangeNotifier {
  AppSettings._();
  static final AppSettings instance = AppSettings._();

  static const languages = ['Indonesia', 'English'];
  static const sensitivityLabels = ['Rendah', 'Sedang', 'Tinggi'];

  bool _notifications = true;
  int _language = 0;
  int _sensitivity = 1;

  bool get notifications => _notifications;
  int get language => _language;
  int get sensitivity => _sensitivity;

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
}