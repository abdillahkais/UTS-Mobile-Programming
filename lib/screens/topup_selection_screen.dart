import 'package:flutter/material.dart';

import '../models/game.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'topup_form_screen.dart';

class TopUpSelectionScreen extends StatefulWidget {
  const TopUpSelectionScreen({super.key});

  @override
  State<TopUpSelectionScreen> createState() => _TopUpSelectionScreenState();
}

class _TopUpSelectionScreenState extends State<TopUpSelectionScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final games = Catalog.games
        .where((g) => g.name.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Top Up Game')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text('DIRECT VAULT ACCESS',
              style: AppText.mono(11, color: AppColors.primary)),
          const SizedBox(height: 6),
          Text('Pilih Game Favorit Kamu', style: AppText.heading(24)),
          const SizedBox(height: 6),
          Text(
            'Top up diamond, cash, atau voucher instan dalam hitungan detik '
            'dengan garansi akun 100% aman.',
            style: AppText.body(13),
          ),
          const SizedBox(height: 18),
          TextField(
            onChanged: (v) => setState(() => _query = v),
            style: AppText.body(15, color: AppColors.text),
            decoration: const InputDecoration(
              hintText: 'Cari game (MLBB, Valorant, FF...)',
              prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 18),
          if (games.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Center(
                  child: Text('Game tidak ditemukan', style: AppText.body(14))),
            ),
          for (final g in games) ...[
            AppCard(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TopUpFormScreen(game: g)),
              ),
              child: Row(
                children: [
                  GameIconBox(icon: g.icon, color: g.accent, size: 54),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(g.name, style: AppText.heading(18)),
                        const SizedBox(height: 4),
                        Text('${g.publisher} • ${g.idLabel}',
                            style: AppText.mono(12,
                                color: AppColors.textMuted,
                                w: FontWeight.w400)),
                      ],
                    ),
                  ),
                  const Chip2('Instan', color: AppColors.tertiary),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right, color: AppColors.textMuted),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}
