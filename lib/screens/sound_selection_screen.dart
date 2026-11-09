import 'package:flutter/material.dart';

import '../models/sound_settings.dart';
import '../theme/app_theme.dart';
import '../widgets/icon_badge.dart';
import '../widgets/tr.dart';

class _Sound {
  final String name;
  final String note;
  final String emoji; // dipakai jika file gambar belum ada
  final String image;
  const _Sound(this.name, this.note, this.emoji, this.image);
}

/// Halaman Pemilihan Suara: pilih satu suara predator atau Mode Acak.
class SoundSelectionScreen extends StatefulWidget {
  const SoundSelectionScreen({super.key});

  @override
  State<SoundSelectionScreen> createState() => _SoundSelectionScreenState();
}

class _SoundSelectionScreenState extends State<SoundSelectionScreen> {
  final _settings = SoundSettings.instance;
  int? _playing; // suara yang sedang "diputar" untuk pratinjau

  static const _selectedBg = Color(0xFFE8F5E9);

  static const _sounds = [
    _Sound('Suara Elang', 'Paling efektif (rekomendasi)', '🦅',
        'assets/images/suara_elang.png'),
    _Sound('Suara Burung Hantu', 'Rekomendasi', '🦉',
        'assets/images/suara_burung_hantu.png'),
    _Sound('Suara Rubah', 'Rekomendasi', '🦊',
        'assets/images/suara_rubah.png'),
    _Sound('Suara Ular', 'Rekomendasi', '🐍',
        'assets/images/suara_ular.png'),
    _Sound('Suara Anjing', 'Rekomendasi', '🐕',
        'assets/images/suara_anjing.png'),
  ];

  void _togglePlay(int index) {
    // TODO: putar audio pratinjau (mis. paket audioplayers).
    setState(() => _playing = _playing == index ? null : index);
  }

  void _pickRandom() {
    setState(() => _playing = null);
    _settings.selectRandom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _settings,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text('Pemilihan Suara',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 16),
              _tabLabel(),
              const SizedBox(height: 20),
              for (int i = 0; i < _sounds.length; i++) _soundRow(i),
              const SizedBox(height: 28),
              _randomCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabLabel() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        child: const Text('Daftar suara',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary)),
      ),
    );
  }

  Widget _soundRow(int i) {
    final s = _sounds[i];
    final selected = _settings.selected == i;
    final playing = _playing == i;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: selected ? _selectedBg : Colors.white,
        borderRadius: BorderRadius.circular(6),
        elevation: 3,
        shadowColor: AppColors.shadow,
        child: InkWell(
          borderRadius: BorderRadius.circular(6),
          onTap: () => _settings.select(i),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                _thumb(s),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.name,
                          style: const TextStyle(
                              fontSize: 11, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 1),
                      Text(s.note,
                          style: const TextStyle(
                              fontSize: 8, color: AppColors.textMuted)),
                    ],
                  ),
                ),
                _radio(selected),
                const SizedBox(width: 8),
                InkResponse(
                  onTap: () => _togglePlay(i),
                  radius: 18,
                  child: Icon(
                    playing
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outline,
                    size: 22,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _thumb(_Sound s) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [
          BoxShadow(
              color: AppColors.shadow, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          s.image,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Center(
            child: Text(s.emoji, style: const TextStyle(fontSize: 26)),
          ),
        ),
      ),
    );
  }

  Widget _radio(bool selected) {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: selected ? AppColors.primary : AppColors.textDark,
            width: 1.5),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            )
          : null,
    );
  }

  Widget _randomCard() {
    final on = _settings.isRandom;
    return Material(
      // Putih seperti kartu suara hewan; hijau muda hanya saat dipilih.
      color: on ? _selectedBg : Colors.white,
      elevation: 3,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
        side: on
            ? const BorderSide(color: AppColors.online, width: 1.5)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: _pickRandom,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IconBadge(icon: Icons.shuffle, radius: 16),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mode Acak',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w600)),
                    SizedBox(height: 4),
                    Text(
                      'Sistem akan memutar suara secara acak berdasarkan aturan yang telah ditentukan.',
                      style: TextStyle(
                          fontSize: 8, height: 1.5, color: AppColors.textDark),
                    ),
                  ],
                ),
              ),
              if (on)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check_circle,
                      size: 20, color: AppColors.primary),
                ),
            ],
          ),
        ),
      ),
    );
  }
}