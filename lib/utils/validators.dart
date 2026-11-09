import 'l10n.dart';

/// Aturan validasi untuk formulir Login dan Register.
/// Setiap fungsi mengembalikan pesan error, atau null jika isiannya sudah benar.
class Validators {
  static final _email =
      RegExp(r'^[\w.+-]+@[A-Za-z0-9-]+(\.[A-Za-z0-9-]+)*\.[A-Za-z]{2,}$');
  static final _phone = RegExp(r'^(\+62|62|0)8[1-9][0-9]{7,10}$');
  static final _name = RegExp(r"^[A-Za-z][A-Za-z .'\-]*$");
  static final _username = RegExp(r'^[A-Za-z0-9._]{3,}$');

  /// Nama lengkap (Register).
  static String? name(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return L.t('Nama lengkap wajib diisi');
    if (s.length < 3) return L.t('Nama minimal 3 karakter');
    if (s.length > 50) return L.t('Nama maksimal 50 karakter');
    if (!_name.hasMatch(s)) return L.t('Nama hanya boleh berisi huruf');
    return null;
  }

  /// No. HP atau email (Register).
  static String? emailOrPhone(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return L.t('No. HP atau email wajib diisi');
    if (s.contains('@')) {
      return _email.hasMatch(s) ? null : L.t('Format email tidak valid');
    }
    final digits = s.replaceAll(RegExp(r'[\s-]'), '');
    if (!RegExp(r'^\+?\d+$').hasMatch(digits)) {
      return L.t('Masukkan email atau nomor HP yang valid');
    }
    return _phone.hasMatch(digits)
        ? null
        : L.t('Nomor HP tidak valid (contoh: 08123456789)');
  }

  /// Email atau username (Login).
  static String? loginId(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return L.t('Email atau username wajib diisi');
    if (s.contains('@')) {
      return _email.hasMatch(s) ? null : L.t('Format email tidak valid');
    }
    if (!_username.hasMatch(s)) {
      return L.t('Username minimal 3 karakter (huruf, angka, titik, garis bawah)');
    }
    return null;
  }

  /// Sandi di halaman Login.
  static String? loginPassword(String? v) {
    final s = v ?? '';
    if (s.isEmpty) return L.t('Sandi wajib diisi');
    if (s.length < 6) return L.t('Sandi minimal 6 karakter');
    return null;
  }

  /// Sandi baru di halaman Register.
  static String? newPassword(String? v) {
    final s = v ?? '';
    if (s.isEmpty) return L.t('Sandi wajib diisi');
    if (s.length < 6) return L.t('Sandi minimal 6 karakter');
    if (s.length > 32) return L.t('Sandi maksimal 32 karakter');
    if (!RegExp(r'[A-Za-z]').hasMatch(s) || !RegExp(r'\d').hasMatch(s)) {
      return L.t('Sandi harus mengandung huruf dan angka');
    }
    return null;
  }

  /// Ulangi sandi (Register).
  static String? confirm(String? v, String original) {
    final s = v ?? '';
    if (s.isEmpty) return L.t('Ulangi sandi wajib diisi');
    if (s != original) return L.t('Sandi tidak sama');
    return null;
  }
}