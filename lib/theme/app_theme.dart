import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Palette taken from the design board (cyan primary, purple secondary,
/// green tertiary, charcoal neutral).
class AppColors {
  static const bg = Color(0xFF0B0E17);
  static const surface = Color(0xFF161A26);
  static const surfaceHigh = Color(0xFF1E2333);
  static const outline = Color(0xFF2A3045);

  static const primary = Color(0xFF00F0FF);
  static const secondary = Color(0xFF9B5CFF);
  static const tertiary = Color(0xFF10B981);
  static const danger = Color(0xFFFF5470);

  static const text = Color(0xFFE8ECF8);
  static const textMuted = Color(0xFF8E96B0);
}

extension ColorOpacity on Color {
  /// Opacity helper that works across Flutter versions (no deprecation).
  Color o(double opacity) => withAlpha((opacity * 255).round().clamp(0, 255));
}

class AppText {
  /// Headlines - Space Grotesk
  static TextStyle heading(double size,
          {Color color = AppColors.text, FontWeight w = FontWeight.w700}) =>
      GoogleFonts.spaceGrotesk(fontSize: size, fontWeight: w, color: color);

  /// Body - Plus Jakarta Sans
  static TextStyle body(double size,
          {Color color = AppColors.textMuted, FontWeight w = FontWeight.w400}) =>
      GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: w, color: color);

  /// Labels / numbers - JetBrains Mono
  static TextStyle mono(double size,
          {Color color = AppColors.primary, FontWeight w = FontWeight.w600}) =>
      GoogleFonts.jetBrainsMono(fontSize: size, fontWeight: w, color: color);
}

class AppTheme {
  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);

    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c, width: w),
        );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Color(0xFF00363A),
        secondary: AppColors.secondary,
        tertiary: AppColors.tertiary,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme)
          .apply(bodyColor: AppColors.text, displayColor: AppColors.text),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.text),
        titleTextStyle: AppText.heading(20, w: FontWeight.w600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.bg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: AppText.body(14, color: AppColors.textMuted.o(0.7)),
        labelStyle: AppText.body(14),
        floatingLabelStyle: AppText.body(13, color: AppColors.primary),
        errorStyle: AppText.body(12, color: AppColors.danger),
        border: border(AppColors.outline),
        enabledBorder: border(AppColors.outline),
        focusedBorder: border(AppColors.primary, 1.5),
        errorBorder: border(AppColors.danger),
        focusedErrorBorder: border(AppColors.danger, 1.5),
      ),
      dividerColor: AppColors.outline,
    );
  }
}
