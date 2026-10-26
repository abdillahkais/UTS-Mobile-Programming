import 'package:flutter/material.dart';

import '../models/game.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';
import 'open_mabar_screen.dart';
import 'topup_form_screen.dart';
import 'topup_selection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            const _Header(),
            const SizedBox(height: 20),
            const _PromoBanner(),
            const SizedBox(height: 20),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.diamond_outlined,
                      color: AppColors.primary,
                      title: 'Top Up Game',
                      subtitle: 'Instan & terpercaya 24/7',
                      cta: 'BELI SEKARANG',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const TopUpSelectionScreen()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _FeatureCard(
                      icon: Icons.headset_mic_outlined,
                      color: AppColors.secondary,
                      title: 'Open Mabar',
                      subtitle: 'Cari teman & voice party',
                      cta: 'JOIN ROOM',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const OpenMabarScreen()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text('Game Populer', style: AppText.heading(22)),
            const SizedBox(height: 2),
            Text('Paling sering di-top up & mabar', style: AppText.body(13)),
            const SizedBox(height: 14),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: Catalog.games.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 128,
              ),
              itemBuilder: (context, i) {
                final g = Catalog.games[i];
                return AppCard(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => TopUpFormScreen(game: g)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GameIconBox(icon: g.icon, color: g.accent, size: 40),
                      const Spacer(),
                      Text(g.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.heading(16)),
                      const SizedBox(height: 2),
                      Text(g.genre, style: AppText.body(12)),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceHigh,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.o(0.4)),
          ),
          child: const Icon(Icons.sports_esports, color: AppColors.primary),
        ),
        const SizedBox(width: 10),
        Text('Urakan', style: AppText.heading(24, color: AppColors.primary)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outline),
          ),
          child: Row(
            children: [
              const Icon(Icons.circle, size: 8, color: AppColors.tertiary),
              const SizedBox(width: 6),
              Text('ONLINE',
                  style: AppText.mono(11, color: AppColors.tertiary)),
            ],
          ),
        ),
      ],
    );
  }
}

class _PromoBanner extends StatelessWidget {
  const _PromoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.secondary.o(0.55), AppColors.surface],
        ),
        border: Border.all(color: AppColors.secondary.o(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Chip2('Weekend Event', color: AppColors.primary),
          const SizedBox(height: 14),
          Text('Weekend Push Rank', style: AppText.heading(24)),
          const SizedBox(height: 6),
          Text('Cashback 30% Top Up & Double EXP Party Discord',
              style: AppText.body(13, color: AppColors.text)),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final String cta;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.cta,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      borderColor: color.o(0.35),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [color.o(0.16), AppColors.surface],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GameIconBox(icon: icon, color: color, size: 44),
          const SizedBox(height: 16),
          Text(title, style: AppText.heading(19)),
          const SizedBox(height: 4),
          Text(subtitle,
              maxLines: 2, overflow: TextOverflow.ellipsis, style: AppText.body(12)),
          const SizedBox(height: 14),
          Row(
            children: [
              Flexible(
                child: Text(cta,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.mono(11, color: color)),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward, size: 14, color: color),
            ],
          ),
        ],
      ),
    );
  }
}
