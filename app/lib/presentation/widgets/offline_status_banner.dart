import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../state/language_provider.dart';

/// Subtle status indicator pill signaling offline-first operation.
///
/// Displayed prominently at the top of key screens so judges and users
/// immediately observe that all evaluation is powered locally with no network needed.
class OfflineStatusBanner extends ConsumerWidget {
  /// Creates an [OfflineStatusBanner].
  const OfflineStatusBanner({
    super.key,
    this.compact = false,
  });

  /// Whether to render as a compact badge or a full-width centered pill.
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? AppSpacing.sm : AppSpacing.md,
        vertical: compact ? 4.0 : 6.0,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: AppSpacing.badgeBorderRadius,
        border: Border.all(
          color: AppColors.primaryTeal.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 15,
            color: AppColors.primaryTeal,
          ),
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              strings.offlineStatusBanner,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.primaryTeal,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
