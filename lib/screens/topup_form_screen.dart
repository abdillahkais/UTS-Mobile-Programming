import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/game.dart';
import '../theme/app_theme.dart';
import '../widgets/common.dart';

class TopUpFormScreen extends StatefulWidget {
  final Game game;

  const TopUpFormScreen({super.key, required this.game});

  @override
  State<TopUpFormScreen> createState() => _TopUpFormScreenState();
}

class _TopUpFormScreenState extends State<TopUpFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _idC = TextEditingController();
  final _zoneC = TextEditingController();
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();

  TopUpPackage? _package;
  PaymentMethod? _payment;

  Game get game => widget.game;

  int get _total => (_package?.price ?? 0) + (_payment?.fee ?? 0);

  @override
  void dispose() {
    _idC.dispose();
    _zoneC.dispose();
    _nameC.dispose();
    _emailC.dispose();
    _phoneC.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- validators

  String? _validateGameId(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return '${game.idLabel} wajib diisi';
    if (game.numericId) {
      if (!RegExp(r'^\d{5,15}$').hasMatch(t)) {
        return '${game.idLabel} harus angka (5-15 digit)';
      }
    } else if (game.id == 'valorant') {
      if (!RegExp(r'^.{3,16}#[A-Za-z0-9]{3,5}$').hasMatch(t)) {
        return 'Format Riot ID: Nama#Tag';
      }
    } else if (t.length < 3) {
      return '${game.idLabel} tidak valid';
    }
    return null;
  }

  String? _validateZone(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Zone ID wajib';
    if (!RegExp(r'^\d{3,5}$').hasMatch(t)) return '3-5 digit angka';
    return null;
  }

  String? _validateName(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Nama akun wajib diisi';
    if (t.length < 3) return 'Minimal 3 karakter';
    return null;
  }

  String? _validateEmail(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return 'Email wajib diisi';
    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(t)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  String? _validatePhone(String? v) {
    final t = (v ?? '').replaceAll(RegExp(r'[\s-]'), '');
    if (t.isEmpty) return 'No. HP wajib diisi';
    if (!RegExp(r'^(\+62|62|0)8\d{8,11}$').hasMatch(t)) {
      return 'Gunakan nomor Indonesia, mis. 0812xxxxxxx';
    }
    return null;
  }

  // -------------------------------------------------------------------- submit

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      showAppSnack(context, 'Lengkapi data dengan benar dulu ya.', error: true);
      return;
    }

    final invoice =
        'GH-${(DateTime.now().millisecondsSinceEpoch % 100000).toString().padLeft(5, '0')}';
    final accountId = game.needsZone
        ? '${_idC.text.trim()} (${_zoneC.text.trim()})'
        : _idC.text.trim();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.outline),
        ),
        title: Text('Ringkasan Pesanan', style: AppText.heading(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SummaryRow('Game', game.name),
            _SummaryRow('${game.idLabel}', accountId),
            _SummaryRow('Nama Akun', _nameC.text.trim()),
            _SummaryRow('Item', _package!.label),
            _SummaryRow('Pembayaran', _payment!.name),
            _SummaryRow('Harga', formatRupiah(_package!.price)),
            _SummaryRow('Biaya Admin', formatRupiah(_payment!.fee)),
            const Divider(height: 24),
            _SummaryRow('Total', formatRupiah(_total), highlight: true),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Batal', style: AppText.body(14)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Bayar Sekarang',
                style: AppText.heading(14, color: AppColors.primary)),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    // TODO: call your payment gateway / backend here (Midtrans, Xendit, etc.).
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.outline),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle,
                color: AppColors.tertiary, size: 64),
            const SizedBox(height: 14),
            Text('Pesanan Dibuat!', style: AppText.heading(20)),
            const SizedBox(height: 6),
            Text('Invoice #$invoice',
                style: AppText.mono(13, color: AppColors.primary)),
            const SizedBox(height: 8),
            Text(
              'Instruksi pembayaran dikirim ke ${_emailC.text.trim()}.',
              textAlign: TextAlign.center,
              style: AppText.body(13),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('OK',
                style: AppText.heading(15, color: AppColors.primary)),
          ),
        ],
      ),
    );

    if (!mounted) return;
    Navigator.of(context).popUntil((r) => r.isFirst);
  }

  // --------------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Checkout')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          children: [
            _gameBanner(),
            const SizedBox(height: 16),
            _accountSection(),
            const SizedBox(height: 16),
            _packageSection(),
            const SizedBox(height: 16),
            _paymentSection(),
          ],
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _gameBanner() {
    return AppCard(
      borderColor: game.accent.o(0.4),
      gradient: LinearGradient(
        colors: [game.accent.o(0.18), AppColors.surface],
      ),
      child: Row(
        children: [
          GameIconBox(icon: game.icon, color: game.accent, size: 56),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${game.publisher} • OFFICIAL PARTNER',
                    style: AppText.mono(10,
                        color: AppColors.textMuted, w: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(game.name, style: AppText.heading(21)),
                const SizedBox(height: 6),
                const Row(
                  children: [
                    Chip2('Layanan Online', color: AppColors.tertiary),
                    SizedBox(width: 6),
                    Chip2('Instant'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _accountSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(number: 1, title: 'Input Data Akun'),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _idC,
                  validator: _validateGameId,
                  keyboardType: game.numericId
                      ? TextInputType.number
                      : TextInputType.text,
                  inputFormatters: game.numericId
                      ? [FilteringTextInputFormatter.digitsOnly]
                      : null,
                  textInputAction: TextInputAction.next,
                  style: AppText.mono(15, color: AppColors.text),
                  decoration: InputDecoration(
                    labelText: 'Game ID • ${game.idLabel}',
                    hintText: game.idHint,
                  ),
                ),
              ),
              if (game.needsZone) ...[
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _zoneC,
                    validator: _validateZone,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(5),
                    ],
                    textInputAction: TextInputAction.next,
                    style: AppText.mono(15, color: AppColors.text),
                    decoration: const InputDecoration(
                        labelText: 'Zone ID', hintText: '2024'),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _nameC,
            validator: _validateName,
            textInputAction: TextInputAction.next,
            style: AppText.body(15, color: AppColors.text),
            decoration: const InputDecoration(
              labelText: 'Account Name',
              hintText: 'Nickname di dalam game',
              prefixIcon: Icon(Icons.verified_user_outlined, size: 20),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _emailC,
            validator: _validateEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: AppText.body(15, color: AppColors.text),
            decoration: const InputDecoration(
              labelText: 'Email Bukti Transaksi',
              hintText: 'nama@email.com',
              prefixIcon: Icon(Icons.mail_outline, size: 20),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _phoneC,
            validator: _validatePhone,
            keyboardType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9+\- ]')),
            ],
            style: AppText.mono(15, color: AppColors.text),
            decoration: const InputDecoration(
              labelText: 'No. HP (WhatsApp)',
              hintText: '0812-3456-7890',
              prefixIcon: Icon(Icons.chat_outlined, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _packageSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
              number: 2, title: 'Pilih Nominal Top-Up', trailing: '100% LEGAL'),
          const SizedBox(height: 14),
          FormField<TopUpPackage>(
            validator: (_) => _package == null ? 'Pilih nominal top-up' : null,
            builder: (state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LayoutBuilder(builder: (context, c) {
                  final w = (c.maxWidth - 12) / 2;
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final p in game.packages)
                        SizedBox(
                          width: w,
                          child: _PackageTile(
                            package: p,
                            accent: game.accent,
                            selected: identical(_package, p),
                            onTap: () {
                              setState(() => _package = p);
                              state.didChange(p);
                            },
                          ),
                        ),
                    ],
                  );
                }),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(state.errorText!,
                        style: AppText.body(12, color: AppColors.danger)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentSection() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const StepHeader(
              number: 3,
              title: 'Pilih Pembayaran',
              trailing: 'Biaya admin rendah'),
          const SizedBox(height: 14),
          FormField<PaymentMethod>(
            validator: (_) =>
                _payment == null ? 'Pilih metode pembayaran' : null,
            builder: (state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final m in Catalog.payments) ...[
                  _PaymentTile(
                    method: m,
                    selected: identical(_payment, m),
                    onTap: () {
                      setState(() => _payment = m);
                      state.didChange(m);
                    },
                  ),
                  const SizedBox(height: 10),
                ],
                if (state.hasError)
                  Text(state.errorText!,
                      style: AppText.body(12, color: AppColors.danger)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.outline)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('TOTAL TAGIHAN', style: AppText.body(12)),
                  Text(
                    _package == null || _payment == null
                        ? '-'
                        : formatRupiah(_total),
                    style: AppText.mono(20),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              NeonButton(
                label: 'Konfirmasi Pembayaran',
                icon: Icons.lock_outline,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------- sub-widgets

class _PackageTile extends StatelessWidget {
  final TopUpPackage package;
  final Color accent;
  final bool selected;
  final VoidCallback onTap;

  const _PackageTile({
    required this.package,
    required this.accent,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.outline;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.o(0.08) : AppColors.bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: selected ? 1.6 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.diamond_outlined, size: 18, color: accent),
                const Spacer(),
                if (selected)
                  const Icon(Icons.check_circle,
                      size: 18, color: AppColors.primary)
                else if (package.badge != null)
                  Chip2(package.badge!, color: AppColors.secondary),
              ],
            ),
            const SizedBox(height: 10),
            Text(package.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppText.heading(16)),
            if (package.bonus != null) ...[
              const SizedBox(height: 4),
              Text(package.bonus!,
                  style: AppText.mono(11, color: AppColors.tertiary)),
            ],
            const SizedBox(height: 8),
            Text(formatRupiah(package.price),
                style: AppText.mono(13, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final PaymentMethod method;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentTile(
      {required this.method, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.o(0.08) : AppColors.bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.outline,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surfaceHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(method.icon, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(method.name, style: AppText.heading(15)),
                  const SizedBox(height: 2),
                  Text(method.detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppText.body(11)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text('+${formatRupiah(method.fee)}',
                style: AppText.mono(11, color: AppColors.textMuted)),
            const SizedBox(width: 8),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: selected ? AppColors.primary : AppColors.textMuted,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _SummaryRow(this.label, this.value, {this.highlight = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppText.body(13)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: highlight
                  ? AppText.mono(16)
                  : AppText.body(13, color: AppColors.text, w: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
