import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';

/// Central theme configuration for the Outpost application.
///
/// Implements Material 3 with Noto Sans Bengali typography and design tokens
/// derived directly from the Figma design system.
abstract final class AppTheme {
  /// Builds the light [ThemeData] configured with Outpost brand colors,
  /// Material 3 styling, and Noto Sans Bengali typography.
  static ThemeData get lightTheme {
    final baseTextTheme = GoogleFonts.notoSansBengaliTextTheme();

    final customTextTheme = baseTextTheme.copyWith(
      displayLarge: GoogleFonts.notoSansBengali(
        fontSize: 40,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryTeal,
        height: 54 / 40,
      ),
      displayMedium: GoogleFonts.notoSansBengali(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 38 / 32,
      ),
      headlineLarge: GoogleFonts.notoSansBengali(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 32 / 24,
      ),
      headlineMedium: GoogleFonts.notoSansBengali(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 28 / 20,
      ),
      titleLarge: GoogleFonts.notoSansBengali(
        fontSize: 23,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryTeal,
        height: 32 / 23,
      ),
      titleMedium: GoogleFonts.notoSansBengali(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 24 / 17,
      ),
      bodyLarge: GoogleFonts.notoSansBengali(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textPrimary,
        height: 22 / 16,
      ),
      bodyMedium: GoogleFonts.notoSansBengali(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        height: 19 / 14,
      ),
      bodySmall: GoogleFonts.notoSansBengali(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        height: 17 / 12,
      ),
      labelSmall: GoogleFonts.notoSansBengali(
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: AppColors.textSecondary,
        height: 14 / 10,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primaryTeal,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.primaryTeal,
        secondaryContainer: AppColors.primaryLight,
        surface: AppColors.surfaceWhite,
        error: AppColors.emergencyRed,
        errorContainer: AppColors.emergencyRedLight,
        onPrimary: AppColors.surfaceWhite,
        onSurface: AppColors.textPrimary,
        outline: AppColors.outlineBorder,
      ),
      scaffoldBackgroundColor: AppColors.surfaceWhite,
      textTheme: customTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceWhite,
        foregroundColor: AppColors.primaryTeal,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.notoSansBengali(
          fontSize: 23,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryTeal,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryTeal,
          foregroundColor: AppColors.surfaceWhite,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.cardBorderRadius,
          ),
          elevation: 0,
          textStyle: GoogleFonts.notoSansBengali(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surfaceWhite,
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          side: const BorderSide(color: AppColors.outlineBorder),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.cardBorderRadius,
          ),
          textStyle: GoogleFonts.notoSansBengali(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.cardBorderRadius,
          side: BorderSide(color: AppColors.outlineBorder),
        ),
        margin: EdgeInsets.zero,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceBottomNav,
        selectedItemColor: AppColors.primaryTeal,
        unselectedItemColor: AppColors.textSecondary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
