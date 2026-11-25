import 'package:flutter/foundation.dart';

/// Menyimpan pilihan suara pengusir yang sedang dipakai.
/// Pilihan pengguna dikirim ke perangkat lewat DeviceState (Firebase),
/// dan pilihan dari Firebase diterapkan kembali lewat applyRemote().
class SoundSettings extends ChangeNotifier {
  SoundSettings._();
  static final SoundSettings instance = SoundSettings._();

  static const randomMode = -1;

  /// Dipasang oleh DeviceState: mengirim pilihan pengguna ke perangkat.
  static void Function(int index)? onUserSelect;

  int _selected = 0; // nomor urut suara; -1 = Mode Acak

  int get selected => _selected;
  bool get isRandom => _selected == randomMode;

  void select(int index) {
    if (_selected == index) return;
    _selected = index;
    notifyListeners();
    onUserSelect?.call(index);
  }

  void selectRandom() => select(randomMode);

  /// Pilihan yang datang dari Firebase (tidak dikirim balik ke Firebase).
  void applyRemote(int index) {
    if (_selected == index) return;
    _selected = index;
    notifyListeners();
  }
}