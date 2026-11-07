import 'package:flutter/foundation.dart';

/// Menyimpan pilihan suara pengusir yang sedang dipakai.
/// Catatan: pilihan hanya tersimpan selama aplikasi terbuka.
class SoundSettings extends ChangeNotifier {
  SoundSettings._();
  static final SoundSettings instance = SoundSettings._();

  static const randomMode = -1;

  int _selected = 0; // nomor urut suara; -1 = Mode Acak

  int get selected => _selected;
  bool get isRandom => _selected == randomMode;

  void select(int index) {
    if (_selected == index) return;
    _selected = index;
    notifyListeners();
  }

  void selectRandom() => select(randomMode);
}