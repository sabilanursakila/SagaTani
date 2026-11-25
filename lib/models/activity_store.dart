import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../services/firebase_service.dart';
import 'rat_activity.dart';

/// Riwayat kejadian dari Firebase (logs/R-001), dipakai Beranda, Riwayat,
/// dan Notifikasi. Urutan: terbaru di atas.
class ActivityStore extends ChangeNotifier {
  ActivityStore._();
  static final ActivityStore instance = ActivityStore._();

  List<RatActivity> _items = const [];
  StreamSubscription<DatabaseEvent>? _sub;

  List<RatActivity> get items => _items;

  void start(String deviceId) {
    _sub?.cancel();
    final query = FirebaseService.db
        .ref('logs/$deviceId')
        .orderByChild('timestamp')
        .limitToLast(100);
    _sub = query.onValue.listen(
      _onData,
      onError: (Object e) => debugPrint('ActivityStore: gagal membaca ($e)'),
    );
  }

  Future<void> stop() async {
    await _sub?.cancel();
    _sub = null;
    _items = const [];
    notifyListeners();
  }

  void _onData(DatabaseEvent event) {
    final list = <RatActivity>[];
    for (final child in event.snapshot.children) {
      final v = child.value;
      if (v is! Map) continue;
      final ts = v['timestamp'];
      if (ts is! num) continue;
      list.add(RatActivity(
        time: DateTime.fromMillisecondsSinceEpoch(ts.toInt()),
        location: (v['lokasi'] ?? '-').toString(),
        movement: (v['pergerakan'] ?? '-').toString(),
        sound: (v['suaraKeluar'] ?? '-').toString(),
        status: _status(v['status']),
      ));
    }
    list.sort((a, b) => b.time.compareTo(a.time));
    _items = list;
    debugPrint('ActivityStore: ${list.length} kejadian');
    notifyListeners();
  }

  RepelStatus _status(Object? s) {
    switch (s) {
      case 'berhasil_diusir':
        return RepelStatus.berhasil;
      case 'gagal_diusir':
        return RepelStatus.gagal;
      default:
        return RepelStatus.proses;
    }
  }
}