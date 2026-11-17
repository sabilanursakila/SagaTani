import 'package:google_sign_in/google_sign_in.dart';

/// Pembungkus Google Sign-In agar mudah dipanggil dari halaman mana pun.
class GoogleAuthService {
  GoogleAuthService._();
  static final GoogleAuthService instance = GoogleAuthService._();

  final GoogleSignIn _google = GoogleSignIn(scopes: ['email', 'profile']);

  /// Mengembalikan akun Google, atau null jika pengguna membatalkan.
  /// Sesi lama dikeluarkan dulu supaya pilihan akun selalu muncul.
  Future<GoogleSignInAccount?> signIn() async {
    try {
      await _google.signOut();
    } catch (_) {}
    return _google.signIn();
  }

  Future<void> signOut() async {
    try {
      await _google.signOut();
    } catch (_) {}
  }
}