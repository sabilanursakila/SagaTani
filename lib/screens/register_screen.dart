import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/user_session.dart';
import '../theme/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/gradient_button.dart';
import '../widgets/saga_logo.dart';
import 'login_screen.dart';
import 'main_shell.dart';
import 'onboarding_screen.dart';
import '../widgets/tr.dart';

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

  // Warna gradasi header (gelap -> terang)
  static const _dark = Color(0xFF0B5B3B);
  static const _mid = Color(0xFF4FA36A);
  static const _light = Color(0xFFE8F5E9);

  @override
  void dispose() {
    _nameCtrl.dispose();
    _contactCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

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
      fillColor: Colors.white,
      filled: true,
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: AppColors.textMuted),
      prefixIcon: Icon(icon, size: 20, color: AppColors.textDark),
      suffixIcon: suffix,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      errorStyle: const TextStyle(fontSize: 10, color: red, height: 1.2),
      errorMaxLines: 2,
      enabledBorder: outline(AppColors.border),
      focusedBorder: outline(AppColors.primary),
      errorBorder: outline(red),
      focusedErrorBorder: outline(red),
    );
  }

  Widget _visibilityToggle(bool obscure, VoidCallback onTap) {
    return IconButton(
      iconSize: 18,
      icon: Icon(obscure
          ? Icons.visibility_off_outlined
          : Icons.visibility_outlined),
      onPressed: onTap,
    );
  }

  /// Header 2 lapis: lapisan belakang (hijau bergradasi) dan lapisan depan
  /// (gradasi hijau tua di atas ke hijau terang di bawah).
  Widget _header() {
    return Stack(
      children: [
        // Lapisan belakang
        Positioned.fill(
          child: ClipPath(
            clipper: _BackWaveClipper(),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2E7D4F), Color(0xFFA5D6A7)],
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
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_dark, _mid, _light],
                  stops: [0.0, 0.22, 0.5],
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
                    const Text(
                      'SAGA TANI',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Masa Depan Pertanian, Bersama',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      // Ikon status bar (jam, baterai) putih agar terbaca di atas hijau tua
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Hiasan rumput di bawah (assets/images/grass.png, opsional)
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                'assets/images/grass.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
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
                          const Text(
                            'Daftar Akun',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Bergabunglah dengan SAGA TANI untuk\nmengelola pertanian Anda dengan lebih mudah.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.4,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _nameCtrl,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            validator: Validators.name,
                            style: const TextStyle(fontSize: 12),
                            decoration: _decoration(
                                'Nama Lengkap', Icons.person_outline),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _contactCtrl,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (v) =>
                                Validators.emailOrPhone(v) ??
                                (UserSession.instance.isRegistered(v ?? '')
                                    ? 'Akun ini sudah terdaftar, silakan masuk'
                                    : null),
                            style: const TextStyle(fontSize: 12),
                            decoration: _decoration('No. HP atau Email',
                                Icons.smartphone_outlined),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _passCtrl,
                            obscureText: _obscure,
                            textInputAction: TextInputAction.next,
                            validator: Validators.newPassword,
                            style: const TextStyle(fontSize: 12),
                            decoration: _decoration(
                              'Sandi',
                              Icons.lock_outline,
                              suffix: _visibilityToggle(_obscure,
                                  () => setState(() => _obscure = !_obscure)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _confirmCtrl,
                            obscureText: _obscureConfirm,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _register(),
                            validator: (v) =>
                                Validators.confirm(v, _passCtrl.text),
                            style: const TextStyle(fontSize: 12),
                            decoration: _decoration(
                              'Ulangi Sandi',
                              Icons.lock_outline,
                              suffix: _visibilityToggle(
                                  _obscureConfirm,
                                  () => setState(() =>
                                      _obscureConfirm = !_obscureConfirm)),
                            ),
                          ),
                          const SizedBox(height: 16),
                          GradientButton(
                            label: 'Daftar',
                            onPressed: _register,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: const [
                              Expanded(
                                  child: Divider(color: AppColors.border)),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text('atau',
                                    style: TextStyle(fontSize: 11)),
                              ),
                              Expanded(
                                  child: Divider(color: AppColors.border)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Sudah punya akun? ',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted)),
                              GestureDetector(
                                onTap: _goToLogin,
                                child: const Text(
                                  'Masuk di sini',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.link,
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