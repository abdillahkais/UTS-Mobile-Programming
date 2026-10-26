import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class TopUpPackage {
  final String label; // e.g. "86 Diamonds"
  final int price; // in Rupiah
  final String? bonus; // e.g. "+8 Bonus"
  final String? badge; // e.g. "POPULAR"

  const TopUpPackage(this.label, this.price, {this.bonus, this.badge});
}

class Game {
  final String id;
  final String name;
  final String publisher;
  final String genre;
  final String idLabel; // "User ID", "Riot ID", ...
  final String idHint;
  final bool numericId;
  final bool needsZone; // MLBB needs Zone ID
  final Color accent;
  final IconData icon;
  final String discordUrl;
  final List<TopUpPackage> packages;

  const Game({
    required this.id,
    required this.name,
    required this.publisher,
    required this.genre,
    required this.idLabel,
    required this.idHint,
    required this.accent,
    required this.icon,
    required this.discordUrl,
    required this.packages,
    this.numericId = true,
    this.needsZone = false,
  });
}

class PaymentMethod {
  final String name;
  final String detail;
  final int fee;
  final IconData icon;

  const PaymentMethod(this.name, this.detail, this.fee, this.icon);
}

String formatRupiah(int value) {
  final s = value.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp $buf';
}

class Catalog {
  // TODO: replace every discordUrl with your real invite links.
  static const games = <Game>[
    Game(
      id: 'mlbb',
      name: 'Mobile Legends',
      publisher: 'Moonton',
      genre: 'MOBA',
      idLabel: 'User ID',
      idHint: 'Contoh: 12345678',
      needsZone: true,
      accent: AppColors.primary,
      icon: Icons.shield_outlined,
      discordUrl: 'https://discord.gg/REPLACE_MLBB',
      packages: [
        TopUpPackage('86 Diamonds', 21000, bonus: '+8 Bonus'),
        TopUpPackage('172 Diamonds', 42000, bonus: '+16 Bonus'),
        TopUpPackage('257 Diamonds', 63000,
            bonus: '+23 Bonus', badge: 'POPULAR'),
        TopUpPackage('706 Diamonds', 170000, bonus: '+64 Bonus'),
        TopUpPackage('2195 Diamonds', 525000, bonus: 'Mega Pack'),
        TopUpPackage('Weekly Pass', 28500, badge: 'SPECIAL'),
      ],
    ),
    Game(
      id: 'valorant',
      name: 'Valorant',
      publisher: 'Riot Games',
      genre: 'Tactical FPS',
      idLabel: 'Riot ID',
      idHint: 'Contoh: NamaKamu#1234',
      numericId: false,
      accent: AppColors.danger,
      icon: Icons.gps_fixed,
      discordUrl: 'https://discord.gg/REPLACE_VALORANT',
      packages: [
        TopUpPackage('475 VP', 57000),
        TopUpPackage('1000 VP', 115000, badge: 'POPULAR'),
        TopUpPackage('2050 VP', 229000, bonus: '+Bonus'),
        TopUpPackage('3650 VP', 400000, bonus: 'Mega Pack'),
      ],
    ),
    Game(
      id: 'freefire',
      name: 'Free Fire',
      publisher: 'Garena',
      genre: 'Battle Royale',
      idLabel: 'Player ID',
      idHint: 'Contoh: 123456789',
      accent: Color(0xFFFF8A3D),
      icon: Icons.local_fire_department_outlined,
      discordUrl: 'https://discord.gg/REPLACE_FREEFIRE',
      packages: [
        TopUpPackage('70 Diamonds', 10000),
        TopUpPackage('140 Diamonds', 20000),
        TopUpPackage('355 Diamonds', 50000, badge: 'POPULAR'),
        TopUpPackage('720 Diamonds', 100000, bonus: '+Bonus'),
        TopUpPackage('1450 Diamonds', 200000, bonus: 'Mega Pack'),
      ],
    ),
    Game(
      id: 'pubgm',
      name: 'PUBG Mobile',
      publisher: 'Level Infinite',
      genre: 'Battle Royale',
      idLabel: 'UID Akun',
      idHint: 'Contoh: 5123456789',
      accent: AppColors.tertiary,
      icon: Icons.military_tech_outlined,
      discordUrl: 'https://discord.gg/REPLACE_PUBGM',
      packages: [
        TopUpPackage('60 UC', 15000),
        TopUpPackage('325 UC', 75000, badge: 'POPULAR'),
        TopUpPackage('660 UC', 150000, bonus: '+Bonus'),
        TopUpPackage('1800 UC', 400000, bonus: 'Mega Pack'),
      ],
    ),
  ];

  static const payments = <PaymentMethod>[
    PaymentMethod(
        'QRIS Instant', 'GoPay, OVO, Dana, ShopeePay', 1000, Icons.qr_code_2),
    PaymentMethod('E-Wallet Direct', 'GoPay, OVO, DANA, ShopeePay', 1500,
        Icons.account_balance_wallet_outlined),
    PaymentMethod('Virtual Account Bank', 'BCA, Mandiri, BRI, BNI, Permata',
        2000, Icons.account_balance_outlined),
    PaymentMethod('Transfer Bank', 'Transfer manual + verifikasi', 2500,
        Icons.swap_horiz),
  ];
}
