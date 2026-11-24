import 'package:firebase_auth/firebase_auth.dart';

import '../models/device_state.dart';
import '../models/app_settings.dart';
import '../models/user_session.dart';
import 'firebase_service.dart';

/// Pesan kesalahan yang sudah siap ditampilkan ke pengguna.
class AuthFailure implements Exception {
  final String message;
  AuthFailure(this.message);
  @override
  String toString() => message;
}

/// Login, pendaftaran, dan profil pengguna lewat Firebase.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  FirebaseAuth get _auth => FirebaseAuth.instance;

  static String _msg(String id, String en) =>
      AppSettings.instance.isEnglish ? en : id;

  /// Firebase butuh email. Nomor HP atau username dijadikan email semu.
  static String toEmail(String identifier) {
    final s = identifier.trim();
    if (s.contains('@')) return s;
    return '${s.replaceAll(RegExp(r'[\s-]'), '').toLowerCase()}@sagatani.app';
  }

  AuthFailure _fromCode(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
      case 'invalid-email':
        return AuthFailure(_msg('Email/username atau sandi salah.',
            'Wrong email/username or password.'));
      case 'email-already-in-use':
        return AuthFailure(_msg('Akun ini sudah terdaftar, silakan masuk.',
            'This account is already registered, please log in.'));
      case 'weak-password':
        return AuthFailure(
            _msg('Sandi terlalu lemah.', 'Password is too weak.'));
      case 'network-request-failed':
        return AuthFailure(
            _msg('Tidak ada koneksi internet.', 'No internet connection.'));
      case 'too-many-requests':
        return AuthFailure(_msg('Terlalu banyak percobaan, coba lagi nanti.',
            'Too many attempts, try again later.'));
      default:
        return AuthFailure(
            '${_msg('Gagal masuk', 'Sign-in failed')}: ${e.code}');
    }
  }

  Future<void> login(String identifier, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: toEmail(identifier),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _fromCode(e);
    }
    await _muatProfil();
  }

  Future<void> register({
    required String name,
    required String contact,
    required String password,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: toEmail(contact),
        password: password,
      );
      await cred.user?.updateDisplayName(name.trim());
    } on FirebaseAuthException catch (e) {
      throw _fromCode(e);
    }

    final uid = _auth.currentUser!.uid;
    try {
      await FirebaseService.db.ref('users/$uid').set({
        'nama': name.trim(),
        'kontak': contact.trim(),
        'role': 'Pengguna',
        'pengaturan': {
          'notifikasi': true,
          'bahasa': 'id',
          'sensitivitas': 'sedang',
        },
      }).timeout(const Duration(seconds: 8));
    } catch (_) {}
    await _muatProfil();
  }

  /// Mengisi UserSession (nama, kontak) dari profil di Firebase.
  Future<void> _muatProfil() async {
    final user = _auth.currentUser;
    if (user == null) return;

    Map<String, dynamic>? data;
    try {
      final snap = await FirebaseService.db
          .ref('users/${user.uid}')
          .get()
          .timeout(const Duration(seconds: 8));
      if (snap.exists && snap.value is Map) {
        data = Map<String, dynamic>.from(snap.value as Map);
      }
    } catch (_) {}

    final email = user.email ?? '';
    final kontakCadangan =
        email.endsWith('@sagatani.app') ? email.split('@').first : email;
    final kontak = (data?['kontak'] as String?) ?? kontakCadangan;
    final nama = (data?['nama'] as String?) ??
        user.displayName ??
        (kontak.contains('@') ? kontak.split('@').first : kontak);

    UserSession.instance.register(name: nama, contact: kontak);
    await DeviceState.instance.start();
  }

  /// Dipanggil saat aplikasi dibuka: true jika masih ada sesi login.
  Future<bool> restoreSession() async {
    if (_auth.currentUser == null) return false;
    try {
      await _muatProfil().timeout(const Duration(seconds: 10));
    } catch (_) {}
    return true;
  }
  Future<void> signOut() async {
    await DeviceState.instance.stop();
    await _auth.signOut();
  }
}