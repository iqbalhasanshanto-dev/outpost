import 'package:flutter/material.dart';

/// Spacing and border radii design tokens extracted from Figma design specifications.
///
/// Design source: Outpost • Local components and 01 · Welcome frame
abstract final class AppSpacing {
  /// Extra small spacing (4px).
  static const double xs = 4.0;

  /// Small spacing (8px).
  static const double sm = 8.0;

  /// Compact gap spacing (10px).
  static const double mdCompact = 10.0;

  /// Medium spacing (12px).
  static const double md = 12.0;

  /// Base content spacing (16px).
  static const double base = 16.0;

  /// Standard screen horizontal and card padding (20px).
  static const double lg = 20.0;

  /// Section padding (24px).
  static const double xl = 24.0;

  /// Hero top spacing (32px).
  static const double xxl = 32.0;

  // --- Dimension constants ---

  /// Fixed button height used throughout the application (64px).
  static const double buttonHeight = 64.0;

  /// Card height for intake options (104px).
  static const double cardHeight = 104.0;

  /// Tile height for compact grid options (91px).
  static const double tileHeight = 91.0;

  /// Tile width for compact grid options (100px).
  static const double tileWidth = 100.0;

  /// Bottom navigation bar height (68px).
  static const double bottomNavHeight = 68.0;

  // --- Radii ---

  /// Rounded corner radius for badges and chips (10px).
  static const double radiusBadge = 10.0;

  /// Rounded corner radius for buttons, cards, and option tiles (20px).
  static const double radiusCard = 20.0;

  /// Rounded corner radius for the hero medical cross emblem (30px).
  static const double radiusHeroIcon = 30.0;

  /// [BorderRadius] for badges and chips (10px).
  static const BorderRadius badgeBorderRadius = BorderRadius.all(
    Radius.circular(radiusBadge),
  );

  /// [BorderRadius] for buttons, cards, and option tiles (20px).
  static const BorderRadius cardBorderRadius = BorderRadius.all(
    Radius.circular(radiusCard),
  );

  /// [BorderRadius] for the hero icon container (30px).
  static const BorderRadius heroIconBorderRadius = BorderRadius.all(
    Radius.circular(radiusHeroIcon),
  );
}
