import 'package:flutter/material.dart';

/// Design tokens and exact color palette extracted from Figma design specifications.
///
/// Design source: Outpost • Local components and 01 · Welcome frame
/// Primary brand teal, emergency red, clinician-today amber, home-care green,
/// clean card surfaces, and high-contrast typography colors.
abstract final class AppColors {
  // --- Primary Brand Palette ---

  /// Main primary teal green used for brand identity, primary buttons, and active states.
  /// Figma hex: #006B60
  static const Color primaryTeal = Color(0xFF006B60);

  /// Soft primary container tint used for secondary button backgrounds and accent chips.
  /// Figma hex: #EAF5F2
  static const Color primaryLight = Color(0xFFEAF5F2);

  /// Dark forest teal used for primary headings, tile titles, and dark text.
  /// Figma hex: #173C38
  static const Color textPrimary = Color(0xFF173C38);

  /// Muted sage/slate gray used for subtitles, secondary labels, and helper text.
  /// Figma hex: #536C68
  static const Color textSecondary = Color(0xFF536C68);

  // --- Triage Severity Palettes ---

  /// Emergency red used for critical danger alert buttons, red badges, and error states.
  /// Figma hex: #B3261E
  static const Color emergencyRed = Color(0xFFB3261E);

  /// Light red background used for Emergency triage badge containers.
  /// Figma hex: #FCE9E7
  static const Color emergencyRedLight = Color(0xFFFCE9E7);

  /// Deep amber used for "See a clinician today" triage badges and warning text.
  /// Figma hex: #825500
  static const Color clinicianTodayAmber = Color(0xFF825500);

  /// Light warm amber background used for "See a clinician today" triage badges.
  /// Figma hex: #FFF0D2
  static const Color clinicianTodayAmberLight = Color(0xFFFFF0D2);

  /// Forest green used for "Home care" triage badges and success confirmations.
  /// Figma hex: #226C39
  static const Color homeCareGreen = Color(0xFF226C39);

  /// Light mint green background used for "Home care" triage badges.
  /// Figma hex: #E7F4E9
  static const Color homeCareGreenLight = Color(0xFFE7F4E9);

  // --- Surfaces & Neutral Backgrounds ---

  /// Pure white screen scaffold and answer button background.
  /// Figma hex: #FFFFFF
  static const Color surfaceWhite = Color(0xFFFFFFFF);

  /// Soft tinted surface for selection cards and tile widgets.
  /// Figma hex: #F2F8F6
  static const Color surfaceCard = Color(0xFFF2F8F6);

  /// Light background surface used on component library sections.
  /// Figma hex: #F4F8F6
  static const Color surfaceComponent = Color(0xFFF4F8F6);

  /// Very light tint used on the bottom navigation bar.
  /// Figma hex: #F5F9F7
  static const Color surfaceBottomNav = Color(0xFFF5F9F7);

  /// Subtle gray-green border outline used on cards, answer buttons, and tiles.
  /// Figma hex: #D6E5E1
  static const Color outlineBorder = Color(0xFFD6E5E1);

  // --- Utility & Gesture Colors ---

  /// Gesture navigation bar pill handle color.
  /// Figma hex: #173C38
  static const Color gestureHandle = Color(0xFF173C38);
}
