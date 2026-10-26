import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/game.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class OpenMabarScreen extends StatefulWidget {
  const OpenMabarScreen({super.key});

  @override
  State<OpenMabarScreen> createState() => _OpenMabarScreenState();
}

class _OpenMabarScreenState extends State<OpenMabarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nickC = TextEditingController();
  Game? _game;
  bool _loading = false;

  @override
  void dispose() {
    _nickC.dispose();
    super.dispose();
  }

  String? _validateNick(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Nickname wajib diisi';
    if (t.length < 3) return 'Minimal 3 karakter';
    if (t.length > 24) return 'Maksimal 24 karakter';
    return null;
  }

  Future<void> _confirm() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final game = _game!;
    setState(() => _loading = true);

    try {
      final uri = Uri.parse(game.discordUrl);
      // externalApplication opens the Discord app if installed, else browser.
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!mounted) return;
      if (!ok) {
        showAppSnack(context, 'Tidak bisa membuka Discord. Coba lagi.',
            error: true);
      }
    } catch (_) {
      if (!mounted) return;
      showAppSnack(context, 'Link Discord tidak valid atau gagal dibuka.',
          error: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Open Mabar')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          const Row(
            children: [
              Chip2('LFG System V2.4', color: AppColors.secondary),
              SizedBox(width: 8),
              Chip2('Discord Voice', color: AppColors.tertiary),
            ],
          ),
          const SizedBox(height: 12),
          Text('Cari Teman & Voice Party', style: AppText.heading(26)),
          const SizedBox(height: 6),
          Text('Temukan squad mabar sefrekuensi, rank match, atau custom '
              'scrim sekarang!',
              style: AppText.body(14)),
          const SizedBox(height: 20),
          AppCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nickC,
                    validator: _validateNick,
                    textInputAction: TextInputAction.done,
                    style: AppText.body(15, color: AppColors.text),
                    decoration: const InputDecoration(
                      labelText: 'Gamer Name / Nickname',
                      hintText: 'mis. ValkyrieQueen',
                      prefixIcon: Icon(Icons.badge_outlined, size: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<Game>(
                    value: _game,
                    isExpanded: true,
                    dropdownColor: AppColors.surfaceHigh,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    validator: (v) => v == null ? 'Pilih game dulu' : null,
                    decoration: const InputDecoration(
                      labelText: 'Pilih Game',
                      prefixIcon: Icon(Icons.sports_esports_outlined, size: 20),
                    ),
                    items: [
                      for (final g in Catalog.games)
                        DropdownMenuItem(
                          value: g,
                          child: Text(g.name,
                              style: AppText.body(15, color: AppColors.text)),
                        ),
                    ],
                    onChanged: (g) => setState(() => _game = g),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            borderColor: AppColors.secondary.o(0.4),
            gradient: LinearGradient(
              colors: [AppColors.secondary.o(0.22), AppColors.surface],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GameIconBox(
                    icon: Icons.graphic_eq, color: AppColors.secondary),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Discord Auto-Role Channel',
                          style: AppText.heading(15,
                              color: const Color(0xFFD9C2FF))),
                      const SizedBox(height: 6),
                      Text(
                        'Kamu akan langsung diarahkan ke channel Discord '
                        'resmi untuk game pilihanmu. Di sana kamu bisa '
                        'join Voice Channel, tag role squad, dan mabar '
                        'tanpa delay.',
                        style: AppText.body(12, color: AppColors.text),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          NeonButton(
            label: 'Konfirmasi',
            icon: Icons.arrow_forward,
            color: AppColors.secondary,
            foreground: Colors.white,
            loading: _loading,
            onPressed: _confirm,
          ),
          const SizedBox(height: 12),
          Center(
            child: Text('Privasi akun aman • Anti-Toxic Verified Squad',
                style: AppText.body(11)),
          ),
        ],
      ),
    );
  }
}
