import 'package:flutter/material.dart';

class Perangkat {
  final String nama, fungsi, spesifikasi, gambar;
  final IconData ikon; // ikon cadangan jika gambar belum ada

  const Perangkat({
    required this.nama,
    required this.fungsi,
    required this.spesifikasi,
    required this.gambar,
    required this.ikon,
  });
}

// Kunci = isi QR code
const dataPerangkat = {
  'PERANGKAT-001': Perangkat(
    nama: 'Sensor PIR',
    fungsi:
        'Mendeteksi gerakan (misalnya tikus) lewat perubahan radiasi inframerah, lalu memicu sistem pengusir.',
    spesifikasi:
        '• Tegangan kerja ±5 V\n• Jangkauan ±3–7 m\n• Sudut deteksi ±110–120°\n• Keluaran digital HIGH/LOW',
    gambar: 'assets/images/pir.png',
    ikon: Icons.sensors,
  ),
  'PERANGKAT-002': Perangkat(
    nama: 'Sensor LDR',
    fungsi:
        'Mengukur intensitas cahaya sekitar, misalnya untuk membedakan siang dan malam.',
    spesifikasi:
        '• Resistansi turun saat terang, naik saat gelap\n• Keluaran analog lewat pembagi tegangan\n• Tegangan kerja 3,3–5 V',
    gambar: 'assets/images/ldr.png',
    ikon: Icons.light_mode,
  ),
  'PERANGKAT-003': Perangkat(
    nama: 'Aktuator Speaker',
    fungsi:
        'Mengeluarkan suara pengusir hama ketika sistem mendeteksi tikus.',
    spesifikasi:
        '• Jenis: speaker kecil (aktuator suara)\n• Impedansi contoh 8 Ω\n• Daya contoh 0,5–3 W\n• Dikendalikan oleh ESP32',
    gambar: 'assets/images/speaker.png',
    ikon: Icons.volume_up,
  ),
  'PERANGKAT-004': Perangkat(
    nama: 'ESP32',
    fungsi:
        'Mikrokontroler sebagai otak sistem: membaca sensor, mengendalikan speaker, dan mengirim data lewat Wi-Fi.',
    spesifikasi:
        '• Prosesor dual-core hingga 240 MHz\n• Wi-Fi 2,4 GHz dan Bluetooth\n• Tegangan logika 3,3 V\n• Banyak pin GPIO untuk sensor dan aktuator',
    gambar: 'assets/images/esp32.png',
    ikon: Icons.memory,
  ),
};