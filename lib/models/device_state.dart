import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../services/firebase_service.dart';

/// Kondisi perangkat secara real-time (devices/R-001).
/// Alat (ESP32) menulis: status, sensor, logs.
class DeviceState extends ChangeNotifier {
  DeviceState._();
  static final DeviceState instance = DeviceState._();

  /// Alat mengirim heartbeat tiap 10 detik; lewat 45 detik dianggap offline.
  static const onlineTimeoutMs = 45000;

  String deviceId = FirebaseService.deviceId;

  /// null = baik. 'diklaim_lain' = perangkat milik akun lain.
  String? error;

  Map<String, dynamic> _d = {};
  int _offset = 0; // selisih jam HP dengan jam server Firebase (ms)
  StreamSubscription<DatabaseEvent>? _sub;
  StreamSubscription<DatabaseEvent>? _offsetSub;
  Timer? _tick;

  // ---------- Pembacaan ----------

  Map<String, dynamic> _sec(String k) {
    final v = _d[k];
    return v is Map<String, dynamic> ? v : <String, dynamic>{};
  }

  int? _int(Object? v) => v is num ? v.toInt() : null;

  bool get hasData => _d.isNotEmpty;

  bool get online {
    final last = _int(_sec('status')['lastSeen']) ?? 0;
    if (last <= 0) return false;
    final now = DateTime.now().millisecondsSinceEpoch + _offset;
    return now - last < onlineTimeoutMs;
  }

  bool get sensorAktif => online && _sec('sensor')['aktif'] == true;
  bool get suaraBerjalan => online && _sec('status')['suaraBerjalan'] == true;
  int? get baterai => _int(_sec('status')['baterai']);
  String get bateraiText => baterai == null ? '-' : '$baterai%';

  // ---------- Siklus hidup ----------

  /// Mulai mendengarkan data perangkat. Dipanggil setelah login.
  /// Akun hanya bisa membaca jika sudah menjadi anggota perangkat
  /// (pemilik, atau sudah bergabung lewat gabung()).
  Future<void> start() async {
    await stop();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final db = FirebaseService.db;
    _offsetSub = db.ref('.info/serverTimeOffset').onValue.listen((e) {
      final v = e.snapshot.value;
      if (v is num) _offset = v.toInt();
    });
    _sub = db.ref('devices/$deviceId').onValue.listen(
      _onData,
      onError: (Object e) {
        error = (e is FirebaseException && e.code == 'permission-denied')
            ? 'belum_terhubung'
            : 'izin';
        debugPrint('DeviceState: gagal membaca data ($e)');
        notifyListeners();
      },
    );
    // Hitung ulang status online meskipun tidak ada data baru.
    _tick =
        Timer.periodic(const Duration(seconds: 5), (_) => notifyListeners());
  }

  /// Bergabung ke perangkat memakai kode dari QR.
  /// Mengembalikan null jika berhasil, atau kode error.
  Future<String?> gabung(String kode) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return 'belum_login';
    try {
      final db = FirebaseService.db;
      await db
          .ref('devices/$deviceId/members/$uid')
          .set(kode)
          .timeout(const Duration(seconds: 8));
      await db
          .ref('users/$uid/devices/$deviceId')
          .set(true)
          .timeout(const Duration(seconds: 8));
    } on FirebaseException catch (e) {
      return e.code == 'permission-denied' ? 'kode_salah' : e.code;
    } catch (_) {
      return 'gagal';
    }
    await start();
    return null;
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
    await _offsetSub?.cancel();
    _offsetSub = null;
    _tick?.cancel();
    _tick = null;
    _d = {};
    error = null;
    notifyListeners();
  }

  void _onData(DatabaseEvent event) {
    final v = event.snapshot.value;
    _d = v is Map ? _deep(v) : <String, dynamic>{};
    error = null;
    debugPrint('DeviceState: data diterima (online=$online)');
    notifyListeners();
  }

  static Map<String, dynamic> _deep(Map m) => m.map<String, dynamic>(
        (k, v) => MapEntry(k.toString(), v is Map ? _deep(v) : v),
      );
}