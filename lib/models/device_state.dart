import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' show FirebaseException;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../services/firebase_service.dart';
import 'activity_store.dart';
import 'sound_settings.dart';

/// Kondisi perangkat secara real-time (devices/R-001) + perintah ke perangkat.
///
/// Alat (ESP32) menulis: status, sensor, logs.
/// Aplikasi menulis    : control (mode, suara, putar manual, jadwal).
class DeviceState extends ChangeNotifier {
  DeviceState._();
  static final DeviceState instance = DeviceState._();

  /// Urutan sama dengan nomor file /mp3/000X.mp3 dan daftar di layar suara.
  static const soundIds = [
    'elang',
    'burung_hantu',
    'rubah',
    'ular',
    'anjing',
  ];

  static const soundNames = [
    'Suara Elang',
    'Suara Burung Hantu',
    'Suara Rubah',
    'Suara Ular',
    'Suara Anjing',
  ];

  static const _months = [
    'jan', 'feb', 'mar', 'apr', 'mei', 'jun',
    'jul', 'agu', 'sep', 'okt', 'nov', 'des',
  ];

  /// Alat mengirim heartbeat tiap 10 detik; lewat 45 detik dianggap offline.
  static const onlineTimeoutMs = 45000;

  String deviceId = FirebaseService.deviceId;

  /// null = baik. 'belum_terhubung' = akun belum menjadi anggota perangkat.
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
  String get bateraiLabel => baterai == null ? '-' : '$baterai %';

  // ---- Kontrol (devices/R-001/control) ----
  String get mode => (_sec('control')['mode'] ?? 'otomatis').toString();
  bool get isManual => mode == 'manual';

  /// true = alat memilih suara sendiri (Fuzzy + MAB), tampil sebagai "Mode Acak".
  bool get adaptif => _sec('control')['adaptif'] != false;
  String get soundId => (_sec('control')['soundId'] ?? 'elang').toString();
  bool get putarManual => _sec('control')['putarManual'] == true;
  int get volume => _int(_sec('control')['volume']) ?? 0;

  DateTime? get jadwalManual {
    final ms = _int(_sec('control')['jadwalManual']);
    return (ms == null || ms <= 0)
        ? null
        : DateTime.fromMillisecondsSinceEpoch(ms);
  }

  /// Indeks untuk layar Pemilihan Suara: -1 = Mode Acak.
  int get soundIndex {
    if (adaptif) return SoundSettings.randomMode;
    final i = soundIds.indexOf(soundId);
    return i < 0 ? 0 : i;
  }

  // ---------- Teks siap tampil (Detail Perangkat) ----------

  String get suaraText {
    if (adaptif) {
      final items = ActivityStore.instance.items;
      return items.isEmpty ? 'Mode Acak' : 'Mode Acak (${items.first.sound})';
    }
    final i = soundIds.indexOf(soundId);
    return i < 0 ? soundId : soundNames[i];
  }

  /// Mode otomatis: volume ditentukan logika fuzzy di alat (status/volumeAktif).
  String get volumeText {
    final va = _int(_sec('status')['volumeAktif']);
    final v = (!isManual && va != null) ? va : volume;
    return 'Volume $v%';
  }

  String get operasiText {
    final ms = _int(_sec('status')['waktuOperasiTerakhir']);
    if (ms == null || ms <= 0) return '-';
    final d = DateTime.fromMillisecondsSinceEpoch(ms);
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.day} ${_months[d.month - 1]} ${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  // ---------- Siklus hidup ----------

  /// Mulai mendengarkan data perangkat. Dipanggil setelah login.
  /// Akun hanya bisa membaca jika sudah menjadi anggota perangkat
  /// (pemilik, atau sudah bergabung lewat gabung()).
  Future<void> start() async {
    await stop();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    // Pilihan suara dari pengguna dikirim ke perangkat.
    SoundSettings.onUserSelect = setSoundIndex;

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
    // Riwayat kejadian (logs/R-001).
    ActivityStore.instance.start(deviceId);
    // Hitung ulang status online meskipun tidak ada data baru.
    _tick =
        Timer.periodic(const Duration(seconds: 5), (_) => notifyListeners());
  }

  /// Bergabung ke perangkat memakai kode dari info/kodePair.
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
    await ActivityStore.instance.stop();
    _d = {};
    error = null;
    notifyListeners();
  }

  void _onData(DatabaseEvent event) {
    final v = event.snapshot.value;
    _d = v is Map ? _deep(v) : <String, dynamic>{};
    error = null;
    // Samakan pilihan di layar Pemilihan Suara dengan isi Firebase.
    if (_d.isNotEmpty) SoundSettings.instance.applyRemote(soundIndex);
    debugPrint('DeviceState: data diterima (online=$online)');
    notifyListeners();
  }

  static Map<String, dynamic> _deep(Map m) => m.map<String, dynamic>(
        (k, v) => MapEntry(k.toString(), v is Map ? _deep(v) : v),
      );

  // ---------- Perintah ke perangkat ----------

  Future<void> _updateControl(Map<String, Object?> values) async {
    // Tampilkan perubahan seketika, lalu kirim ke Firebase.
    final c = Map<String, dynamic>.from(_sec('control'))..addAll(values);
    _d = {..._d, 'control': c};
    notifyListeners();
    try {
      await FirebaseService.db
          .ref('devices/$deviceId/control')
          .update(values)
          .timeout(const Duration(seconds: 8));
    } catch (e) {
      debugPrint('Gagal mengirim perintah: $e');
    }
  }

  /// m: 'otomatis' atau 'manual'.
  Future<void> setMode(String m) => _updateControl({
        'mode': m,
        if (m == 'otomatis') 'putarManual': false,
      });

  /// index -1 = Mode Acak (alat memilih sendiri). Selain itu suara tetap.
  Future<void> setSoundIndex(int index) {
    if (index == SoundSettings.randomMode) {
      return _updateControl({'adaptif': true, 'acak': false});
    }
    return _updateControl({
      'adaptif': false,
      'acak': false,
      'soundId': soundIds[index],
    });
  }

  Future<void> setPutarManual(bool on) => _updateControl({'putarManual': on});

  Future<void> setJadwalManual(DateTime? t) =>
      _updateControl({'jadwalManual': t?.millisecondsSinceEpoch ?? 0});
}