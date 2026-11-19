import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/triage_enums.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../state/language_provider.dart';

/// Reusable application bar matching the Outpost Figma design specifications.
///
/// Features the brand wordmark "outpost", an optional back button, and an
/// interactive "বাংলা / EN" language toggle button connected to Riverpod.
class OutpostAppBar extends ConsumerWidget implements PreferredSizeWidget {
  /// Creates an [OutpostAppBar].
  const OutpostAppBar({
    super.key,
    this.showBackButton = true,
    this.title,
  });

  /// Whether to display a navigation back arrow.
  final bool showBackButton;

  /// Optional custom title text overriding the default brand wordmark.
  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);

    return SafeArea(
      bottom: false,
      child: Container(
        height: preferredSize.height,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Row(
          children: [
            if (showBackButton && Navigator.canPop(context)) ...[
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primaryTeal),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: AppSpacing.md),
            ],
            Expanded(
              child: Text(
                title ?? 'outpost',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryTeal,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            // Language switch toggle button (বাংলা / EN)
            InkWell(
              borderRadius: AppSpacing.badgeBorderRadius,
              onTap: () {
                ref.read(languageProvider.notifier).toggleLanguage();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.mdCompact,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: AppSpacing.badgeBorderRadius,
                ),
                child: Text(
                  currentLanguage == AppLanguage.bn
                      ? 'English'
                      : 'বাংলা',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primaryTeal,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
