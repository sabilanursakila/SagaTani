import '../models/app_settings.dart';

/// Terjemahan sederhana. Teks asli di aplikasi memakai Bahasa Indonesia;
/// jika bahasa English dipilih, teks dicari di kamus di bawah ini.
/// Teks yang tidak ada di kamus ditampilkan apa adanya.
class L {
  static String t(String id) {
    if (!AppSettings.instance.isEnglish) return id;
    return _en[id] ?? id;
  }

  static const Map<String, String> _en = {
    // Umum
    'Saga Tani': 'Saga Tani',
    'Pengguna': 'User',
    'Batal': 'Cancel',
    'Simpan': 'Save',
    'Tutup': 'Close',
    'Keluar': 'Log out',
    'Halo': 'Hello',

    // Navigasi bawah
    'Beranda': 'Home',
    'Perangkat': 'Device',
    'Akun': 'Account',
    'Pengaturan': 'Settings',

    // Beranda
    'Petani Sawah Sejahtera': 'Prosperous Rice Farmer',
    'Perangkat Aktif': 'Active Device',
    'Online': 'Online',
    'Status Sistem': 'System Status',
    'Sensor': 'Sensor',
    'Aktif': 'Active',
    'Suara': 'Sound',
    'Berjalan': 'Running',
    'Status': 'Status',
    'Terhubung': 'Connected',
    'Mode Operasi': 'Operation Mode',
    'Otomatis': 'Automatic',
    'Manual': 'Manual',
    'Pemilihan Suara': 'Sound Selection',
    'Daftar Suara': 'Sound List',
    'Riwayat Aktivitas': 'Activity History',
    'Belum ada aktivitas': 'No activity yet',

    // Detail perangkat
    'Detail Perangkat': 'Device Details',
    'Suara yang Diputar': 'Sound Playing',
    'Suara Elang': 'Eagle Sound',
    'Volume Suara': 'Sound Volume',
    'Volume 75%': 'Volume 75%',
    'Baterai': 'Battery',
    'Waktu Operasi Terakhir': 'Last Operation Time',
    '24 sep 2026 09:25': '24 Sep 2026 09:25',

    // Pemilihan suara
    'Daftar suara': 'Sound list',
    'Paling efektif (rekomendasi)': 'Most effective (recommended)',
    'Rekomendasi': 'Recommended',
    'Suara Burung Hantu': 'Owl Sound',
    'Suara Rubah': 'Fox Sound',
    'Suara Ular': 'Snake Sound',
    'Suara Anjing': 'Dog Sound',
    'Mode Acak': 'Random Mode',
    'Sistem akan memutar suara secara acak berdasarkan aturan yang telah ditentukan.':
        'The system will play sounds randomly based on predefined rules.',

    // Riwayat
    'Riwayat': 'History',
    'Aktivitas tikus yang terdeteksi': 'Detected rat activity',
    'aktivitas ditemukan': 'activities found',
    'Tidak ada riwayat yang cocok.': 'No matching history.',
    'Cari tanggal, lokasi, suara, status...':
        'Search date, location, sound, status...',
    'Unduh dataset (CSV)': 'Download dataset (CSV)',
    'Tidak ada data untuk diunduh.': 'No data to download.',
    'Gagal menyiapkan file': 'Failed to prepare file',
    'Dataset riwayat aktivitas tikus': 'Rat activity history dataset',
    'Tanggal,Waktu,Lokasi,Pergerakan,Suara,Status Pengusiran':
        'Date,Time,Location,Movement,Sound,Repelling Status',
    'Semua': 'All',
    'Pergerakan': 'Movement',
    'Suara keluar': 'Output sound',
    'Berhasil diusir': 'Successfully repelled',
    'Sedang diusir': 'Being repelled',
    'Gagal diusir': 'Failed to repel',
    'Sawah Blok A': 'Rice Field Block A',
    'Sawah Blok B': 'Rice Field Block B',
    'Gudang Padi': 'Rice Warehouse',
    'Kebun Jagung': 'Corn Field',
    'Saluran Irigasi': 'Irrigation Canal',
    'Lumbung': 'Granary',
    'Bergerak cepat ke arah utara': 'Moving fast to the north',
    'Bergerak cepat ke arah selatan': 'Moving fast to the south',
    'Bergerak lambat ke arah timur': 'Moving slowly to the east',
    'Bergerak lambat menyusuri tepi': 'Moving slowly along the edge',
    'Mondar-mandir di sekitar karung': 'Pacing around the sacks',
    'Mondar-mandir di pematang': 'Pacing on the paddy bund',
    'Menggali di dekat pagar': 'Digging near the fence',
    'Diam di sudut ruangan': 'Staying still in a corner',
    'Berkelompok, bergerak ke barat': 'In a group, moving west',
    'Melompat di antara tumpukan karung': 'Jumping between stacked sacks',
    'Berenang menyeberangi saluran': 'Swimming across the canal',
    'Menggerogoti pintu': 'Gnawing at the door',
    'Ultrasonik 22 kHz': 'Ultrasonic 22 kHz',
    'Ultrasonik 20 kHz': 'Ultrasonic 20 kHz',
    'Ultrasonik 25 kHz + bunyi alarm': 'Ultrasonic 25 kHz + alarm sound',
    'Bunyi alarm 85 dB': 'Alarm sound 85 dB',
    'Mei': 'May',
    'Agu': 'Aug',
    'Okt': 'Oct',
    'Des': 'Dec',

    // Akun / Edit profil
    'Informasi Akun': 'Account Information',
    'Nama Lengkap': 'Full Name',
    'Email': 'Email',
    'No Telepon': 'Phone Number',
    'Edit Profil': 'Edit Profile',
    'Simpan Perubahan': 'Save Changes',
    'Perubahan berhasil disimpan': 'Changes saved successfully',

    // Pengaturan
    'Solusi para petani': 'Solutions for farmers',
    'Kata Sandi & Keamanan': 'Password & Security',
    'Notifikasi': 'Notifications',
    'Bahasa': 'Language',
    'Pilih Bahasa': 'Choose Language',
    'Preferensi': 'Preferences',
    'Sensitivitas Sensor': 'Sensor Sensitivity',
    'Rendah': 'Low',
    'Sedang': 'Medium',
    'Tinggi': 'High',
    'Tema': 'Theme',
    'Terang': 'Light',
    'Gelap': 'Dark',
    'Tentang Aplikasi': 'About the App',
    'Versi 1.0.0': 'Version 1.0.0',
    'Saga Tani  •  Versi 1.0.0': 'Saga Tani  •  Version 1.0.0',
    'Dukungan': 'Support',
    'Pusat Bantuan': 'Help Center',
    'Keluar dari akun?': 'Log out of your account?',
    'Kamu perlu masuk lagi untuk memakai aplikasi.':
        'You need to log in again to use the app.',
    'Ubah Kata Sandi': 'Change Password',
    'Sandi lama': 'Old password',
    'Sandi baru': 'New password',
    'Konfirmasi sandi baru': 'Confirm new password',
    'Konfirmasi sandi tidak sama': 'Password confirmation does not match',
    'Kata sandi berhasil diubah': 'Password changed successfully',
    'Aplikasi pemantauan perangkat repelan hama tikus berbasis IoT untuk membantu petani menjaga sawah.':
        'An IoT-based rat repellent device monitoring app that helps farmers protect their fields.',
    'Bagaimana cara kerja perangkat?': 'How does the device work?',
    'Sensor mendeteksi pergerakan tikus, lalu perangkat mengeluarkan suara pengusir. Semua aktivitas tercatat di Riwayat.':
        'The sensor detects rat movement, then the device plays a repelling sound. All activity is recorded in History.',
    'Perangkat saya tidak terhubung': 'My device is not connected',
    'Pastikan perangkat menyala dan berada dalam jangkauan Wi-Fi. Coba matikan lalu nyalakan kembali perangkat.':
        'Make sure the device is on and within Wi-Fi range. Try turning it off and on again.',
    'Bagaimana mengganti suara pengusir?': 'How do I change the repelling sound?',
    'Buka Beranda, pilih bagian Pemilihan Suara, lalu pilih suara yang diinginkan atau Mode Acak.':
        'Open Home, go to Sound Selection, then choose the sound you want or Random Mode.',
    'Apa bedanya mode Otomatis dan Manual?':
        'What is the difference between Automatic and Manual mode?',
    'Otomatis: perangkat bekerja sendiri saat tikus terdeteksi. Manual: kamu yang mengaktifkan pengusir.':
        'Automatic: the device works on its own when a rat is detected. Manual: you activate the repeller yourself.',

    // Login & Daftar
    'SAGA TANI': 'SAGA TANI',
    'Masa Depan Pertanian, Bersama': 'The Future of Farming, Together',
    'Masuk Untuk Melanjutkan': 'Log In to Continue',
    'Email atau Username': 'Email or Username',
    'Password': 'Password',
    'Ingat saya': 'Remember me',
    'Lupa password?': 'Forgot password?',
    'Masuk': 'Log In',
    'Atau': 'Or',
    'atau': 'or',
    'Masuk dengan Google': 'Log in with Google',
    'Belum punya akun ? ': "Don't have an account? ",
    'Daftar sekarang': 'Sign up now',
    'Daftar Akun': 'Create Account',
    'Bergabunglah dengan SAGA TANI untuk\nmengelola pertanian Anda dengan lebih mudah.':
        'Join SAGA TANI to manage\nyour farm more easily.',
    'No. HP atau Email': 'Phone Number or Email',
    'Sandi': 'Password',
    'Ulangi Sandi': 'Repeat Password',
    'Daftar': 'Sign Up',
    'Sudah punya akun? ': 'Already have an account? ',
    'Masuk di sini': 'Log in here',
    'Akun ini sudah terdaftar, silakan masuk':
        'This account is already registered, please log in',

    // Onboarding & Splash
    'Pantau Hama & Kondisi': 'Monitor Pests & Conditions',
    'Solusi cerdas untuk melindungi lahan pertanian Anda secara real-time.':
        'Smart solutions to protect your farmland in real time.',
    'Solusi Pertanian': 'Farming Solutions',
    'Kelola aktivitas dan dapatkan rekomendasi terbaik untuk hasil panen Anda.':
        'Manage activities and get the best recommendations for your harvest.',
    'Bersama Saga Tani,\nPanen Melimpah!': 'Together with Saga Tani,\nAbundant Harvest!',
    'Mari berkolaborasi demi hasil tani yang lebih maksimal.':
        "Let's collaborate for a better harvest.",
    'Lewati': 'Skip',
    'LANJUT': 'CONTINUE',
    'Daftar Akun Baru': 'Create New Account',
    'Pertanian Lebih Aman Panen Lebih Maksimal':
        'Safer Farming, Better Harvest',
    'Loading...': 'Loading...',

    // Validasi
    'Nama lengkap wajib diisi': 'Full name is required',
    'Nama minimal 3 karakter': 'Name must be at least 3 characters',
    'Nama maksimal 50 karakter': 'Name must be at most 50 characters',
    'Nama hanya boleh berisi huruf': 'Name may only contain letters',
    'No. HP atau email wajib diisi': 'Phone number or email is required',
    'Format email tidak valid': 'Invalid email format',
    'Masukkan email atau nomor HP yang valid':
        'Enter a valid email or phone number',
    'Nomor HP tidak valid (contoh: 08123456789)':
        'Invalid phone number (example: 08123456789)',
    'Email atau username wajib diisi': 'Email or username is required',
    'Username minimal 3 karakter (huruf, angka, titik, garis bawah)':
        'Username must be at least 3 characters (letters, numbers, dots, underscores)',
    'Sandi wajib diisi': 'Password is required',
    'Sandi minimal 6 karakter': 'Password must be at least 6 characters',
    'Sandi maksimal 32 karakter': 'Password must be at most 32 characters',
    'Sandi harus mengandung huruf dan angka':
        'Password must contain letters and numbers',
    'Ulangi sandi wajib diisi': 'Please repeat the password',
    'Sandi tidak sama': 'Passwords do not match',
  };
}