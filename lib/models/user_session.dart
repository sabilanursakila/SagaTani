import 'package:flutter/foundation.dart';

/// Menyimpan data pengguna yang sedang masuk (nama, email, dan no. HP).
/// Data diisi dari halaman Register / Login, lalu dibaca oleh Beranda dan Profil.
/// Catatan: data hanya tersimpan selama aplikasi terbuka (belum ada database).
class UserSession extends ChangeNotifier {
  UserSession._();
  static final UserSession instance = UserSession._();

  String _name = '';
  String _contact = '';
  String _email = '';
  String _phone = '';

  // Akun yang didaftarkan selama aplikasi terbuka: kontak -> nama.
  final Map<String, String> _accounts = {};

  String get name => _name.isEmpty ? 'Pengguna' : _name;
  String get contact => _contact.isEmpty ? '-' : _contact;
  String get email => _email;
  String get phone => _phone;

  /// Apakah email / no. HP ini sudah pernah didaftarkan.
  bool isRegistered(String contact) =>
      _accounts.containsKey(contact.trim().toLowerCase());

  void _setContact(String c) {
    _contact = c;
    _email = c.contains('@') ? c : '';
    _phone = c.contains('@') ? '' : c;
  }

  /// Dipanggil saat pendaftaran berhasil.
  void register({required String name, required String contact}) {
    final n = name.trim();
    final c = contact.trim();
    _accounts[c.toLowerCase()] = n;
    _name = n;
    _setContact(c);
    notifyListeners();
  }

  /// Dipanggil saat masuk. Jika akunnya pernah didaftarkan, nama diambil dari
  /// pendaftaran; jika tidak, dipakai bagian depan email / username yang diketik.
  void login(String identifier) {
    final id = identifier.trim();
    if (id.isEmpty) return;
    _setContact(id);
    _name = _accounts[id.toLowerCase()] ??
        (id.contains('@') ? id.split('@').first : id);
    notifyListeners();
  }

  /// Dipanggil dari halaman Akun saat "Simpan Perubahan" ditekan.
  void updateProfile({
    required String name,
    required String email,
    required String phone,
  }) {
    final n = name.trim();
    final e = email.trim();
    final p = phone.trim();
    if (n.isNotEmpty) _name = n;
    _email = e;
    _phone = p;
    _contact = e.isNotEmpty ? e : p;
    notifyListeners();
  }

  /// Dipanggil saat keluar dari akun.
  void logout() {
    _name = '';
    _contact = '';
    _email = '';
    _phone = '';
    notifyListeners();
  }
}