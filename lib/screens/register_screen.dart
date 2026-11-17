import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/app_settings.dart';
import '../models/user_session.dart';
import '../theme/app_theme.dart';
import '../utils/l10n.dart';
import '../utils/validators.dart';
import '../widgets/gradient_button.dart';
import '../widgets/saga_logo.dart';
import 'login_screen.dart';
import 'main_shell.dart';
import 'onboarding_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _obscureConfirm = true;

  // Warna gradasi header mode terang (gelap -> terang)
  static const _dark = Color(0xFF0B5B3B);
  static const _mid = Color(0xFF4FA36A);
  static const _light = Color(0xFFE8F5E9);

  // ---------- Warna yang mengikuti tema aplikasi (terang / gelap) ----------
  bool get _isDark => context.isDark;
  Color get _pageBg => _isDark ? AppPalette.darkBg : Colors.white;
  Color? get _textColor => _isDark ? AppPalette.darkText : null;
  Color get _fieldBg => _isDark ? AppPalette.darkCard : Colors.white;
  Color get _hintColor => _isDark ? AppPalette.darkMuted : AppColors.textMuted;
  Color get _iconColor => _isDark ? AppPalette.darkMuted : AppColors.textDark;
  Color get _borderColor => _isDark ? AppPalette.darkLine : AppColors.border;
  Color get _titleColor => _isDark ? AppPalette.darkAccent : AppColors.primary;
  Color get _linkColor => _isDark ? AppPalette.darkAccent : AppColors.link;
  Color get _mutedColor => _isDark ? AppPalette.darkMuted : AppColors.textMuted;

  List<Color> get _frontColors => _isDark
      ? const [Color(0xFF0B5B3B), Color(0xFF14432E), AppPalette.darkBg]
      : const [_dark, _mid, _light];

  List<Color> get _backColors => _isDark
      ? const [Color(0xFF1B4D36), Color(0xFF2F6A4A)]
      : const [Color(0xFF2E7D4F), Color(0xFFA5D6A7)];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _contactCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  /// Menerjemahkan pesan error dari Validators sesuai bahasa terpilih.
  String? _tr(String? message) => message == null ? null : L.t(message);

  void _register() {
    // Berhenti di sini jika ada isian yang belum valid (pesan error tampil).
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    UserSession.instance.register(
      name: _nameCtrl.text,
      contact: _contactCtrl.text,
    );
    // TODO: sambungkan ke pendaftaran (API / Firebase).
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  void _goToLogin() {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
    } else {
      nav.pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _back() {
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
    } else {
      nav.pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    }
  }

  InputDecoration _decoration(String hint, IconData icon, {Widget? suffix}) {
    OutlineInputBorder outline(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: color),
        );
    const red = Color(0xFFC62828);
    return InputDecoration(
      fillColor: _fieldBg,
      filled: true,
      hintText: L.t(hint),
      hintStyle: TextStyle(fontSize: 12, color: _hintColor),
      prefixIcon: Icon(icon, size: 20, color: _iconColor),
      suffixIcon: suffix,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      errorStyle: const TextStyle(fontSize: 10, color: red, height: 1.2),
      errorMaxLines: 2,
      enabledBorder: outline(_borderColor),
      focusedBorder: outline(AppColors.primary),
      errorBorder: outline(red),
      focusedErrorBorder: outline(red),
    );
  }

  Widget _visibilityToggle(bool obscure, VoidCallback onTap) {
    return IconButton(
      iconSize: 18,
      color: _iconColor,
      icon: Icon(obscure
          ? Icons.visibility_off_outlined
          : Icons.visibility_outlined),
      onPressed: onTap,
    );
  }

  /// Hiasan rumput di bagian bawah; digelapkan di mode gelap.
  Widget _grass() {
    final image = Image.asset(
      'assets/images/grass.png',
      width: double.infinity,
      fit: BoxFit.fitWidth,
      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
    );
    if (!_isDark) return image;
    return ColorFiltered(
      colorFilter: const ColorFilter.mode(Color(0xB30F1713), BlendMode.srcATop),
      child: image,
    );
  }

  /// Header 2 lapis: lapisan belakang (hijau bergradasi) dan lapisan depan
  /// (gradasi hijau tua di atas, menyatu dengan latar halaman di bawah).
  Widget _header() {
    return Stack(
      children: [
        // Lapisan belakang
        Positioned.fill(
          child: ClipPath(
            clipper: _BackWaveClipper(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _backColors,
                ),
              ),
            ),
          ),
        ),
        // Lapisan depan + isi header
        Padding(
          padding: const EdgeInsets.only(bottom: 18),
          child: ClipPath(
            clipper: _HeaderWaveClipper(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 48),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _frontColors,
                  stops: const [0.0, 0.22, 0.5],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 4, top: 4),
                        child: IconButton(
                          onPressed: _back,
                          icon: const Icon(Icons.arrow_back,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    const SagaLogo(size: 72),
                    const SizedBox(height: 6),
                    Text(
                      L.t('SAGA TANI'),
                      style: TextStyle(
                        color: _titleColor,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      L.t('Masa Depan Pertanian, Bersama'),
                      style: TextStyle(
                        fontSize: 11,
                        color: _titleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Dibangun ulang otomatis saat bahasa atau tema diganti.
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, _) => AnnotatedRegion<SystemUiOverlayStyle>(
        // Ikon status bar (jam, baterai) putih agar terbaca di atas hijau tua
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: _pageBg,
          body: Container(
            width: double.infinity,
            height: double.infinity,
            color: _pageBg,
            child: Stack(
              children: [
                // Hiasan rumput di bawah (assets/images/grass.png, opsional)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _grass(),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _header(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              Text(
                                L.t('Daftar Akun'),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: _titleColor,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                L.t('Bergabunglah dengan SAGA TANI untuk\nmengelola pertanian Anda dengan lebih mudah.'),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.4,
                                  color: _mutedColor,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _nameCtrl,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                validator: (v) => _tr(Validators.name(v)),
                                style: TextStyle(
                                    fontSize: 12, color: _textColor),
                                decoration: _decoration(
                                    'Nama Lengkap', Icons.person_outline),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _contactCtrl,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: (v) =>
                                    _tr(Validators.emailOrPhone(v)) ??
                                    (UserSession.instance
                                            .isRegistered(v ?? '')
                                        ? L.t(
                                            'Akun ini sudah terdaftar, silakan masuk')
                                        : null),
                                style: TextStyle(
                                    fontSize: 12, color: _textColor),
                                decoration: _decoration('No. HP atau Email',
                                    Icons.smartphone_outlined),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _passCtrl,
                                obscureText: _obscure,
                                textInputAction: TextInputAction.next,
                                validator: (v) =>
                                    _tr(Validators.newPassword(v)),
                                style: TextStyle(
                                    fontSize: 12, color: _textColor),
                                decoration: _decoration(
                                  'Sandi',
                                  Icons.lock_outline,
                                  suffix: _visibilityToggle(
                                      _obscure,
                                      () => setState(
                                          () => _obscure = !_obscure)),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _confirmCtrl,
                                obscureText: _obscureConfirm,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _register(),
                                validator: (v) => _tr(
                                    Validators.confirm(v, _passCtrl.text)),
                                style: TextStyle(
                                    fontSize: 12, color: _textColor),
                                decoration: _decoration(
                                  'Ulangi Sandi',
                                  Icons.lock_outline,
                                  suffix: _visibilityToggle(
                                      _obscureConfirm,
                                      () => setState(() => _obscureConfirm =
                                          !_obscureConfirm)),
                                ),
                              ),
                              const SizedBox(height: 16),
                              GradientButton(
                                label: L.t('Daftar'),
                                onPressed: _register,
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                      child: Divider(color: _borderColor)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text(L.t('atau'),
                                        style: TextStyle(
                                            fontSize: 11, color: _textColor)),
                                  ),
                                  Expanded(
                                      child: Divider(color: _borderColor)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(L.t('Sudah punya akun? '),
                                      style: TextStyle(
                                          fontSize: 11, color: _mutedColor)),
                                  GestureDetector(
                                    onTap: _goToLogin,
                                    child: Text(
                                      L.t('Masuk di sini'),
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _linkColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 60),
                            ],
                          ),
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
    );
  }
}

/// Gelombang lapisan depan: turun di kiri, naik di kanan.
class _HeaderWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..lineTo(0, size.height - 28);
    path.quadraticBezierTo(
      size.width * 0.28, size.height + 6,
      size.width * 0.55, size.height - 22,
    );
    path.quadraticBezierTo(
      size.width * 0.82, size.height - 48,
      size.width, size.height - 20,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

/// Gelombang lapisan belakang: bentuknya berlawanan sehingga terlihat
/// sebagai pinggiran hijau di bawah lapisan depan.
class _BackWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()..lineTo(0, size.height - 34);
    path.quadraticBezierTo(
      size.width * 0.25, size.height - 62,
      size.width * 0.5, size.height - 30,
    );
    path.quadraticBezierTo(
      size.width * 0.78, size.height + 4,
      size.width, size.height - 12,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}