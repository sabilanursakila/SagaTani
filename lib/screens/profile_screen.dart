import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../models/user_session.dart';
import '../theme/app_theme.dart';
import '../utils/l10n.dart';
import '../utils/validators.dart';
import '../widgets/tr.dart';
import 'login_screen.dart';

/// Halaman Akun: profil pengguna, ringkasan, informasi akun, dan perangkat.
class ProfileScreen extends StatelessWidget {
  /// Dipanggil saat kartu "Perangkat Saya" ditekan (opsional).
  final VoidCallback? onOpenDevice;

  const ProfileScreen({super.key, this.onOpenDevice});

  static const _dialogShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(16)),
  );

  /// Teks dua bahasa langsung di tempat (untuk teks yang tidak ada di kamus).
  String _t(String id, String en) => AppSettings.instance.isEnglish ? en : id;

  // ---------------------------------------------------------------------------
  // Aksi
  // ---------------------------------------------------------------------------
  void _confirmLogout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: _dialogShape,
        title: const Tr('Keluar dari akun?', style: TextStyle(fontSize: 16)),
        content: const Tr(
          'Kamu perlu masuk lagi untuk memakai aplikasi.',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Tr('Batal',
                style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              UserSession.instance.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: Tr('Keluar',
                style: TextStyle(
                    color: ctx.accent, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Future<void> _editProfile(BuildContext context) async {
    final user = UserSession.instance;
    final newName = await showDialog<String>(
      context: context,
      builder: (_) => _EditProfileDialog(initialName: user.name),
    );
    if (newName == null || !context.mounted) return;

    // TODO: simpan ke server jika sudah ada backend.
    user.register(name: newName, contact: user.contact);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(L.t('Perubahan berhasil disimpan'))),
    );
  }

  // ---------------------------------------------------------------------------
  // Tampilan
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pageBg,
      body: AnimatedBuilder(
        animation:
            Listenable.merge([UserSession.instance, AppSettings.instance]),
        builder: (context, _) {
          final user = UserSession.instance;
          return SingleChildScrollView(
            child: Column(
              children: [
                _header(context, user),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _statsRow(context),
                      const SizedBox(height: 22),
                      _sectionLabel(context, L.t('Informasi Akun')),
                      _infoCard(context, user),
                      const SizedBox(height: 22),
                      _sectionLabel(context, _t('Perangkat Saya', 'My Device')),
                      _deviceCard(),
                      const SizedBox(height: 26),
                      _logoutButton(context),
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

  /// Satu lapisan gelombang header.
  Widget _waveLayer(CustomClipper<Path> clipper, Color color) {
    return Positioned.fill(
      child: ClipPath(
        clipper: clipper,
        child: ColoredBox(color: color),
      ),
    );
  }

  /// Header bergelombang: judul, foto profil, nama, kontak, peran, edit.
  Widget _header(BuildContext context, UserSession user) {
    final dark = context.isDark;
    final name = user.name.trim();
    final initial = name.isEmpty ? '' : name.characters.first.toUpperCase();

    return Stack(
      children: [
        _waveLayer(
          const _LayerWaveClipper(10, -6, 24, 2),
          dark ? const Color(0xFF14231B) : const Color(0xFFE9FFEA),
        ),
        _waveLayer(
          const _LayerWaveClipper(26, 4, 42, 16),
          dark ? const Color(0xFF193024) : const Color(0xFFC9FACB),
        ),
        _waveLayer(
          const _LayerWaveClipper(44, 20, 60, 34),
          dark ? const Color(0xFF1F3D2D) : const Color(0xFFA6F5A9),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 62),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      L.t('Akun'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: context.accent,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _avatar(context, initial),
                  const SizedBox(height: 12),
                  Text(
                    name.isEmpty ? '-' : name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: context.textMain,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.contact,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: context.textSub),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_user_outlined,
                                size: 12, color: Colors.white),
                            SizedBox(width: 5),
                            Tr('Pengguna',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 10)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _editProfile(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: context.accent),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.edit_outlined,
                                  size: 12, color: context.accent),
                              const SizedBox(width: 5),
                              Text(L.t('Edit Profil'),
                                  style: TextStyle(
                                      color: context.accent, fontSize: 10)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Foto profil: lingkaran inisial dengan cincin dan lencana kamera.
  Widget _avatar(BuildContext context, String initial) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF58A046), Color(0xFF0B5B3B)],
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.pageBg,
            ),
            child: CircleAvatar(
              radius: 40,
              backgroundColor: context.softBg,
              child: initial.isEmpty
                  ? Icon(Icons.person, size: 44, color: context.accent)
                  : Text(
                      initial,
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                        color: context.accent,
                      ),
                    ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 2,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: context.pageBg, width: 2),
            ),
            // TODO: sambungkan ke pemilih foto.
            child:
                const Icon(Icons.camera_alt, size: 13, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Statistik
  // ---------------------------------------------------------------------------
  Widget _statsRow(BuildContext context) {
    final dark = context.isDark;
    // TODO: ganti angka dengan data asli dari perangkat / Riwayat.
    return Row(
      children: [
        Expanded(
          child: _statCard(
            context,
            icon: Icons.router_outlined,
            value: '1',
            label: L.t('Perangkat'),
            fg: const Color(0xFF2E9E4F),
            bg: dark ? const Color(0xFF22362B) : const Color(0xFFE3F6E4),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            context,
            icon: Icons.history,
            value: '12',
            label: _t('Aktivitas', 'Activity'),
            fg: const Color(0xFF2F80ED),
            bg: dark ? const Color(0xFF1E2E44) : const Color(0xFFE3F0FF),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            context,
            icon: Icons.shield_outlined,
            value: '8',
            label: _t('Terusir', 'Repelled'),
            fg: const Color(0xFFF2994A),
            bg: dark ? const Color(0xFF3A3020) : const Color(0xFFFFF1D6),
          ),
        ),
      ],
    );
  }

  Widget _statCard(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required Color fg,
    required Color bg,
  }) {
    return Material(
      color: context.cardBg,
      elevation: 2,
      shadowColor: AppColors.shadow,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, size: 18, color: fg),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: context.textMain,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 9, color: context.textSub),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Informasi akun
  // ---------------------------------------------------------------------------
  Widget _sectionLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: context.accent,
        ),
      ),
    );
  }

  Widget _infoCard(BuildContext context, UserSession user) {
    final dark = context.isDark;
    final isEmail = user.contact.contains('@');
    final rows = <Widget>[
      _infoRow(
        context,
        icon: Icons.person_outline,
        label: L.t('Nama Lengkap'),
        value: user.name.isEmpty ? '-' : user.name,
        fg: const Color(0xFF2E9E4F),
        bg: dark ? const Color(0xFF22362B) : const Color(0xFFE3F6E4),
      ),
      _infoRow(
        context,
        icon: isEmail ? Icons.mail_outline : Icons.phone_outlined,
        label: L.t(isEmail ? 'Email' : 'No Telepon'),
        value: user.contact.isEmpty ? '-' : user.contact,
        fg: const Color(0xFF2F80ED),
        bg: dark ? const Color(0xFF1E2E44) : const Color(0xFFE3F0FF),
      ),
      _infoRow(
        context,
        icon: Icons.badge_outlined,
        label: _t('Peran', 'Role'),
        value: L.t('Pengguna'),
        fg: const Color(0xFF9B51E0),
        bg: dark ? const Color(0xFF2E2440) : const Color(0xFFF0E6FB),
      ),
      _infoRow(
        context,
        icon: Icons.verified_outlined,
        label: _t('Status Akun', 'Account Status'),
        value: L.t('Aktif'),
        fg: const Color(0xFFF2994A),
        bg: dark ? const Color(0xFF3A3020) : const Color(0xFFFFF1D6),
        valueColor: AppColors.online,
      ),
    ];

    return Material(
      color: context.cardBg,
      elevation: 2,
      shadowColor: AppColors.shadow,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < rows.length; i++) ...[
            rows[i],
            if (i != rows.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                indent: 62,
                endIndent: 14,
                color: context.lineColor,
              ),
          ],
        ],
      ),
    );
  }

  Widget _infoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color fg,
    required Color bg,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, size: 18, color: fg),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 9, color: context.textSub)),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: valueColor ?? context.textMain,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Perangkat & keluar
  // ---------------------------------------------------------------------------
  Widget _deviceCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF58A046), Color(0xFF0B5B3B)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40245A28),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onOpenDevice,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0x33FFFFFF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.home_outlined,
                      size: 26, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('R-001',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.circle,
                              size: 7, color: Color(0xFF4CD964)),
                          const SizedBox(width: 5),
                          Text(L.t('Online'),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10)),
                          const SizedBox(width: 12),
                          const Icon(Icons.battery_full,
                              size: 13, color: Colors.white),
                          const SizedBox(width: 3),
                          const Text('87%',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 10)),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46,
      child: OutlinedButton.icon(
        onPressed: () => _confirmLogout(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFE05A5A),
          side: const BorderSide(color: Color(0xFFE05A5A), width: 1.2),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.logout, size: 18),
        label: Text(
          L.t('Keluar'),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

// =============================================================================
// Dialog edit profil
// =============================================================================

class _EditProfileDialog extends StatefulWidget {
  final String initialName;
  const _EditProfileDialog({required this.initialName});

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl =
      TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(_nameCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, [double width = 1]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: color, width: width),
        );
    const green = Color(0xFF1B8F5A);

    return AlertDialog(
      shape: ProfileScreen._dialogShape,
      title: const Tr('Edit Profil', style: TextStyle(fontSize: 16)),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _nameCtrl,
          textCapitalization: TextCapitalization.words,
          style: const TextStyle(fontSize: 12),
          validator: (v) {
            final error = Validators.name(v);
            return error == null ? null : L.t(error);
          },
          decoration: InputDecoration(
            labelText: L.t('Nama Lengkap'),
            labelStyle: const TextStyle(fontSize: 11),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: border(green),
            focusedBorder: border(green, 1.4),
            errorBorder: border(Colors.red.shade700),
            focusedErrorBorder: border(Colors.red.shade700, 1.4),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child:
              const Tr('Batal', style: TextStyle(color: AppColors.textMuted)),
        ),
        TextButton(
          onPressed: _submit,
          child: Tr('Simpan',
              style: TextStyle(
                  color: context.accent, fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }
}

// =============================================================================
// Potongan gelombang header
// =============================================================================

/// Potongan gelombang untuk satu lapisan header.
class _LayerWaveClipper extends CustomClipper<Path> {
  final double left;
  final double control1;
  final double control2;
  final double right;

  const _LayerWaveClipper(this.left, this.control1, this.control2, this.right);

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()..lineTo(0, h - left);
    path.cubicTo(w * 0.3, h - control1, w * 0.7, h - control2, w, h - right);
    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _LayerWaveClipper old) =>
      old.left != left ||
      old.control1 != control1 ||
      old.control2 != control2 ||
      old.right != right;
}