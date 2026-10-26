import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? borderColor;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderColor,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(20);
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: gradient == null ? AppColors.surface : null,
          gradient: gradient,
          borderRadius: radius,
          border: Border.all(color: borderColor ?? AppColors.outline),
        ),
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Numbered section title ("1  Input Data Akun").
class StepHeader extends StatelessWidget {
  final int number;
  final String title;
  final String? trailing;

  const StepHeader(
      {super.key, required this.number, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('$number',
              style: AppText.mono(13, color: AppColors.bg, w: FontWeight.w800)),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(title, style: AppText.heading(18))),
        if (trailing != null) Text(trailing!, style: AppText.body(12)),
      ],
    );
  }
}

class Chip2 extends StatelessWidget {
  final String text;
  final Color color;

  const Chip2(this.text, {super.key, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.o(0.16),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text.toUpperCase(),
          style: AppText.mono(10, color: color, w: FontWeight.w700)),
    );
  }
}

class NeonButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color color;
  final Color foreground;
  final bool loading;

  const NeonButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color = AppColors.primary,
    this.foreground = AppColors.bg,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: foreground,
        disabledBackgroundColor: color.o(0.5),
        minimumSize: const Size.fromHeight(54),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: loading
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.5, color: foreground),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: AppText.heading(16, color: foreground)),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, size: 20),
                ],
              ],
            ),
    );
  }
}

class GameIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;

  const GameIconBox(
      {super.key, required this.icon, required this.color, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.o(0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.o(0.35)),
      ),
      child: Icon(icon, color: color, size: size * 0.52),
    );
  }
}

void showAppSnack(BuildContext context, String message, {bool error = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: error ? AppColors.danger : AppColors.surfaceHigh,
      content: Text(message, style: AppText.body(14, color: AppColors.text)),
    ));
}
