import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/app_settings.dart';
import '../models/user_session.dart';
import '../theme/app_theme.dart';
import '../utils/google_auth_service.dart';
import '../utils/l10n.dart';
import '../utils/validators.dart';
import '../widgets/gradient_button.dart';
import '../widgets/saga_logo.dart';
import 'main_shell.dart';
import 'onboarding_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _remember = true;
  bool _obscure = true;
  bool _googleLoading = false;

  // Warna gradasi header (gelap -> terang)
  static const _dark = Color(0xFF0B5B3B);
  static const _mid = Color(0xFF4FA36A);
  static const _light = Color(0xFFE8F5E9);

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  /// Menerjemahkan pesan error dari Validators sesuai bahasa terpilih.
  String? _tr(String? message) => message == null ? null : L.t(message);

  /// Teks dua bahasa langsung di tempat (untuk pesan yang tidak ada di kamus).
  String _t(String id, String en) => AppSettings.instance.isEnglish ? en : id;

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(msg)));
  }

  void _login() {
    // Berhenti di sini jika ada isian yang belum valid (pesan error tampil).
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();

    UserSession.instance.login(_emailCtrl.text);
    // TODO: sambungkan ke autentikasi (API / Firebase).
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  Future<void> _loginWithGoogle() async {
    if (_googleLoading) return;
    FocusScope.of(context).unfocus();
    setState(() => _googleLoading = true);

    try {
      final account = await GoogleAuthService.instance.signIn();
      if (!mounted) return;

      // Pengguna menutup pilihan akun: tidak perlu pesan apa pun.
      if (account == null) return;

      final displayName = (account.displayName ?? '').trim();
      UserSession.instance.register(
        name: displayName.isEmpty ? account.email.split('@').first : displayName,
        contact: account.email,
      );
      // TODO: kirim account.id / token ke server jika sudah ada backend.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    } on PlatformException catch (e) {
      if (!mounted) return;
      final text = '${e.code} ${e.message ?? ''}';
      if (e.code == 'sign_in_canceled') return;
      if (e.code == 'network_error') {
        _snack(_t('Tidak ada koneksi internet.', 'No internet connection.'));
      } else if (text.contains('ApiException: 10') ||
          e.code == 'sign_in_failed') {
        _snack(_t(
          'Login Google belum dikonfigurasi. Periksa SHA-1 dan package name di Google Cloud.',
          'Google sign-in is not configured yet. Check SHA-1 and package name in Google Cloud.',
        ));
      } else {
        _snack('${_t('Gagal masuk dengan Google', 'Google sign-in failed')}: ${e.code}');
      }
    } catch (e) {
      if (!mounted) return;
      _snack(_t('Gagal masuk dengan Google', 'Google sign-in failed'));
    } finally {
      if (mounted) setState(() => _googleLoading = false);
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
      hintText: L.t(hint),
      hintStyle: const TextStyle(fontSize: 12, color: AppColors.textDark),
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
                    Text(
                      L.t('SAGA TANI'),
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      L.t('Masa Depan Pertanian, Bersama'),
                      style: const TextStyle(
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
    // Dibangun ulang otomatis saat bahasa diganti.
    return AnimatedBuilder(
      animation: AppSettings.instance,
      builder: (context, _) => AnnotatedRegion<SystemUiOverlayStyle>(
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
                            Text(
                              L.t('Masuk Untuk Melanjutkan'),
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (v) => _tr(Validators.loginId(v)),
                              style: const TextStyle(fontSize: 12),
                              decoration: _decoration(
                                  'Email atau Username', Icons.person_outline),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _passCtrl,
                              obscureText: _obscure,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _login(),
                              validator: (v) =>
                                  _tr(Validators.loginPassword(v)),
                              style: const TextStyle(fontSize: 12),
                              decoration: _decoration(
                                'Password',
                                Icons.lock_outline,
                                suffix: IconButton(
                                  iconSize: 18,
                                  icon: Icon(_obscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined),
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: Checkbox(
                                    value: _remember,
                                    activeColor: AppColors.primary,
                                    onChanged: (v) =>
                                        setState(() => _remember = v ?? false),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(L.t('Ingat saya'),
                                    style: const TextStyle(fontSize: 11)),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {}, // TODO: lupa password
                                  child: Text(
                                    L.t('Lupa password?'),
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.link,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GradientButton(
                              label: L.t('Masuk'),
                              onPressed: _login,
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Expanded(
                                    child: Divider(color: AppColors.border)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(L.t('Atau'),
                                      style: const TextStyle(fontSize: 11)),
                                ),
                                const Expanded(
                                    child: Divider(color: AppColors.border)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 42,
                              child: OutlinedButton.icon(
                                onPressed:
                                    _googleLoading ? null : _loginWithGoogle,
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: AppColors.textDark,
                                  side: const BorderSide(
                                      color: AppColors.border),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                ),
                                icon: _googleLoading
                                    ? const SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2),
                                      )
                                    : const Text('G',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF4285F4),
                                            fontSize: 15)),
                                label: Text(L.t('Masuk dengan Google'),
                                    style: const TextStyle(fontSize: 12)),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(L.t('Belum punya akun ? '),
                                    style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.textMuted)),
                                GestureDetector(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (_) => const RegisterScreen()),
                                  ),
                                  child: Text(
                                    L.t('Daftar sekarang'),
                                    style: const TextStyle(
                                      fontSize: 10,
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