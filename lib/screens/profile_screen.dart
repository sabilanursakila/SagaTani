import 'package:flutter/material.dart';

import '../models/user_session.dart';
import '../theme/app_theme.dart';
import '../utils/l10n.dart';
import '../widgets/tr.dart';

const _hijauMuda = Color(0xFF1B8F5A);
const _hijauTua = Color(0xFF0B5F3F);

/// Tab Akun: ringkasan data pengguna dengan tampilan header hijau.
/// Tombol "Edit Profil" membuka halaman [EditProfileScreen].
/// Navigasi bawah dipegang oleh MainShell, jadi tidak ada di sini.
class ProfileScreen extends StatelessWidget {
  /// Dipanggil saat panah kembali ditekan (di MainShell: kembali
  /// ke halaman sebelumnya).
  final VoidCallback? onBack;
  const ProfileScreen({super.key, this.onBack});

  void _kembali(BuildContext context) {
    if (onBack != null) {
      onBack!();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _bukaEdit(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pageBg,
      body: AnimatedBuilder(
        animation: UserSession.instance,
        builder: (context, _) {
          final u = UserSession.instance;
          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderAkun(
                  nama: u.name,
                  kontak: u.contact,
                  onBack: () => _kembali(context),
                  onEdit: () => _bukaEdit(context),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Muncul(
                        urutan: 0,
                        child: Tr(
                          'Informasi Akun',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: context.accent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _Muncul(
                        urutan: 1,
                        child: _InfoTile(
                          icon: Icons.person_outline_rounded,
                          label: 'Nama Lengkap',
                          value: u.name,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _Muncul(
                        urutan: 2,
                        child: _InfoTile(
                          icon: Icons.mail_outline_rounded,
                          label: 'Email',
                          value: u.email,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _Muncul(
                        urutan: 3,
                        child: _InfoTile(
                          icon: Icons.phone_outlined,
                          label: 'No Telepon',
                          value: u.phone,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _Muncul(
                        urutan: 4,
                        child: _TombolUtama(
                          icon: Icons.edit_outlined,
                          teks: 'Edit Profil',
                          onTap: () => _bukaEdit(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// =============================================================================
// Halaman Edit Profil
// =============================================================================
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Isi kolom dari data pengguna yang sedang masuk.
    final u = UserSession.instance;
    _nameC.text = u.name;
    _emailC.text = u.email;
    _phoneC.text = u.phone;
  }

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    super.dispose();
  }

  void _simpan() {
    FocusScope.of(context).unfocus();

    if (_nameC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L.t('Nama tidak boleh kosong'))),
      );
      return;
    }

    UserSession.instance.updateProfile(
      name: _nameC.text.trim(),
      email: _emailC.text.trim(),
      phone: _phoneC.text.trim(),
    );

    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(content: Text(L.t('Perubahan berhasil disimpan'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final atas = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: context.pageBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ===== Header =====
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(36)),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_hijauMuda, _hijauTua],
                  ),
                ),
                child: Stack(
                  children: [
                    const Positioned(
                      top: -40,
                      right: -30,
                      child: _Lingkaran(ukuran: 130, alpha: 0.10),
                    ),
                    const Positioned(
                      bottom: -50,
                      left: -30,
                      child: _Lingkaran(ukuran: 150, alpha: 0.08),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(16, atas + 10, 16, 28),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () => Navigator.of(context).maybePop(),
                                borderRadius: BorderRadius.circular(20),
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(Icons.arrow_back,
                                      color: Colors.white, size: 22),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Tr(
                                'Edit Profil',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          // Inisial avatar ikut berubah saat nama diketik.
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _nameC,
                            builder: (_, v, __) =>
                                _Avatar(nama: v.text, ukuran: 88),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ===== Formulir =====
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Muncul(
                    urutan: 0,
                    child: _Kolom(
                      label: 'Nama Lengkap',
                      controller: _nameC,
                      type: TextInputType.name,
                      icon: Icons.person_outline_rounded,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Muncul(
                    urutan: 1,
                    child: _Kolom(
                      label: 'Email',
                      controller: _emailC,
                      type: TextInputType.emailAddress,
                      icon: Icons.mail_outline_rounded,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Muncul(
                    urutan: 2,
                    child: _Kolom(
                      label: 'No Telepon',
                      controller: _phoneC,
                      type: TextInputType.phone,
                      icon: Icons.phone_outlined,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _Muncul(
                    urutan: 3,
                    child: _TombolUtama(
                      icon: Icons.check_rounded,
                      teks: 'Simpan Perubahan',
                      onTap: _simpan,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Komponen bersama
// =============================================================================

/// Header hijau pada halaman Akun: tombol kembali, avatar, nama, kontak.
class _HeaderAkun extends StatelessWidget {
  final String nama;
  final String kontak;
  final VoidCallback onBack;
  final VoidCallback onEdit;

  const _HeaderAkun({
    required this.nama,
    required this.kontak,
    required this.onBack,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final atas = MediaQuery.of(context).padding.top;

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_hijauMuda, _hijauTua],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: -40,
              right: -30,
              child: _Lingkaran(ukuran: 130, alpha: 0.10),
            ),
            const Positioned(
              bottom: -50,
              left: -30,
              child: _Lingkaran(ukuran: 150, alpha: 0.08),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(16, atas + 10, 16, 28),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: onBack,
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.arrow_back,
                              color: Colors.white, size: 22),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Tr(
                        'Akun',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _Avatar(nama: nama, ukuran: 96, onEdit: onEdit),
                  const SizedBox(height: 14),
                  Text(
                    nama.isEmpty ? '-' : nama,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kontak,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mengambil inisial dari nama (maksimal dua huruf).
String _inisial(String nama) {
  final kata =
      nama.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
  if (kata.isEmpty) return '';
  if (kata.length == 1) return kata[0][0].toUpperCase();
  return (kata[0][0] + kata[1][0]).toUpperCase();
}

/// Avatar bulat berisi inisial. Jika [onEdit] diisi, muncul tombol pensil kecil.
class _Avatar extends StatelessWidget {
  final String nama;
  final double ukuran;
  final VoidCallback? onEdit;

  const _Avatar({required this.nama, required this.ukuran, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final inisial = _inisial(nama);

    final lingkaran = Container(
      width: ukuran,
      height: ukuran,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.6),
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: inisial.isEmpty
          ? Icon(Icons.person, size: ukuran * 0.55, color: _hijauTua)
          : Text(
              inisial,
              style: TextStyle(
                fontSize: ukuran * 0.36,
                fontWeight: FontWeight.w800,
                color: _hijauTua,
              ),
            ),
    );

    if (onEdit == null) return lingkaran;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        lingkaran,
        Positioned(
          right: -2,
          bottom: -2,
          child: GestureDetector(
            onTap: onEdit,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hijauMuda,
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: const Icon(Icons.edit, size: 15, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

/// Lingkaran dekoratif pada header.
class _Lingkaran extends StatelessWidget {
  final double ukuran;
  final double alpha;
  const _Lingkaran({required this.ukuran, required this.alpha});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ukuran,
      height: ukuran,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: alpha),
      ),
    );
  }
}

/// Kartu satu data (ikon + label + nilai).
class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: context.softBg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22, color: context.accent),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tr(
                  label,
                  style: TextStyle(fontSize: 11, color: context.textSub),
                ),
                const SizedBox(height: 3),
                Text(
                  value.isEmpty ? '-' : value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Tombol hijau bergradasi selebar layar.
class _TombolUtama extends StatelessWidget {
  final IconData icon;
  final String teks;
  final VoidCallback onTap;

  const _TombolUtama({
    required this.icon,
    required this.teks,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_hijauMuda, _hijauTua]),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _hijauTua.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Tr(
                teks,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kolom isian dengan label, ikon, dan bingkai bulat.
class _Kolom extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType type;
  final IconData icon;

  const _Kolom({
    required this.label,
    required this.controller,
    required this.type,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder garis(double lebar, double alpha) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: _hijauMuda.withValues(alpha: alpha),
            width: lebar,
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Tr(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: type,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            filled: true,
            fillColor: context.cardBg,
            prefixIcon: Icon(icon, color: _hijauMuda, size: 22),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: garis(1, 0.45),
            enabledBorder: garis(1, 0.45),
            focusedBorder: garis(1.8, 1),
          ),
        ),
      ],
    );
  }
}

/// Animasi muncul: memudar masuk sambil naik dari bawah.
/// [urutan] makin besar = muncul makin belakangan.
class _Muncul extends StatelessWidget {
  final int urutan;
  final Widget child;
  const _Muncul({required this.urutan, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 350 + urutan * 100),
      curve: Curves.easeOutCubic,
      builder: (context, nilai, child) => Opacity(
        opacity: nilai,
        child: Transform.translate(
          offset: Offset(0, 24 * (1 - nilai)),
          child: child,
        ),
      ),
      child: child,
    );
  }
}