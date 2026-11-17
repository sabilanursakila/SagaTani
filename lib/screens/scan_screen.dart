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
  final controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _popupTampil = false;

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_popupTampil || capture.barcodes.isEmpty) return;
    final perangkat = dataPerangkat[capture.barcodes.first.rawValue];
    if (perangkat == null) return; // QR tidak dikenal, abaikan

    _popupTampil = true;
    await showModalBottomSheet(
      context: context,
      builder: (_) => DetailPerangkatSheet(perangkat: perangkat),
    );
    _popupTampil = false;
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