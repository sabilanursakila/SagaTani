import 'package:flutter/foundation.dart';

/// Menyimpan data pengguna yang sedang masuk (nama dan email/no. HP).
/// Data diisi dari halaman Register / Login, lalu dibaca oleh Beranda dan Profil.
/// Catatan: data hanya tersimpan selama aplikasi terbuka (belum ada database).
class UserSession extends ChangeNotifier {
  UserSession._();
  static final UserSession instance = UserSession._();

  String _name = '';
  String _contact = '';

  // Akun yang didaftarkan selama aplikasi terbuka: kontak -> nama.
  final Map<String, String> _accounts = {};

  String get name => _name.isEmpty ? 'Pengguna' : _name;
  String get contact => _contact.isEmpty ? '-' : _contact;

  /// Apakah email / no. HP ini sudah pernah didaftarkan.
  bool isRegistered(String contact) =>
      _accounts.containsKey(contact.trim().toLowerCase());

  /// Dipanggil saat pendaftaran berhasil.
  void register({required String name, required String contact}) {
    final n = name.trim();
    final c = contact.trim();
    _accounts[c.toLowerCase()] = n;
    _name = n;
    _contact = c;
    notifyListeners();
  }

  /// Dipanggil saat masuk. Jika akunnya pernah didaftarkan, nama diambil dari
  /// pendaftaran; jika tidak, dipakai bagian depan email / username yang diketik.
  void login(String identifier) {
    final id = identifier.trim();
    if (id.isEmpty) return;
    _contact = id;
    _name = _accounts[id.toLowerCase()] ??
        (id.contains('@') ? id.split('@').first : id);
    notifyListeners();
  }

  /// Dipanggil saat keluar dari akun.
  void logout() {
    _name = '';
    _contact = '';
    notifyListeners();
  }
}