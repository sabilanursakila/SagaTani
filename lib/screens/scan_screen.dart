import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../models/perangkat.dart';
import '../utils/l10n.dart';
import '../widgets/detail_perangkat_sheet.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen>
    with SingleTickerProviderStateMixin {
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
  late final AnimationController _scanLine = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

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
    _scanLine.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(L.t('Scan Perangkat')),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(controller: controller, onDetect: _onDetect),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final frameSize = (constraints.maxWidth * 0.68)
                    .clamp(210.0, 270.0)
                    .toDouble();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 13),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.52),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.qr_code_2_rounded,
                                color: Color(0xFF8BE09B), size: 22),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                L.t('Arahkan kamera ke QR perangkat'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: frameSize,
                      height: frameSize,
                      child: AnimatedBuilder(
                        animation: _scanLine,
                        builder: (context, _) => Stack(
                          children: [
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.7),
                                      width: 1.5),
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 18,
                              right: 18,
                              top: 18 +
                                  (frameSize - 36) * _scanLine.value,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF8BE09B),
                                  borderRadius: BorderRadius.circular(2),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xAA8BE09B),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            for (final corner in const [
                              Alignment.topLeft,
                              Alignment.topRight,
                              Alignment.bottomLeft,
                              Alignment.bottomRight,
                            ])
                              Align(
                                alignment: corner,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: corner.y < 0
                                          ? const BorderSide(
                                              color: Color(0xFF8BE09B),
                                              width: 4)
                                          : BorderSide.none,
                                      bottom: corner.y > 0
                                          ? const BorderSide(
                                              color: Color(0xFF8BE09B),
                                              width: 4)
                                          : BorderSide.none,
                                      left: corner.x < 0
                                          ? const BorderSide(
                                              color: Color(0xFF8BE09B),
                                              width: 4)
                                          : BorderSide.none,
                                      right: corner.x > 0
                                          ? const BorderSide(
                                              color: Color(0xFF8BE09B),
                                              width: 4)
                                          : BorderSide.none,
                                    ),
                                    borderRadius: BorderRadius.only(
                                      topLeft: corner == Alignment.topLeft
                                          ? const Radius.circular(12)
                                          : Radius.zero,
                                      topRight: corner == Alignment.topRight
                                          ? const Radius.circular(12)
                                          : Radius.zero,
                                      bottomLeft:
                                          corner == Alignment.bottomLeft
                                              ? const Radius.circular(12)
                                              : Radius.zero,
                                      bottomRight:
                                          corner == Alignment.bottomRight
                                              ? const Radius.circular(12)
                                              : Radius.zero,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 26),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 11),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.52),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          L.t('Pemindaian dimulai otomatis saat QR terdeteksi'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
