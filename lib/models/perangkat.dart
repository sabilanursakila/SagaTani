class Perangkat {
  final String nama, fungsi, status, spesifikasi;
  const Perangkat({
    required this.nama,
    required this.fungsi,
    required this.status,
    required this.spesifikasi,
  });
}

// Kunci = isi QR code. Ganti dengan data perangkatmu.
const dataPerangkat = {
  'PERANGKAT-001': Perangkat(
    nama: 'Nama perangkat',
    fungsi: 'Fungsi perangkat',
    status: 'Aktif',
    spesifikasi: 'Spesifikasi perangkat',
  ),
};