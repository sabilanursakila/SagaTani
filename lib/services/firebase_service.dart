import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

/// Pengaturan Firebase yang dipakai bersama oleh seluruh aplikasi.
class FirebaseService {
  FirebaseService._();

  /// Perangkat yang dipantau aplikasi.
  static const deviceId = 'R-001';

  /// Database ada di region asia-southeast1, jadi URL harus ditulis lengkap.
  static const databaseUrl =
      'https://sagatani-3091d-default-rtdb.asia-southeast1.firebasedatabase.app';

  static FirebaseDatabase get db => FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: databaseUrl,
      );
}