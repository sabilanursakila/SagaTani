import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../models/perangkat.dart';
import '../widgets/detail_perangkat_sheet.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  // Kecepatan normal: QR yang sama tetap terbaca lagi saat discan ulang.
  final controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
  );

  // Penanda: popup sedang terbuka.
  bool _popupTampil = false;

  // Setelah popup ditutup, hasil scan diabaikan sampai waktu ini.
  // Tujuannya agar popup tidak langsung muncul lagi selagi kamera
  // masih mengarah ke QR yang sama.
  DateTime _abaikanSampai = DateTime.now();

  // Lama jeda setelah popup ditutup. Ubah sesuai selera.
  static const _jeda = Duration(milliseconds: 1500);

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_popupTampil) return;
    if (DateTime.now().isBefore(_abaikanSampai)) return;
    if (capture.barcodes.isEmpty) return;

    final perangkat = dataPerangkat[capture.barcodes.first.rawValue];
    if (perangkat == null) return; // QR tidak dikenal, abaikan

    _popupTampil = true;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => DetailPerangkatSheet(perangkat: perangkat),
    );

    // Popup sudah ditutup: beri jeda sebelum boleh scan lagi.
    _popupTampil = false;
    _abaikanSampai = DateTime.now().add(_jeda);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Perangkat')),
      body: MobileScanner(controller: controller, onDetect: _onDetect),
    );
  }
}