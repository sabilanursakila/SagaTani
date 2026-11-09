import 'package:flutter/material.dart';

import '../models/user_session.dart';
import '../theme/app_theme.dart';
import '../utils/l10n.dart';
import '../widgets/tr.dart';
import '../widgets/tr.dart';


/// Tab Akun.
/// Tampilan awal: Informasi Akun (ringkasan data + satu menu).
/// Jika menu "Informasi Akun" ditekan, masuk ke form Edit Profil.
/// Navigasi bawah dipegang oleh MainShell, jadi tidak ada di sini.
class ProfileScreen extends StatefulWidget {
  /// Dipanggil saat panah kembali ditekan di halaman Informasi Akun
  /// (di MainShell: kembali ke Beranda).
  final VoidCallback? onBack;
  const ProfileScreen({super.key, this.onBack});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const _green = Color(0xFF0B5F3F); // tombol
  static const _outline = Color(0xFF1B8F5A); // garis kolom isian

  bool _editing = false;

  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();

  @override
  void dispose() {
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    super.dispose();
  }

  /// Isi kolom form dari data pengguna yang sedang masuk.
  void _fillForm() {
    final u = UserSession.instance;
    _nameC.text = u.name;
    _emailC.text = u.email;
    _phoneC.text = u.phone;
  }

  void _openEdit() {
    _fillForm();
    setState(() => _editing = true);
  }

  void _closeEdit() {
    FocusScope.of(context).unfocus();
    setState(() => _editing = false);
  }

  void _save() {
    FocusScope.of(context).unfocus();
    UserSession.instance.updateProfile(
      name: _nameC.text,
      email: _emailC.text,
      phone: _phoneC.text,
    );
    setState(() => _editing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(L.t('Perubahan berhasil disimpan'))),
    );
  }

  void _backFromInfo() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _editing ? _editView() : _infoView();
  }

  // ---------------------------------------------------------------------------
  // Tampilan 1: Informasi Akun
  // ---------------------------------------------------------------------------
  Widget _infoView() {
    return Scaffold(
      backgroundColor: context.pageBg,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: UserSession.instance,
          builder: (context, _) {
            final u = UserSession.instance;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _topBar('Akun', _backFromInfo),
                  const SizedBox(height: 24),
                  const Center(
                    child: CircleAvatar(
                      radius: 36,
                      backgroundColor: Color(0xFFD9D9D9),
                      child: Icon(Icons.person, size: 52, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(u.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                  const SizedBox(height: 2),
                  Center(
                    child: Text(u.contact,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 10, color: context.textSub)),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 8),
                    child: Tr('Akun',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: context.accent)),
                  ),
                  Material(
                    color: context.cardBg,
                    elevation: 2,
                    shadowColor: AppColors.shadow,
                    borderRadius: BorderRadius.circular(14),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: _openEdit,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                color: context.softBg,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.account_circle_outlined,
                                  size: 18, color: context.accent),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Tr('Informasi Akun',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500)),
                            ),
                            Icon(Icons.chevron_right,
                                size: 18, color: context.textSub),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _infoRow('Nama Lengkap', u.name),
                  const SizedBox(height: 8),
                  _infoRow('Email', u.email.isEmpty ? '-' : u.email),
                  const SizedBox(height: 8),
                  _infoRow('No Telepon', u.phone.isEmpty ? '-' : u.phone),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Material(
      color: context.cardBg,
      elevation: 1,
      shadowColor: AppColors.shadow,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Tr(label,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textMuted)),
            ),
            Flexible(
              child: Text(value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Tampilan 2: Edit Profil (sesuai gambar desain)
  // ---------------------------------------------------------------------------
  Widget _editView() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _topBar('Edit Profil', _closeEdit),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    const Center(
                      child: CircleAvatar(
                        radius: 36,
                        backgroundColor: Color(0xFFD9D9D9),
                        child:
                            Icon(Icons.person, size: 52, color: Colors.black),
                      ),
                    ),
                    const SizedBox(height: 40),
                    _label('Nama Lengkap'),
                    _field(_nameC, TextInputType.name),
                    const SizedBox(height: 14),
                    _label('Email'),
                    _field(_emailC, TextInputType.emailAddress),
                    const SizedBox(height: 14),
                    _label('No Telepon'),
                    _field(_phoneC, TextInputType.phone),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: _saveButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar(String title, VoidCallback onBack) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            child: Icon(Icons.arrow_back, size: 22, color: context.iconColor),
          ),
          const SizedBox(width: 14),
          Tr(title,
              style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(left: 2, bottom: 5),
        child: Tr(text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      );

  Widget _field(TextEditingController c, TextInputType type) {
    return SizedBox(
      height: 26,
      child: TextField(
        controller: c,
        keyboardType: type,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 30, vertical: 6),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: _outline, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: _outline, width: 1.4),
          ),
        ),
      ),
    );
  }

  Widget _saveButton() {
    return Container(
      width: double.infinity,
      height: 38,
      decoration: BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
              color: Color(0x40000000), blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: _save,
          child: const Center(
            child: Tr('Simpan Perubahan',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}