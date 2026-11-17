import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../models/user_session.dart';
import '../theme/app_theme.dart';
import '../utils/l10n.dart';
import '../utils/validators.dart';
import '../widgets/saga_logo.dart';
import '../widgets/tr.dart';
import 'login_screen.dart';

// =============================================================================
// Model kecil untuk menyusun menu
// =============================================================================

/// Satu baris menu pada halaman pengaturan.
class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  /// Keterangan di sisi kanan (opsional).
  final String? value;

  /// `false` untuk teks yang tidak boleh diterjemahkan, mis. nama bahasa.
  final bool translateValue;

  /// Pengganti panah, mis. saklar (opsional).
  final Widget? trailing;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.value,
    this.translateValue = true,
    this.trailing,
  });
}

/// Sekelompok menu dengan satu judul kelompok.
class _MenuSection {
  final String label;
  final List<_MenuItem> items;
  const _MenuSection(this.label, this.items);
}

/// Satu pasang pertanyaan dan jawaban di Pusat Bantuan.
class _Faq {
  final String question;
  final String answer;
  const _Faq(this.question, this.answer);
}

const _faqs = [
  _Faq(
    'Bagaimana cara kerja perangkat?',
    'Sensor mendeteksi pergerakan tikus, lalu perangkat mengeluarkan suara '
        'pengusir. Semua aktivitas tercatat di Riwayat.',
  ),
  _Faq(
    'Perangkat saya tidak terhubung',
    'Pastikan perangkat menyala dan berada dalam jangkauan Wi-Fi. '
        'Coba matikan lalu nyalakan kembali perangkat.',
  ),
  _Faq(
    'Bagaimana mengganti suara pengusir?',
    'Buka Beranda, pilih bagian Pemilihan Suara, lalu pilih suara yang '
        'diinginkan atau Mode Acak.',
  ),
  _Faq(
    'Apa bedanya mode Otomatis dan Manual?',
    'Otomatis: perangkat bekerja sendiri saat tikus terdeteksi. '
        'Manual: kamu yang mengaktifkan pengusir.',
  ),
];

const _sheetShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
);

const _dialogShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
);

// =============================================================================
// Halaman Pengaturan
// =============================================================================

class SettingsScreen extends StatelessWidget {
  /// Dipanggil saat menu "Informasi Akun" ditekan
  /// (di MainShell: membuka tab Akun).
  final VoidCallback? onOpenAccount;

  const SettingsScreen({super.key, this.onOpenAccount});

  // ---------------------------------------------------------------------------
  // Daftar menu
  // ---------------------------------------------------------------------------
  List<_MenuSection> _sections(BuildContext context, AppSettings s) {
    return [
      _MenuSection('Akun', [
        _MenuItem(
          icon: Icons.account_circle_outlined,
          title: 'Informasi Akun',
          onTap: () => onOpenAccount?.call(),
        ),
        _MenuItem(
          icon: Icons.lock_outline,
          title: 'Kata Sandi & Keamanan',
          onTap: () => _changePassword(context),
        ),
        _MenuItem(
          icon: Icons.notifications_none,
          title: 'Notifikasi',
          onTap: () => s.notifications = !s.notifications,
          trailing: _notificationSwitch(s),
        ),
        _MenuItem(
          icon: Icons.language,
          title: 'Bahasa',
          value: s.languageLabel,
          translateValue: false, // nama bahasa tampil apa adanya
          onTap: () => _pickOne(
            context,
            title: 'Pilih Bahasa',
            options: AppSettings.languages,
            selected: s.language,
            translateOptions: false,
            onSelected: (i) => s.language = i,
          ),
        ),
      ]),
      _MenuSection('Preferensi', [
        _MenuItem(
          icon: Icons.sensors,
          title: 'Sensor',
          value: s.sensitivityLabel,
          onTap: () => _pickOne(
            context,
            title: 'Sensitivitas Sensor',
            options: AppSettings.sensitivityLabels,
            selected: s.sensitivity,
            onSelected: (i) => s.sensitivity = i,
          ),
        ),
        _MenuItem(
          icon: Icons.brightness_6_outlined,
          title: 'Tema',
          value: s.isDark ? 'Gelap' : 'Terang',
          onTap: () => _pickOne(
            context,
            title: 'Tema',
            options: const ['Terang', 'Gelap'],
            selected: s.isDark ? 1 : 0,
            onSelected: (i) => s.dark = i == 1,
          ),
        ),
        _MenuItem(
          icon: Icons.info_outline,
          title: 'Tentang Aplikasi',
          value: 'Versi 1.0.0',
          onTap: () => _showAbout(context),
        ),
      ]),
      _MenuSection('Dukungan', [
        _MenuItem(
          icon: Icons.help_outline,
          title: 'Pusat Bantuan',
          onTap: () => _showHelp(context),
        ),
      ]),
    ];
  }

  Widget _notificationSwitch(AppSettings s) {
    return Transform.scale(
      scale: 0.8,
      child: Switch(
        value: s.notifications,
        activeTrackColor: AppColors.online,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        onChanged: (v) => s.notifications = v,
      ),
    );
  }

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
            child: const Tr(
              'Batal',
              style: TextStyle(color: AppColors.textMuted),
            ),
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
            child: Tr(
              'Keluar',
              style: TextStyle(
                color: ctx.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _changePassword(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => const _ChangePasswordDialog(),
    );
    if (ok == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(L.t('Kata sandi berhasil diubah'))),
      );
    }
  }

  /// Lembar pilihan: pilih salah satu dari beberapa opsi.
  ///
  /// [translateOptions] diisi `false` untuk daftar yang tidak perlu
  /// diterjemahkan, misalnya nama-nama bahasa.
  void _pickOne(
    BuildContext context, {
    required String title,
    required List<String> options,
    required int selected,
    required ValueChanged<int> onSelected,
    bool translateOptions = true,
  }) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.cardBg,
      shape: _sheetShape,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _sheetTop(ctx, title),
            for (int i = 0; i < options.length; i++)
              ListTile(
                title: _label(
                  options[i],
                  TextStyle(
                    fontSize: 13,
                    fontWeight:
                        i == selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                  translate: translateOptions,
                ),
                trailing: i == selected
                    ? const Icon(Icons.check_circle, color: AppColors.online)
                    : null,
                onTap: () {
                  onSelected(i);
                  Navigator.of(ctx).pop();
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: _dialogShape,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SagaLogo(size: 72),
            const SizedBox(height: 10),
            Text(
              'Saga Tani',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ctx.accent,
              ),
            ),
            const SizedBox(height: 2),
            const Tr(
              'Versi 1.0.0',
              style: TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
            const SizedBox(height: 12),
            const Tr(
              'Aplikasi pemantauan perangkat repelan hama tikus berbasis IoT '
              'untuk membantu petani menjaga sawah.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Tr(
              'Tutup',
              style: TextStyle(
                color: ctx.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    final maxHeight = MediaQuery.of(context).size.height * 0.7;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.cardBg,
      isScrollControlled: true,
      shape: _sheetShape,
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _sheetTop(ctx, 'Pusat Bantuan'),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 16),
                  children: [
                    for (final faq in _faqs)
                      ExpansionTile(
                        shape: const Border(),
                        collapsedShape: const Border(),
                        iconColor: ctx.accent,
                        textColor: ctx.accent,
                        title: Tr(
                          faq.question,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        childrenPadding:
                            const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        expandedAlignment: Alignment.centerLeft,
                        children: [
                          Tr(
                            faq.answer,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Potongan tampilan yang dipakai ulang
  // ---------------------------------------------------------------------------

  /// Teks yang otomatis diterjemahkan, atau apa adanya bila [translate] false.
  Widget _label(String text, TextStyle style, {bool translate = true}) {
    return translate ? Tr(text, style: style) : Text(text, style: style);
  }

  /// Bagian atas lembar (garis kecil + judul).
  Widget _sheetTop(BuildContext context, String title) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: context.isDark ? AppPalette.darkLine : AppColors.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Tr(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: context.accent,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Tampilan
  // ---------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.pageBg,
      // Dibangun ulang saat data pengguna ATAU pengaturan (bahasa, tema) berubah.
      body: AnimatedBuilder(
        animation:
            Listenable.merge([UserSession.instance, AppSettings.instance]),
        builder: (context, _) {
          final sections = _sections(context, AppSettings.instance);
          return SingleChildScrollView(
            child: Column(
              children: [
                _header(context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _userCard(context),
                      const SizedBox(height: 22),
                      for (final section in sections) ...[
                        _sectionLabel(context, section.label),
                        _sectionCard(context, section.items),
                        const SizedBox(height: 22),
                      ],
                      _logoutButton(context),
                      const SizedBox(height: 14),
                      const Center(
                        child: Tr(
                          'Saga Tani  •  Versi 1.0.0',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.textMuted,
                          ),
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

  /// Satu lapisan gelombang header.
  Widget _waveLayer(CustomClipper<Path> clipper, Color color) {
    return Positioned.fill(
      child: ClipPath(
        clipper: clipper,
        child: ColoredBox(color: color),
      ),
    );
  }

  /// Header hijau dengan tiga lapisan gelombang (makin ke bawah makin terang).
  Widget _header(BuildContext context) {
    final dark = context.isDark;
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
          padding: const EdgeInsets.only(bottom: 54),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 0),
              child: Row(
                children: [
                  const SagaLogo(size: 62),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Saga Tani',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: context.accent,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Tr(
                          'Solusi para petani',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Kartu data pengguna: foto, nama, email / no. HP, dan label peran.
  Widget _userCard(BuildContext context) {
    final user = UserSession.instance;
    return Material(
      color: context.cardBg,
      elevation: 2,
      shadowColor: AppColors.shadow,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: Color(0xFFD9D9D9),
              child: Icon(Icons.person, size: 34, color: Colors.black87),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.contact,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10, color: context.textSub),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Tr(
                      'Pengguna',
                      style: TextStyle(color: Colors.white, fontSize: 9),
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

  Widget _sectionLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Tr(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: context.accent,
        ),
      ),
    );
  }

  /// Satu kelompok menu dalam kartu, dipisah garis tipis.
  Widget _sectionCard(BuildContext context, List<_MenuItem> items) {
    return Material(
      color: context.cardBg,
      elevation: 2,
      shadowColor: AppColors.shadow,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _tile(context, items[i]),
            if (i != items.length - 1)
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

  Widget _tile(BuildContext context, _MenuItem item) {
    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: context.softBg,
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, size: 18, color: context.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Tr(
                item.title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (item.trailing != null)
              item.trailing!
            else ...[
              if (item.value != null) ...[
                _label(
                  item.value!,
                  const TextStyle(fontSize: 9, color: AppColors.textMuted),
                  translate: item.translateValue,
                ),
                const SizedBox(width: 4),
              ],
              Icon(Icons.chevron_right, size: 18, color: context.textSub),
            ],
          ],
        ),
      ),
    );
  }

  Widget _logoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _confirmLogout(context),
          child: const Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.logout, size: 18, color: Colors.white),
                SizedBox(width: 8),
                Tr(
                  'Keluar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Dialog ubah kata sandi
// =============================================================================

/// Dialog ubah kata sandi (sandi lama, sandi baru, konfirmasi).
class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _oldController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _hide = true;

  @override
  void dispose() {
    _oldController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: kirim sandi baru ke server jika sudah ada backend.
    Navigator.of(context).pop(true);
  }

  /// Menerjemahkan pesan error validator (null tetap null).
  String? _translate(String? error) => error == null ? null : L.t(error);

  InputDecoration _decoration(String label, {bool toggle = false}) {
    OutlineInputBorder border(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    const green = Color(0xFF1B8F5A);
    return InputDecoration(
      labelText: L.t(label),
      labelStyle: const TextStyle(fontSize: 11),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      enabledBorder: border(green),
      focusedBorder: border(green, 1.4),
      errorBorder: border(Colors.red.shade700),
      focusedErrorBorder: border(Colors.red.shade700, 1.4),
      suffixIcon: toggle
          ? IconButton(
              iconSize: 18,
              icon: Icon(_hide ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _hide = !_hide),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: _dialogShape,
      title: const Tr('Ubah Kata Sandi', style: TextStyle(fontSize: 16)),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _oldController,
                obscureText: _hide,
                style: const TextStyle(fontSize: 12),
                decoration: _decoration('Sandi lama', toggle: true),
                validator: (v) => _translate(Validators.loginPassword(v)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _newController,
                obscureText: _hide,
                style: const TextStyle(fontSize: 12),
                decoration: _decoration('Sandi baru'),
                validator: (v) => _translate(Validators.newPassword(v)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                obscureText: _hide,
                style: const TextStyle(fontSize: 12),
                decoration: _decoration('Konfirmasi sandi baru'),
                validator: (v) => v == _newController.text
                    ? null
                    : L.t('Konfirmasi sandi tidak sama'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Tr(
            'Batal',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
        TextButton(
          onPressed: _submit,
          child: Tr(
            'Simpan',
            style: TextStyle(
              color: context.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Potongan gelombang header
// =============================================================================

/// Potongan gelombang untuk satu lapisan header.
///
/// Empat angka = jarak tepi bawah dari dasar header: kiri, kontrol 1,
/// kontrol 2, dan kanan (membentuk gelombang berbentuk huruf S).
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